defmodule GildedRose do
  # Example
  # update_quality([%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 1}])
  # => [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 3}]

  @spec update_quality(list(Item.t())) :: list(Item.t())
  @spec update_item(Item.t()) :: Item.t()

  def update_quality(items), do: Enum.map(items, &update_item/1)

  # # "Aged Brie" actually increases in Quality the older it gets
  def update_item(%Item{name: "Aged Brie", quality: quality} = item) do
    increment = degradation(item)
    set_quality(item, min(quality + increment, 50))
  end

  # "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
  # "Sulfuras" is a legendary item and as such its Quality is 80 and it never alters.
  def update_item(%{name: "Sulfuras" <> _} = item), do: %{item | quality: 80}

  # "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
  # Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
  # Quality drops to 0 after the concert
  def update_item(%Item{name: "Backstage passes" <> _, quality: quality, sell_in: sell_in} = item) do
    quality =
      cond do
        sell_in <= 0 -> 0
        sell_in <= 5 -> min(quality + 3, 50)
        sell_in <= 10 -> min(quality + 2, 50)
        quality < 50 -> quality + 1
        true -> quality
      end

    set_quality(item, quality)
  end

  # "Conjured" items degrade in Quality twice as fast as normal items
  def update_item(%Item{name: "Conjured" <> _, quality: quality} = item) do
    degradation = degradation(item) * 2
    set_quality(item, min(max(quality - degradation, 0), 50))
  end

  # Default behavior for all other items
  def update_item(%Item{quality: quality} = item) do
    degradation = degradation(item)
    set_quality(item, max(quality - degradation, 0))
  end

  defp degradation(%{sell_in: sell_in}) when sell_in <= 0, do: 2
  defp degradation(_), do: 1

  defp set_quality(%{sell_in: sell_in} = item, quality),
    do: %{item | sell_in: sell_in - 1, quality: quality}
end
