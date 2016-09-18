defmodule PhoenixMTM.Helpers do
  @moduledoc """
  Provides HTML helpers for Phoenix.
  """

  import Phoenix.HTML
  import Phoenix.HTML.Form

  @doc ~S"""
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
    * `:wrapper` - a function to wrap the HTML structure of each checkbox/label
    * `:mapper` - a function to customize the HTML structure of each checkbox/label


  ## Wrapper

  A `wrapper` function can be used to wrap each checkbox and label pair in one
  or more HTML elements.

  The wrapper function receives the pair as a single argument, and should return
  a `safe` tuple as expected by Phoenix.

  A simplified version of this is to call `Phoenix.HTML.Tag.content_tag`

      <%= PhoenixMTM.Helpers.collection_checkboxes f, :tags,
            Enum.map(@tags, &({&1.name, &1.id})),
            selected: Enum.map(f.data.tags, &(&1.id)),
            wrapper: &Phoenix.HTML.Tag.content_tag(:p, &1)


  ## Mapper

  A `mapper` function can be used to customize the structure of the checkbox and
  label pair.

  The mapper function receives the form, field name, input options, label text,
  label options, and helper options, and should return a `safe` tuple as expected
  by Phoenix.

      # Somewhere in your application
      defmodule CustomMappers do
        use PhoenixMTM.Mappers

        def bootstrap(form, field, input_opts, label_text, label_opts, _opts) do
          content_tag(:div, class: "checkbox") do
            label(form, field, label_opts) do
              [
                tag(:input, input_opts),
                {:safe, "#{label_text}"}
              ]
            end
          end
        end
      end

      # In your template
      <%= PhoenixMTM.Helpers.collection_checkboxes f, :tags,
            Enum.map(@tags, &({&1.name, &1.id})),
            selected: Enum.map(f.data.tags, &(&1.id)),
            mapper: &CustomMappers.bootstrap/6
  """
  def collection_checkboxes(form, field, collection, opts \\ []) do
    name = field_name(form, field) <> "[]"
    selected = Keyword.get(opts, :selected, [])
    input_opts = Keyword.get(opts, :input_opts, [])
    label_opts = Keyword.get(opts, :label_opts, [])
    mapper = Keyword.get(opts, :mapper, &PhoenixMTM.Mappers.unwrapped/6)
    wrapper = Keyword.get(opts, :wrapper, &(&1))

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
      |> wrapper.()
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
