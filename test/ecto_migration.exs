defmodule Ecto.Integration.Migration do
  use Ecto.Migration

  def change do
    create table(:tags) do
    end

    create table(:photos) do
    end

    create table(:photos_to_tags, primary_key: false) do
      add :tag_id, references(:tags, on_delete: :nothing), null: false
      add :photo_id, references(:photos, on_delete: :nothing), null: false
    end
  end
end
