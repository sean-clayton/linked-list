defmodule LinkedList do
  @moduledoc """
  ## LinkedList

  An O(n) linked list library.
  """
  require Logger

  @enforce_keys [:value, :next]
  defstruct [:value, :next]

  # Empty Testing

  def empty?(node) do
    node == :empty
  end

  # Creating Nodes

  def create do
    :empty
  end

  def create(value, next \\ :empty) do
    %LinkedList{
      value: value,
      next: next
    }
  end

  def from_list(list) when is_list list do
    list
    |> Enum.reverse
    |> Enum.reduce(
      :empty,
      fn curr, acc ->
        create(curr, acc)
      end
    )
  end

  # Exporting Nodes

  def to_list(:empty) do
    []
  end

  def to_list(%LinkedList{value: value, next: next}) do
    [
      value,
      next |> to_list
    ] |> List.flatten
  end

  # Get length of nodes

  def length(:empty) do
    0
  end

  def length(%LinkedList{next: next}) do
    1 + LinkedList.length(next)
  end

  # Map nodes

  def map(:empty, _) do
    :empty
  end

  def map(%LinkedList{value: value, next: next}, fun) do
    create(
      fun.(value),
      map(next, fun)
    )
  end

  # Filter nodes

  def filter(:empty, _) do
    :empty
  end

  def filter(%LinkedList{value: value, next: next}, fun) do
    cond do
      fun.(value) == true ->
        create(value, filter(next, fun))
      true ->
        filter(next, fun)
    end
  end

  # Reduce nodes

  def reduce(:empty, initial_value, _) do
    initial_value
  end

  def reduce(%LinkedList{value: value, next: next}, initial_value, fun) do
    reduce(next, fun.(initial_value, value), fun)
  end

  # Convert node values to strings

  def join(node, delim \\ "")

  def join(:empty, _) do
    ""
  end

  def join(%LinkedList{value: value, next: next}, delim) do
    cond do
      next == :empty ->
        "#{value}"
      true ->
        "#{value}#{delim}#{join(next, delim)}"
    end
  end

  def to_string(node) do
    cond do
      node ->
        "[" <> join(node, ", ") <> "]"
      true ->
        "[" <> join(:empty) <> "]"
    end
  end

  # Concating nodes

  def concat(:empty, :empty), do: :empty
  def concat(node_a = %LinkedList{}, :empty), do: node_a
  def concat(:empty, node_b = %LinkedList{}), do: node_b

  def concat(node_a = %LinkedList{}, node_b = %LinkedList{}) do
    create(node_a.value, concat(node_a.next, node_b))
  end

  # Sorting nodes
  # I really feel like there should be a sorting function in here

  def sort(:empty), do: :empty

  def sort(%LinkedList{value: value, next: next}) do
    left = filter(next, fn n -> n < value end)
    right = filter(next, fn n -> n > value end)
    concat(sort(left), concat(create(value, :empty), sort(right)))
  end

  # Reversing nodes

  def reverse(:empty), do: :empty

  def reverse(node = %LinkedList{}) do
    reduce(
      node,
      :empty,
      fn acc, curr -> create(curr, acc) end
    )
  end

  # Testing node value truthiness

  def every(:empty, _fun), do: false

  def every(node = %LinkedList{}, fun) do
    reduce(
      node,
      true,
      fn acc, curr ->
        cond do
          acc == false ->
            false
          true ->
            fun.(curr)
        end
      end
    )
  end

  def some(:empty, _fun), do: false

  def some(node = %LinkedList{}, fun) do
    reduce(
      node,
      true,
      fn acc, curr ->
        cond do
          acc == true ->
            true
          true ->
            fun.(curr)
        end
      end
    )
  end

  # Compare nodes

  def eq(:empty, :empty), do: true
  def eq(:empty, _), do: false
  def eq(_, :empty), do: false
  def eq(node_a = %LinkedList{}, node_b = %LinkedList{}) do
    node_a == node_b
  end
end
