defmodule LinkedList do
  @moduledoc """
  ## LinkedList

  An O(n) linked list library.

  Linked lists are really just structs, and have this signature:

  ```elixir
  %LinkedList{
    value: any,
    next: %LinkedList{} | :empty
  }
  ```

  A node is either a linked list or an `:empty` atom.
  """

  @enforce_keys [:value, :next]
  @type t :: %LinkedList{value: any, next: t} | :empty
  defstruct [:value, :next]

  # Empty Testing

  @doc """
  Tests if a node is empty or not

  ## Examples
  
    iex> LinkedList.empty?(%LinkedList{value: 1, next: :empty})
    false

    iex> LinkedList.empty?(:empty)
    true
  """
  @spec empty?(t) :: boolean
  def empty?(node), do: node == :empty

  # Creating Nodes

  @doc """
  Creates a linked list node

  ## Examples

    iex> LinkedList.create
    :empty

    iex> LinkedList.create(1, :empty)
    %LinkedList{value: 1, next: :empty}
  """
  @spec create :: :empty
  def create, do: :empty

  @spec create(any, t | :empty) :: t
  def create(value, next \\ :empty) do
    %LinkedList{
      value: value,
      next: next
    }
  end

  @spec from_list([any]) :: t
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
  def to_list(:empty), do: []

  @spec to_list(t) :: [any]
  def to_list(%LinkedList{value: value, next: next}) do
    [value, to_list(next)] |> List.flatten
  end

  # Get length of nodes

  @spec length(:empty) :: 0
  def length(:empty), do: 0

  @spec length(t) :: non_neg_integer
  def length(%LinkedList{next: next}) do
    1 + LinkedList.length(next)
  end

  # Map nodes

  @spec map(:empty, ((any) -> any)) :: :empty
  def map(:empty, _fun), do: :empty

  @spec map(t, ((any) -> any)) :: t
  def map(%LinkedList{value: value, next: next}, fun) do
    create(fun.(value), map(next, fun))
  end

  # Filter nodes

  @spec filter(:empty, ((any) -> boolean)) :: :empty
  def filter(:empty, _fun), do: :empty

  @spec filter(t, ((any) -> boolean)) :: t
  def filter(%LinkedList{value: value, next: next}, fun) do
    if (fun.(value) == true) do
      create(value, filter(next, fun))
    else
      filter(next, fun)
    end
  end

  # Reduce nodes

  @spec reduce(:empty, any, any) :: any
  def reduce(:empty, initial_value, _fun) do
    initial_value
  end

  @spec reduce(t, any, ((any, any) -> any)) :: any
  def reduce(%LinkedList{value: value, next: next}, initial_value, fun) do
    reduce(next, fun.(initial_value, value), fun)
  end

  # Convert node values to strings

  def join(node, delim \\ "")

  @spec join(:empty, binary) :: <<>>
  def join(:empty, _delim) do
    ""
  end

  @spec join(t, binary) :: binary
  def join(%LinkedList{value: value, next: next}, delim) do
    if next == :empty do
      "#{value}"
    else
      "#{value}#{delim}#{join(next, delim)}"
    end
  end

  @spec to_string(t) :: binary
  def to_string(node), do: "[" <> join(node, ", ") <> "]"

  # Concating nodes

  @spec concat(:empty, :empty) :: :empty
  def concat(:empty, :empty), do: :empty

  @spec concat(t, :empty) :: t
  def concat(node_a = %LinkedList{}, :empty), do: node_a

  @spec concat(:empty, t) :: t
  def concat(:empty, node_b = %LinkedList{}), do: node_b

  @spec concat(t, t) :: t
  def concat(node_a = %LinkedList{}, node_b = %LinkedList{}) do
    create(node_a.value, concat(node_a.next, node_b))
  end

  # Sorting nodes
  # I really feel like there should be a sorting function in here

  @spec sort(:empty) :: :empty
  def sort(:empty), do: :empty

  @spec sort(t) :: t
  def sort(%LinkedList{value: value, next: next}) do
    left = filter(next, fn n -> n < value end)
    right = filter(next, fn n -> n > value end)
    concat(sort(left), concat(create(value, :empty), sort(right)))
  end

  # Reversing nodes

  @spec reverse(:empty) :: :empty
  def reverse(:empty), do: :empty

  @spec reverse(t) :: t
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

  @spec every(t, ((any, any) -> boolean)) :: boolean
  def every(node = %LinkedList{}, fun) do
    reduce(
      node,
      true,
      fn acc, curr ->
        if acc == false, do: false, else: fun.(curr)
      end
    )
  end

  @spec some(:empty, any) :: false
  def some(:empty, _fun), do: false

  @spec some(t, ((any, any) -> boolean)) :: boolean
  def some(node = %LinkedList{}, fun) do
    reduce(
      node,
      false,
      fn acc, curr ->
        if acc == true, do: true, else: fun.(curr)
      end
    )
  end

  # Compare nodes

  @spec eq(:empty, :empty) :: true
  def eq(:empty, :empty), do: true

  @spec eq(:empty, t) :: false
  def eq(:empty, _node), do: false

  @spec eq(t, :empty) :: false
  def eq(_node, :empty), do: false

  @spec eq(t, t) :: boolean
  def eq(node_a = %LinkedList{}, node_b = %LinkedList{}) do
    node_a == node_b
  end
end
