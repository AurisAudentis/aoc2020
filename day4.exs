defmodule Day4 do

  def solve1(list) do
    list |> Enum.map(&parse_passport/1)
        |> Enum.map(&(Map.drop(&1, ["cid"])))
        |> Enum.map(&Enum.count/1)
        |> Enum.filter(&(&1 == 7))
        |> Enum.count
  end

  def solve2(list) do
    list |> Enum.map(&parse_passport/1)
        |> Enum.map(&(Map.drop(&1, ["cid"])))
        |> Enum.filter(&(Enum.all?(&1, fn ({key, value}) -> valid_field({key, value}) end)))
        |> Enum.filter(&(Enum.count(&1) == 7))
        |> IO.inspect
        |> Enum.count

  end

  def parse_passport([key, value | list]) do
    Map.put(parse_passport(list), key, value)
  end

  def parse_passport([]) do
    %{}
  end

  def valid_field({"byr", num}), do: String.to_integer(num) in 1920..2002
  def valid_field({"iyr", num}), do: String.to_integer(num) in 2010..2020
  def valid_field({"eyr", num}), do: String.to_integer(num) in 2020..2030
  def valid_field({"hgt", num}) do
    case String.slice(num, -2..-1) do
      "in" -> String.to_integer(String.slice(num, 0..-3)) in 59..76
      "cm" -> String.to_integer(String.slice(num, 0..-3)) in 150..193
      _ -> false
    end
  end
  def valid_field({"hcl", "#" <> color}), do: String.graphemes(color) |> Enum.all?(&(&1 in String.graphemes("0123456789") or &1 in String.graphemes("abcdef")))
  def valid_field({"ecl", num}), do: num in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  def valid_field({"pid", num}), do: String.length(num) == 9
  def valid_field(_), do: false
end


list = IO.read(:stdio, :all)
    |> String.split("\n\n")
    |> Enum.map(&(String.split(&1, [":", " ", "\n"], trim: true)))
    |> Day4.solve2
    |> IO.inspect
