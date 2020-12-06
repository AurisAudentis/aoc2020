

list = IO.read(:stdio, :all)
|> String.trim
|> String.split("\n")
|> Enum.map(&(String.to_integer(&1)))

defmodule DayOne do


  def find_pair(list, a) do
    Enum.map(list, (fn (b) -> Enum.map(list, (fn (c) -> {a, b, c, a+b+c} end)) |> Enum.filter(&(elem(&1, 3) == 2020)) end)) |> Enum.filter(&(&1 !== []))

  end
end

Enum.map(list, fn (a) -> DayOne.find_pair(list, a) end)|> Enum.each(&(IO.inspect(&1)))
