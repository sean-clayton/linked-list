defimpl Enumerable, for: LinkedList do
  def count(node) do
    {:ok, LinkedList.length(node)}
  end

  def member?(node, value) do
    {:ok, LinkedList.some(node, fn x -> x == value end)}
  end

  def reduce(node, initial_value, fun) do
    reduce_list(LinkedList.to_list(node), initial_value, fun)
  end

  defp reduce_list(_,       {:halt, acc}, _fun),   do: {:halted, acc}
  defp reduce_list(list,    {:suspend, acc}, fun), do: {:suspended, acc, &reduce_list(list, &1, fun)}
  defp reduce_list([],      {:cont, acc}, _fun),   do: {:done, acc}
  defp reduce_list([h | t], {:cont, acc}, fun),    do: reduce_list(t, fun.(h, acc), fun)
end
