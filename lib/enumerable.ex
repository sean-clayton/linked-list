defimpl Enumerable, for: LinkedList do
  def count(node) do
    {:ok, LinkedList.length(node)}
  end

  def member?(node, value) do
    {:ok, LinkedList.some(node, fn x -> x == value end)}
  end

  def reduce(node, initial_value, fun) do
    {:ok, LinkedList.reduce(node, initial_value, fun)}
  end
end
