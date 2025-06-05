defmodule Item do
  @type t :: %Item{name: String.t(), sell_in: integer(), quality: integer()}
  defstruct name: nil, sell_in: nil, quality: nil
end
