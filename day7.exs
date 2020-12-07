defmodule Day7 do

  def solve1(list) do
    map = list |> Enum.map(&String.split(&1, " contain "))
         |> Enum.map(fn ([part1, part2]) -> {parse_bag(part1), parse_baglist(part2)} end)
         |> Map.new
         |> Map.delete("no other")

    iterate_1(map, MapSet.new(["shiny gold"])) |> Enum.count
  end

  def iterate_1(map, colorset) do
    length = MapSet.size(colorset)
    new_colorset = colorset |> Enum.flat_map(&find_all_parents(map, &1))
                            |> MapSet.new
                            |> MapSet.union(colorset)

    if MapSet.size(new_colorset) == length, do: colorset, else: iterate_1(map, new_colorset)
  end

  def parse_baglist(list) do
    list |> String.split(", ")
          |> Enum.map(&parse_bag/1)
  end

  def parse_bag(bag) do
    bag |> String.trim
        |> String.replace(~r/ ?bags?\.?/, "")
        |> String.replace(~r/[0-9]/, "")
        |> String.trim
  end

  def find_all_parents(map, color) do
    map |> Enum.filter(fn {_, valuelist} -> color in valuelist end)
        |> Enum.map(fn {key, _} -> key end)
  end
end


list = IO.read(:stdio, :all)
        |> String.split("\n", trim: true)
        |> Day7.solve1
        |> IO.inspect
