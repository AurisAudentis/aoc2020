defmodule Day9 do

  def solve1(list) do
    test_and_collect([], list, 25) |> elem(1)
  end

  def solve2(list) do
    amount = solve1(list)
    bruteforce_try(list, amount) |> sum_highest_lowest()
  end

  def test_and_collect(collector, [head | list], amount) do
    cond do
      length(collector) < amount -> test_and_collect([head|collector], list, amount)
      Enum.all?(collector, &(head - &1 not in collector)) -> {:ok, head}
      true -> test_and_collect([head|collector], list, amount)
    end
  end

  def sum_highest_lowest(list) do
    min = Enum.min(list)
    max = Enum.max(list)
    min + max
  end

  def bruteforce_try(list, amount) do
    0..length(list) |> Enum.map(&Enum.drop(list, &1))
                    |> Enum.find_value(&is_correct_list(&1, amount))
  end

  def is_correct_list(list, amount) do
    cumsumlist = Enum.scan(list, &(&1 + &2))
    if amount in cumsumlist, do: Enum.slice(list, 0..Enum.find_index(cumsumlist, &(&1 === amount))), else: false
  end
end

list = IO.read(:stdio, :all)
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Day9.solve2
        |> IO.inspect
