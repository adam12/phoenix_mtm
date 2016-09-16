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
            Enum.map(@tags, fn tag -> {tag.name, tag.id} end),
            selected: Enum.map(f.data.tags, &(&1.id)) %>

  ## Custom `<input>` and `<label>` options

      <%= PhoenixMTM.Helpers.collection_checkboxes f, :tags,
            Enum.map(@tags, fn tag -> {tag.name, tag.id} end),
            selected: Enum.map(f.data.tags, &(&1.id)),
            label_opts: [class: "form-input"], input_opts: [class: "form-control"] %>

  ## Wrapping the elements

  Sometimes it is useful to wrap each `<input>` and `<label>` pair in some
  custom HTML, for example for styling reasons.
  For example if you wanted to wrap each element in a `<div>` with the class `checkbox`,
  you could do the following:

      <%= PhoenixMTM.Helpers.collection_checkboxes f, :tags,
            Enum.map(@tags, fn tag -> {tag.name, tag.id} end), selected:
            Enum.map(f.data.tags, &(&1.id)),
            mapper: &(content_tag(:div, &1, class: "checkbox")) %>

  ## Options

    * `:nested` - when passed `true`, the label will be wrapped around the checkbox
  """
  def collection_checkboxes(form, field, collection, opts \\ []) do
    name = field_name(form, field) <> "[]"
    selected = Keyword.get(opts, :selected, [])
    input_opts = Keyword.get(opts, :input_opts, [])
    label_opts = Keyword.get(opts, :label_opts, [])
    mapper = Keyword.get(opts, :mapper, &(&1))

    inputs = Enum.map(collection, fn {label, value} ->
      id = field_id(form, field) <> "_#{value}"

      input_opts =
        input_opts
        |> Keyword.put(:type, "checkbox")
        |> Keyword.put(:id, id)
        |> Keyword.put(:name, name)
        |> Keyword.put(:value, "#{value}")
        |> put_selected(selected, value)

      input_tag = tag(:input, input_opts)
      label_opts = label_opts ++ [for: id]
      element = build_label_with_input(form, field, input_tag, label, label_opts, opts)
      mapper.(element)
    end)

    html_escape(
      inputs ++
      hidden_input(form, field, [name: name, value: ""])
    )
  end

  defp build_label_with_input(form, field, input_tag, label, label_opts, opts) do
    if {:nested, true} in opts do
      [
        label form, field, label_opts do
          [{:safe, "#{label}"}, input_tag]
        end
      ]
    else
      [
        input_tag,
        label(form, field, "#{label}", label_opts)
      ]
    end
  end

  defp put_selected(opts, selected, value) do
    if Enum.member?(selected, value) do
      Keyword.put(opts, :checked, true)
    else
      opts
    end
  end
end
