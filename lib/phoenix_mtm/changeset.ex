defmodule Phoenix.MTM.Changeset do
  import Ecto.Changeset, only: [put_assoc: 3]

  def cast_collection(set, assoc, repo, mod) do
    case Map.fetch(set.params, to_string(assoc)) do
      {:ok, ids} ->
        changes =
          ids
          |> Enum.filter(&not_nil/1)
          |> Enum.map(fn id ->
            mod.changeset(repo.get!(mod, id), %{})
          end)

        put_assoc(set, assoc, changes)
      :error ->
        put_assoc(set, assoc, [])
    end
  end

  defp not_nil(value), do: !is_nil(value)
end
