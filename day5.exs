defmodule Day5 do
  def solve1(list) do
    list |> Enum.map(&seat_id/1)
         |> Enum.max
  end

  def solve2(list) do
   Enum.to_list(0..128*8+7) --  Enum.map(list, &seat_id/1)
  end

  def seat_id(<<head :: binary-size(7)>> <> last) do
    row = binary_partition(Enum.to_list(0..127), head)
    column = binary_partition(Enum.to_list(0..7), last)
    row * 8 + column
  end

  def binary_partition([el], _) do
    el
  end

  def binary_partition(list, "F" <> str) do
    binary_partition(lower_half(list), str)
  end

  def binary_partition(list, "R" <> str) do
    binary_partition(upper_half(list), str)
  end

  def binary_partition(list, "B" <> str) do
    binary_partition(upper_half(list), str)
  end

  def binary_partition(list, "L" <> str) do
    binary_partition(lower_half(list), str)
  end

  def lower_half(list) do
    l = length(list)
    Enum.slice(list, 0..div(l,2)-1)
  end
  def upper_half(list) do
    l = length(list)
    Enum.slice(list, div(l,2)..l-1)
  end
end

list = IO.read(:stdio, :all)
    |> String.split("\n", trim: true)
    |> Day5.solve2
    |> IO.inspect
