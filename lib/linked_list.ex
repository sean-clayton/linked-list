defmodule LinkedList do
  @moduledoc """
  ## LinkedList

  An O(n) linked list library.
  """
  require Logger

  @enforce_keys [:value, :next]
  defstruct [:value, :next]

  # Empty Testing

  @spec empty?(%LinkedList{}) :: boolean
  def empty?(node) do
    node == :empty
  end

  # Creating Nodes

  @spec create :: :empty
  def create do
    :empty
  end

  @spec create(any, %LinkedList{} | :empty) :: %LinkedList{}
  def create(value, next \\ :empty) do
    %LinkedList{
      value: value,
      next: next
    }
  end

  @spec from_list(list) :: %LinkedList{}
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

  @spec to_list(:empty) :: []
  def to_list(:empty) do
    []
  end

  @spec to_list(%LinkedList{}) :: [any]
  def to_list(%LinkedList{value: value, next: next}) do
    [
      value,
      next |> to_list
    ] |> List.flatten
  end

  # Get length of nodes

  @spec length(:empty) :: 0
  def length(:empty) do
    0
  end

  @spec length(%LinkedList{}) :: non_neg_integer
  def length(%LinkedList{next: next}) do
    1 + LinkedList.length(next)
  end

  # Map nodes

  @spec map(:empty, any) :: :empty
  def map(:empty, _) do
    :empty
  end

  @spec map(%LinkedList{}, ((any) -> any)) :: %LinkedList{}
  def map(%LinkedList{value: value, next: next}, fun) do
    create(
      fun.(value),
      map(next, fun)
    )
  end

  # Filter nodes

  @spec filter(:empty, any) :: :empty
  def filter(:empty, _) do
    :empty
  end

  @spec filter(%LinkedList{}, ((any) -> boolean)) :: %LinkedList{}
  def filter(%LinkedList{value: value, next: next}, fun) do
    cond do
      fun.(value) == true ->
        create(value, filter(next, fun))
      true ->
        filter(next, fun)
    end
  end

  # Reduce nodes

  @spec reduce(:empty, any, any) :: any
  def reduce(:empty, initial_value, _) do
    initial_value
  end

  @spec reduce(%LinkedList{}, any, ((any, any) -> any)) :: any
  def reduce(%LinkedList{value: value, next: next}, initial_value, fun) do
    reduce(next, fun.(initial_value, value), fun)
  end

  # Convert node values to strings

  def join(node, delim \\ "")

  @spec join(:empty, any) :: <<>>
  def join(:empty, _) do
    ""
  end

  @spec join(%LinkedList{}, binary) :: binary
  def join(%LinkedList{value: value, next: next}, delim) do
    cond do
      next == :empty ->
        "#{value}"
      true ->
        "#{value}#{delim}#{join(next, delim)}"
    end
  end

  @spec to_string(%LinkedList{}) :: binary
  def to_string(node) do
    cond do
      node ->
        "[" <> join(node, ", ") <> "]"
      true ->
        "[" <> join(:empty) <> "]"
    end
  end

  # Concating nodes

  @spec concat(:empty, :empty) :: :empty
  def concat(:empty, :empty), do: :empty

  @spec concat(%LinkedList{}, :empty) :: %LinkedList{}
  def concat(node_a = %LinkedList{}, :empty), do: node_a

  @spec concat(:empty, %LinkedList{}) :: %LinkedList{}
  def concat(:empty, node_b = %LinkedList{}), do: node_b

  @spec concat(%LinkedList{}, %LinkedList{}) :: %LinkedList{}
  def concat(node_a = %LinkedList{}, node_b = %LinkedList{}) do
    create(node_a.value, concat(node_a.next, node_b))
  end

  # Sorting nodes
  # I really feel like there should be a sorting function in here

  @spec sort(:empty) :: :empty
  def sort(:empty), do: :empty

  @spec sort(%LinkedList{}) :: %LinkedList{}
  def sort(%LinkedList{value: value, next: next}) do
    left = filter(next, fn n -> n < value end)
    right = filter(next, fn n -> n > value end)
    concat(sort(left), concat(create(value, :empty), sort(right)))
  end

  # Reversing nodes

  @spec reverse(:empty) :: :empty
  def reverse(:empty), do: :empty

  @spec reverse(%LinkedList{}) :: %LinkedList{}
  def reverse(node = %LinkedList{}) do
    reduce(
      node,
      :empty,
      fn acc, curr -> create(curr, acc) end
    )
  end

  # Testing node value truthiness

  @spec every(:empty, any) :: false
  def every(:empty, _fun), do: false

  @spec every(%LinkedList{}, ((any, any) -> boolean)) :: boolean
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

  @spec some(:empty, any) :: false
  def some(:empty, _fun), do: false

  @spec some(%LinkedList{}, ((any, any) -> boolean)) :: boolean
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

  @spec eq(:empty, :empty) :: true
  def eq(:empty, :empty), do: true

  @spec eq(:empty, any) :: false
  def eq(:empty, _), do: false

  @spec eq(any, :empty) :: false
  def eq(_, :empty), do: false

  @spec eq(%LinkedList{}, %LinkedList{}) :: boolean
  def eq(node_a = %LinkedList{}, node_b = %LinkedList{}) do
    node_a == node_b
  end
end
