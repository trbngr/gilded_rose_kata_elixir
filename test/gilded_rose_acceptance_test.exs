defmodule GildedRoseAcceptanceTest do
  use ExUnit.Case, async: true

  alias __MODULE__.OriginalRunner, as: Original

  setup do
    items = [
      %Item{name: "+5 Dexterity Vest", sell_in: 10, quality: 20},
      %Item{name: "Aged Brie", sell_in: 2, quality: 0},
      %Item{name: "Elixir of the Mongoose", sell_in: 5, quality: 7},
      %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 80},
      %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: -1, quality: 80},
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 15, quality: 20},
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 49},
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 49},
      %Item{name: "Conjured Mana Cake", sell_in: 3, quality: 6}
    ]

    days = 7

    %{
      original: Enum.reduce(0..days, items, fn _, items -> GildedRose.update_quality(items) end),
      new: Enum.reduce(0..days, items, fn _, items -> Original.update_quality(items) end)
    }
  end

  test "new impl matches old impl", %{original: original, new: new} do
    equality_keys = [:sell_in, :quality]

    original
    |> Enum.zip_with(new, fn o, n -> %{original: o, new: n} end)
    |> Enum.each(fn %{original: o, new: n} ->
      assert Map.take(o, equality_keys) == Map.take(n, equality_keys)
    end)
  end

  defmodule OriginalRunner do
    def update_quality(items), do: Enum.map(items, &update_item/1)

    def update_item(item) do
      item =
        cond do
          item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" ->
            if item.quality > 0 do
              if item.name != "Sulfuras, Hand of Ragnaros" do
                %{item | quality: item.quality - 1}
              else
                item
              end
            else
              item
            end

          true ->
            cond do
              item.quality < 50 ->
                item = %{item | quality: item.quality + 1}

                cond do
                  item.name == "Backstage passes to a TAFKAL80ETC concert" ->
                    item =
                      cond do
                        item.sell_in < 11 ->
                          cond do
                            item.quality < 50 ->
                              %{item | quality: item.quality + 1}

                            true ->
                              item
                          end

                        true ->
                          item
                      end

                    cond do
                      item.sell_in < 6 ->
                        cond do
                          item.quality < 50 ->
                            %{item | quality: item.quality + 1}

                          true ->
                            item
                        end

                      true ->
                        item
                    end

                  true ->
                    item
                end

              true ->
                item
            end
        end

      item =
        cond do
          item.name != "Sulfuras, Hand of Ragnaros" ->
            %{item | sell_in: item.sell_in - 1}

          true ->
            item
        end

      cond do
        item.sell_in < 0 ->
          cond do
            item.name != "Aged Brie" ->
              cond do
                item.name != "Backstage passes to a TAFKAL80ETC concert" ->
                  cond do
                    item.quality > 0 ->
                      cond do
                        item.name != "Sulfuras, Hand of Ragnaros" ->
                          %{item | quality: item.quality - 1}

                        true ->
                          item
                      end

                    true ->
                      item
                  end

                true ->
                  %{item | quality: item.quality - item.quality}
              end

            true ->
              cond do
                item.quality < 50 ->
                  %{item | quality: item.quality + 1}

                true ->
                  item
              end
          end

        true ->
          item
      end
    end
  end
end
