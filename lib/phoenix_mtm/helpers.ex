defmodule PhoenixMTM.Helpers do
  @moduledoc """
  Provides HTML helpers for Phoenix.
  """

  import Phoenix.HTML
  import Phoenix.HTML.Tag
  import Phoenix.HTML.Form

  @doc """
  Generates a list of checkboxes and labels to update a Phoenix
  many_to_many relationship.

  ## Basic Example

      <%= PhoenixMTM.Helpers.collection_checkboxes f, :tags,
            Enum.map(@tags, &({&1.name, &1.id})),
            selected: Enum.map(f.data.tags, &(&1.id)) %>

  ## Custom `<input>` and `<label>` options

      <%= PhoenixMTM.Helpers.collection_checkboxes f, :tags,
            Enum.map(@tags, &({&1.name, &1.id})),
            selected: Enum.map(f.data.tags, &(&1.id)),
            label_opts: [class: "form-input"], input_opts: [class: "form-control"] %>

  ## Options

    * `:nested` - when passed `true`, the label will be wrapped around the checkbox
    * `:selected` - a list of options that should be pre-selected
    * `:input_opts` - a list of attributes to be applied to each checkbox input
    * `:label_opts` - a list of attributes to be applied to each checkbox label
  """
  def collection_checkboxes(form, field, collection, opts \\ []) do
    name = field_name(form, field) <> "[]"
    selected = Keyword.get(opts, :selected, [])
    input_opts = Keyword.get(opts, :input_opts, [])
    label_opts = Keyword.get(opts, :label_opts, [])
    mapper = Keyword.get(opts, :mapper, &PhoenixMTM.Mappers.unwrapped/6)

    # TODO: Eventually deprecate this option in favour of passing in custom mapper
    mapper = if {:nested, true} in opts do
      &PhoenixMTM.Mappers.nested/6
    else
      mapper
    end

    inputs = Enum.map(collection, fn {label_text, value} ->
      id = field_id(form, field) <> "_#{value}"

      input_opts =
        input_opts
        |> Keyword.put(:type, "checkbox")
        |> Keyword.put(:id, id)
        |> Keyword.put(:name, name)
        |> Keyword.put(:value, "#{value}")
        |> put_selected(selected, value)

      label_opts = label_opts ++ [for: id]

      mapper.(form, field, input_opts, label_text, label_opts, opts)
    end)

    html_escape(
      inputs ++
      hidden_input(form, field, [name: name, value: ""])
    )
  end

  defp put_selected(opts, selected, value) do
    if Enum.member?(selected, value) do
      Keyword.put(opts, :checked, true)
    else
      opts
    end
  end
end
