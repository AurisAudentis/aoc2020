defmodule Day7 do

  def solve1(list) do
    map = list |> Enum.map(&String.split(&1, " contain "))
    # Parse every line of the file
    |> Enum.map(fn ([part1, part2]) -> {parse_bag(part1), parse_baglist(part2)} end)
    # Make every pair {child, parent}
    |> Enum.flat_map(fn {bag, children} -> Enum.map(children, fn {_, child} -> {child, bag} end) end)
    # Accumulate pairs in map
    |> Enum.reduce(Map.new(), fn ({child, parent}, acc) -> Map.update(acc, child, [parent], &[parent | &1]) end)
    |> Map.put("no other", [])

    iterate_1(map, MapSet.new(["shiny gold"])) |> Enum.count |> Kernel.-(1)
  end

  def solve2(list) do
    map = list |> Enum.map(&String.split(&1, " contain "))
    |> Enum.map(fn ([part1, part2]) -> {parse_bag(part1), parse_baglist(part2)} end)
    |> Map.new
    |> Map.put("no other", [])

    iterate_2(map, "shiny gold") - 1
  end

  def iterate_1(map, colorset) do
    length = MapSet.size(colorset)
    new_colorset = colorset |> Enum.flat_map(&Map.get(map, &1, []))
                            |> MapSet.new
                            |> MapSet.union(colorset)

    if MapSet.size(new_colorset) == length, do: colorset, else: iterate_1(map, new_colorset)
  end

  def iterate_2(map, bag) do
    childcount = Map.get(map, bag)
                      |> Enum.map(fn {count, child} -> count * iterate_2(map, child) end)
                      |> Enum.sum

    1 + childcount
  end

  def parse_baglist(list) do
    list |> String.split(", ")
          |> Enum.filter(&!String.contains?(&1, "no other"))
          |> Enum.map(&parse_bag_withcount/1)
  end

  def parse_bag_withcount(<<s :: binary-size(1)>> <> bag) do
    {String.to_integer(s), parse_bag(bag)}
  end

  def parse_bag(bag) do
    bag |> String.trim
        |> String.replace(~r/ ?bags?\.?/, "")
        |> String.replace(~r/[0-9]/, "")
        |> String.trim
  end
end


list = IO.read(:stdio, :all)
        |> String.split("\n", trim: true)
        |> Day7.solve1
        |> IO.inspect
