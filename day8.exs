defmodule Day8 do
  def solve1(list) do
    instructions = list |> Enum.map(&parse_instruction/1)
    start_state = {0, 0, instructions, MapSet.new, false, false}
    run(start_state)
  end

  def solve2(list) do
    instructions = list |> Enum.map(&parse_instruction/1)

    Enum.map(0..length(instructions)-1, &replace_instruction(instructions, &1))
              |> Enum.map(&{0, 0, &1, MapSet.new, false, false})
              |> Enum.map(&run(&1))
              |> Enum.filter(fn {_,_,_,_,_, done} -> done end)

  end

  def replace_instruction(instrs, i) do
    {first_part, [el | second_part]} = Enum.split(instrs, i)

    first_part ++ [replaced(el)] ++ second_part
  end

  def replaced({"jmp", num}) do
    {"nop", num}
  end
  def replaced({"nop", num}) do
    {"jmp", num}
  end

  def replaced(instr) do
    instr
  end

  def parse_instruction(line) do
    [instr, number] = String.split(line, " ")
    {instr, String.to_integer(number)}
  end

  def run(state) do
    nextstate = step(state)
    {_, _, _, _, error, done} = nextstate
    if (done) or (error), do: nextstate, else: run(nextstate)
  end

  def step(state) do
    {acc, index, instructions, history, _, _} = state
    {newacc, newindex} = instr(Enum.at(instructions, index), acc, index)

    loop = index in history
    out_of_bounds = length(instructions) < newindex
    done = length(instructions) == newindex

    {newacc, newindex, instructions, MapSet.put(history, index), loop or out_of_bounds, done}
  end

  def instr({"acc", num}, acc, index) do
    {acc + num, index+1}
  end

  def instr({"nop", _}, acc, index) do
    {acc, index+1}
  end

  def instr({"jmp", num}, acc, index) do
    {acc, index+ num}
  end
end





list = IO.read(:stdio, :all)
|> String.split("\n", trim: true)
|> Day8.solve1
|> IO.inspect
