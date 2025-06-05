defmodule GildedRoseTest do
  # This is not testing any sort of stateful code. Let's go async!
  use ExUnit.Case, async: true

  describe "Aged Brie" do
    setup do
      %{item: %Item{name: "Aged Brie", sell_in: 0, quality: 0}}
    end

    test "increases in quality the older it gets", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: 2})
      assert quality == 1
    end

    test "increases in quality by 2 if sell_in is zero", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: 0})
      assert quality == 2
    end

    test "increases in quality by 2 if sell_in is less than zero", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: -1})
      assert quality == 2
    end

    test "will never have a quality greater than 50", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: 3, quality: 55})
      assert quality == 50
    end
  end

  describe "Sulfras" do
    test "being a legendary item, never has to be sold or decreases in quality. It's quality is always 80" do
      item = %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: -1, quality: 2}
      %{quality: quality} = GildedRose.update_item(item)
      assert quality == 80
    end
  end

  describe "Backstage passes" do
    setup do
      %{item: %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 0, quality: 0}}
    end

    test "increases in quality by 3 when there are 5 days or less", %{item: item} do
      Enum.each([5, 4, 3, 2, 1], fn sell_in ->
        %{quality: quality} = GildedRose.update_item(%{item | sell_in: sell_in})
        assert quality == 3
      end)
    end

    test "increases in quality by 2 when there are 10 days or less", %{item: item} do
      Enum.each([10, 9, 8, 7, 6], fn sell_in ->
        %{quality: quality} = GildedRose.update_item(%{item | sell_in: sell_in})
        assert quality == 2
      end)
    end

    test "will never have a quality greater than 50", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: 3, quality: 55})
      assert quality == 50
    end
  end

  describe "Conjured items" do
    setup do
      %{item: %Item{name: "Conjured", sell_in: 0, quality: 10}}
    end

    test "increases in quality by 4 if sell_in is equal to zero", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: 0})
      assert quality == 6
    end

    test "increases in quality by 4 if sell_in is less than zero", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: -1})
      assert quality == 6
    end

    test "quality is never less than zero", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: -1, quality: 1})
      assert quality == 0
    end
  end

  describe "non-specialized items" do
    setup do
      %{item: %Item{name: "Elixir of the Mongoose", sell_in: 5, quality: 4}}
    end

    test "degrades in quality by 2 if sell_in is equal to zero", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: 0})
      assert quality == 2
    end

    test "degrades in quality by 2 if sell_in is less than zero", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: -1})
      assert quality == 2
    end

    test "degrades in quality by 1 if sell_in is greater than zero", %{item: item} do
      %{quality: quality} = GildedRose.update_item(%{item | sell_in: 1})
      assert quality == 3
    end
  end
end
