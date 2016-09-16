defmodule PhoenixMTM.Wrappers do
  import Phoenix.HTML.Form
  import Phoenix.HTML.Tag

  def unwrapped(form, field, input_opts, label_text, label_opts, _opts) do
    [
      tag(:input, input_opts),
      label(form, field, "#{label_text}", label_opts)
    ]
  end

  def nested(form, field, input_opts, label_text, label_opts, _opts) do
    [
      label(form, field, label_opts) do
        [
          {:safe, "#{label_text}"},
          tag(:input, input_opts)
        ]
      end
    ]
  end

  defmacro __using__(_) do
    quote do
      import Phoenix.HTML.Form
      import Phoenix.HTML.Tag
    end
  end
end
