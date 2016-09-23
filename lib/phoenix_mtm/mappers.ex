defmodule PhoenixMTM.Mappers do
  @moduledoc ~S"""
  A collection of commonly used mappers for the `collection_checkboxes` helper.

  To use, pass a capture of the mapping function you wish to use to the
  `collection_checkboxes` helper.

  ## Example
      <%= PhoenixMTM.Helpers.collection_checkboxes f, :tags,
            Enum.map(@tags, &({&1.name, &1.id})),
            selected: Enum.map(f.data.tags, &(&1.id)),
            mapper: &PhoenixMTM.Mappers.nested/6

  ## Using Custom Mappers

  If you want to make your own custom mapper, you can optionally
  `use PhoenixMTM.Mappers` and bring in some of the Phoenix tag helpers.

  This is not required, as you can manually include which ever imports you want.
  """

  import Phoenix.HTML.Form
  import Phoenix.HTML.Tag
  import Phoenix.HTML, only: [html_escape: 1]

  @doc ~S"""
  Checkbox input and label returned as a 2 element list - the default.

  ### Example Output

  ```html
  <input type="checkbox" value="1" name="checkbox_1">
  <label for="checkbox_1">1</label>
  ```
  """
  def unwrapped(form, field, input_opts, label_content, label_opts, _opts) do
    [
      tag(:input, input_opts),
      label(form, field, "#{label_content}", label_opts)
    ]
  end

  @doc ~S"""
  Checkbox input and label returned as a label with the checkbox and label text
  nested within.

  ### Example Output

  ```html
  <label for="checkbox_1">
    <input type="checkbox" value="1" name="checkbox_1">
    1
  </label>
  ```
  """
  def nested(form, field, input_opts, label_content, label_opts, _opts) do
    label(form, field, label_opts) do
      [
        tag(:input, input_opts),
        html_escape(label_content)
      ]
    end
  end

  @doc ~S"""
  Checkbox input and label returned as a label with the checkbox and label text
  nested within. The label text is not escaped in any way.

  If you are displaying labels that might be provided by untrusted users, you
  absolutely *do not* want to use this mapper.

  This mapper will be deprecated at a later date. If you wish to keep this
  functionality, copy it to your own custom mapper module.

  ### Example Output

  ```html
  <label for="checkbox_1">
    <input type="checkbox" value="1" name="checkbox_1">
    1
  </label>
  ```
  """
  def unsafe_nested(form, field, input_opts, label_content, label_opts, _opts) do
    label(form, field, label_opts) do
      [
        tag(:input, input_opts),
        {:safe, "#{label_content}"}
      ]
    end
  end

  defmacro __using__(_) do
    quote do
      import Phoenix.HTML.Form
      import Phoenix.HTML.Tag
    end
  end
end
