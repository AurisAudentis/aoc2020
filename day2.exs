defmodule DayTwo do
  def solve1(pwlist) do
    pwlist |> Enum.filter(&is_valid_line/1) |> Enum.count
  end

  def is_valid_line(line) do
    [mix, letter, pw] = String.split(line, " ")
    {min, max} = minmax(mix)
    count = pw |> String.graphemes |> Enum.count(&(&1 == String.trim(letter, ":")))
    min <= count  and count <= max
  end

  def minmax(part1) do
    [min, max] = String.split(part1, "-") |> Enum.map(&String.to_integer/1)
    {min, max}
  end

  def solve2(pwlist) do
    pwlist |> Enum.filter(&is_valid_line2/1) |> Enum.count
  end

  def is_valid_line2(line) do
    [mix, letter, pw] = String.split(line, " ")
    {min, max} = minmax(mix)
    boollist = pw |> String.graphemes |> Enum.map(&(&1 == String.trim(letter, ":")))

    (Enum.at(boollist, min-1, false) or Enum.at(boollist, max-1, false)) and !(Enum.at(boollist, min-1, false)  and Enum.at(boollist, max-1, false) )
  end
end

IO.read(:stdio, :all)
|> String.trim
|> String.split("\n")
|> DayTwo.solve2
|> IO.inspect
