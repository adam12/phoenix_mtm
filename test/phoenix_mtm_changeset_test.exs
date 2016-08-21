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
end
