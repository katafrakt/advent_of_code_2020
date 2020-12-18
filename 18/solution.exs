defmodule Calculations do
  def call(str) do
    {:ok, tokens, _} = :lexer.string(String.to_charlist(str))
    {:ok, ast} = :parser.parse(tokens)
    eval(ast, 0)
  end

  def call2(str) do
    {:ok, tokens, _} = :lexer.string(String.to_charlist(str))
    {:ok, ast} = :parser2.parse(tokens)
    eval(ast, 0)
  end

  defp eval({:number, _, n}, _store), do: n
  defp eval({:mult, left, right}, s), do: eval(left, s) * eval(right, s)
  defp eval({:add, left, right}, s), do: eval(left, s) + eval(right, s)
end

File.stream!("input")
|> Enum.reduce(0, fn line, acc -> Calculations.call(line) + acc end)
|> IO.inspect

File.stream!("input")
|> Enum.reduce(0, fn line, acc -> Calculations.call2(line) + acc end)
|> IO.inspect