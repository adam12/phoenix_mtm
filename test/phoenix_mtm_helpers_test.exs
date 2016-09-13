defmodule PhoenixMTM.HelpersTest do
  use ExUnit.Case
  import Phoenix.HTML, only: [safe_to_string: 1]
  import Phoenix.HTML.Form, only: [form_for: 4]
  import PhoenixMTM.Helpers, only: [collection_checkboxes: 4, collection_checkboxes: 3]

  doctest PhoenixMTM.Helpers

  defp conn do
    Plug.Test.conn(:get, "/foo", %{})
  end

  describe "when passed the :nested option" do
    test "generates list of labels with a checkbox nested in each" do
      form = safe_to_string(form_for conn(), "/", [as: :form], fn f ->
        collection_checkboxes(f, :collection, ["1": 1, "2": 2], nested: true, other_option: true)
      end)

      assert form =~
        ~s(
          <label for=\"form_collection_1\">
            1
            <input id=\"form_collection_1\" name=\"form[collection][]\" type=\"checkbox\" value=\"1\">
          </label>
          <label for=\"form_collection_2\">
            2
            <input id=\"form_collection_2\" name=\"form[collection][]\" type=\"checkbox\" value=\"2\">
          </label>
        ) |> remove_outside_whitespace
    end
  end

  test "generates list of checkboxes and inputs" do
    form = safe_to_string(form_for conn(), "/", [as: :form], fn f ->
      collection_checkboxes(f, :collection, ["1": 1, "2": 2])
    end)

    assert form =~
      ~s(<input id=\"form_collection_1\" name=\"form[collection][]\" type=\"checkbox\" value=\"1\"><label for=\"form_collection_1\">1</label><input id=\"form_collection_2\" name=\"form[collection][]\" type=\"checkbox\" value=\"2\"><label for=\"form_collection_2\">2</label>)
  end

  test "generates list of checkboxes and inputs with a class" do
    form = safe_to_string(form_for conn(), "/", [as: :form], fn f ->
      collection_checkboxes(f, :collection, ["1": 1, "2": 2], input_opts: [class: "form-field"])
    end)

    assert form =~
      ~s(<input class=\"form-field\" id=\"form_collection_1\" name=\"form[collection][]\" type=\"checkbox\" value=\"1\"><label for=\"form_collection_1\">1</label><input class=\"form-field\" id=\"form_collection_2\" name=\"form[collection][]\" type=\"checkbox\" value=\"2\"><label for=\"form_collection_2\">2</label>)
  end

  test "generates list of checkboxes and inputs with one selected element" do
    form = safe_to_string(form_for conn(), "/", [as: :form], fn f ->
      collection_checkboxes(f, :collection, ["1": 1, "2": 2], selected: [1])
    end)

    assert form =~
      ~s(<input checked=\"checked\" id=\"form_collection_1\" name=\"form[collection][]\" type=\"checkbox\" value=\"1\"><label for=\"form_collection_1\">1</label><input id=\"form_collection_2\" name=\"form[collection][]\" type=\"checkbox\" value=\"2\"><label for=\"form_collection_2\">2</label>)
  end

  test "generates hidden input" do
    form = safe_to_string(form_for conn(), "/", [as: :form], fn f ->
      collection_checkboxes(f, :collection, ["1": 1, "2": 2])
    end)

    assert form =~
      ~s(<input id=\"form_collection\" name=\"form[collection][]\" type=\"hidden\" value=\"\">)
  end

  def remove_outside_whitespace(string) do
    whitespace_not_inside_html_tag = ~r/\s(?=[^>]*(<|$))/
    String.replace(string, whitespace_not_inside_html_tag, "")
  end
end
