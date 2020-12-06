defmodule Day6 do
  def solve1(list) do
    list |> Enum.map(&one/1)
        |> Enum.sum
  end

  def one(list) do
    list |> Enum.flat_map(&String.graphemes/1)
         |> Enum.uniq
         |> Enum.count
  end

  def solve2(list) do
    list |> Enum.map(&two/1)
    |> Enum.sum
  end

  def two(list) do
    all_possibilities = String.graphemes("abcdefghijklmnopqrstuvwxyz")
    mapped_lists = Enum.map(list, &String.graphemes/1)

    all_possibilities |> Enum.map(&(is_one_letter(&1, mapped_lists)))
                      |> Enum.count(&(&1))
  end

  def is_one_letter(letter, list) do
    Enum.all?(list, &(letter in &1))
  end
end


list = IO.read(:stdio, :all)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&(String.split(&1, "\n", trim: true)))
    |> Day6.solve2
    |> IO.inspect
