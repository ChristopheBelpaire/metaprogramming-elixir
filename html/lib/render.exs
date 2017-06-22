defmodule Template do
  import Html

  def render do
    markup do
      table do
        tr do
          for i <- 0..5 do
            td do: text("Cell #{i}")
          end
        end
      end
      div do
        text "Some nested content"
      end
    end
  end
end
