defmodule Template do
  import Html

  def render do
    markup do
      div id: "main" do
        h1 class: "title" do
          text "Welcome!"
        end
      end
      div class: "row" do
        div do
          p do: text "XSS Protection <script>alert('vulnerable?');</script>"
        end
      end
    end
  end
end
