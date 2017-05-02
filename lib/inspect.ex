defimpl Inspect, for: LinkedList do
  def inspect(node, _opts), do: LinkedList.to_string(node)
end
