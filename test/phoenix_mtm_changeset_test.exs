defmodule PhoenixMTM.ChangesetTest do
  use ExUnit.Case, async: true
  doctest PhoenixMTM.Changeset

  alias Ecto.Integration.TestRepo

  defmodule Tag do
    use Ecto.Schema

    schema "tags" do
    end
  end

  defmodule Photo do
    use Ecto.Schema
    import Ecto.Changeset, only: [cast: 3]
    import Ecto.Query

    schema "photos" do
      many_to_many :tags, Tag,
        join_through: "photos_to_tags",
        on_delete: :delete_all,
        on_replace: :delete
    end

    def changeset(model, params \\ %{}) do
      model
      |> cast(params, ~w())
      |> PhoenixMTM.Changeset.cast_collection(:tags, TestRepo, Tag)
    end

    def custom_function_changeset(data, params \\ %{}) do
      data
      |> cast(params, ~w())
      |> PhoenixMTM.Changeset.cast_collection(:tags, fn ids ->
        # Convert Strings back to Integers for demonstration
        ids = Enum.map(ids, &String.to_integer/1)

        TestRepo.all(from t in Tag, where: t.id in ^ids)
      end)
    end
  end

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)

    tag_1 = TestRepo.insert!(%Tag{})
    tag_2 = TestRepo.insert!(%Tag{})

    {:ok, [tag_1: tag_1, tag_2: tag_2]}
  end

  test "association for new model", %{tag_1: tag_1} do
    changeset = Photo.changeset(%Photo{}, %{tags: [tag_1.id]})

    photo = TestRepo.insert!(changeset)
    photo = TestRepo.get(Photo, photo.id) |> TestRepo.preload(:tags)

    assert photo.tags == [tag_1]
  end

  test "association for existing model", %{tag_1: tag_1, tag_2: tag_2} do
    changeset = Photo.changeset(%Photo{}, %{tags: [tag_1.id]})
    photo = TestRepo.insert!(changeset)

    changeset = Photo.changeset(photo, %{tags: [tag_2.id]})
    TestRepo.update!(changeset)
    photo = TestRepo.get(Photo, photo.id) |> TestRepo.preload(:tags)

    assert photo.tags == [tag_2]
  end

  test "custom function to lookup collection", %{tag_1: tag_1} do
    tag_id = to_string(tag_1.id) # Preset ids as strings for demonstration
    changeset = Photo.custom_function_changeset(%Photo{}, %{tags: [tag_id]})

    photo = TestRepo.insert!(changeset)
    photo = TestRepo.get(Photo, photo.id) |> TestRepo.preload(:tags)

    assert photo.tags == [tag_1]
  end
end
