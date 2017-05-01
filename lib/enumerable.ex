defimpl Enumerable, for: LinkedList do
  def count(node) do
    {:ok, LinkedList.length(node)}
  end

  def member?(node, value) do
    {:ok, LinkedList.some(node, fn x -> x == value end)}
  end

  def reduce(_, {:halt, acc}, _fun), do: {:halted, acc}
  def reduce(node, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(node, &1, fun)}
  def reduce(%LinkedList{value: nil, next: nil}, {:cont, acc}, _fun), do: {:done, acc}
  def reduce(node, initial_value, fun), do: LinkedList.reduce(node, initial_value, fun)
end
