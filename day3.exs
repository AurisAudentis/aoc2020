defmodule Day3 do

  def solve1(list) do
    slope(list, {3,1})
  end

  def solve2(list) do
    slope(list, {1,1}) * slope(list, {3, 1}) * slope(list, {5,1}) * slope(list, {7,1}) * slope(list, {1,2})
  end

  def slope([head|tail], {xslope, yslope}) do
    map = [head|tail]
    width = length(head)
    height = length(map)
    IO.inspect({width, height})
    [{0,0} | move_until_end({0,0}, xslope, yslope, {height, width})]
      |> Enum.map(fn ({x, y}) -> Enum.at(Enum.at(map, y, []), x, []) end)
      |> Enum.filter(&(&1 == "#"))
      |> Enum.count
  end

  def move_over({x, y}, xslope, yslope, width) do
    {rem(x + xslope, width), y + yslope}
  end

  def move_until_end({_, height}, _, _, {height, _}) do
    []
  end

  def move_until_end(coords, xslope, yslope, {height, width}) do
    mvc = move_over(coords, xslope, yslope, width)
    [mvc | move_until_end(mvc, xslope, yslope, {height, width}) ]
  end
end

list = IO.read(:stdio, :all)
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Day3.solve2
    |> IO.inspect
