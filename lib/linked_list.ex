defmodule LinkedList do
  @moduledoc """
  Provides a set of of tools to work with linked lists.

  A linked list can be represented as a regular list:

      iex> [1, 2, 3] |> LinkedList.from_list
      [1, 2, 3]
  
  Or as a struct:

      iex> %LinkedList{value: 1, next: %LinkedList{value: nil, next: nil}}
      [1]
  
  As per definition of a linked list, linked lists created with this library have an empty node
  at the end of each list.
  """

  require Logger

  @enforce_keys [:value, :next]
  @type t :: %LinkedList{value: any, next: nil | %LinkedList{}}
  @type empty :: %LinkedList{value: nil, next: nil}
  defstruct [:value, :next]

  # Empty Testing

  @doc """
  Checks if a linked list node is empty or not.

  ## Examples

      iex> LinkedList.empty?(LinkedList.create())
      true
  """

  @spec empty?(t) :: boolean
  def empty?(node), do: node == %LinkedList{value: nil, next: nil}

  # Creating Nodes

  @doc """
  Creates a linked list node. Useful for chaining.

  ## Examples

      iex> LinkedList.create(1, LinkedList.create(2, LinkedList.create(3)))
      [1, 2, 3]

      iex> LinkedList.create()
      []
  """

  @spec create :: empty
  def create, do: %LinkedList{value: nil, next: nil}

  def create(value, next \\ %LinkedList{value: nil, next: nil})

  @spec create(any, t | empty) :: t
  def create(value, next) do
    %LinkedList{
      value: value,
      next: next
    }
  end

  @doc """
  Converts a regular list to a linked list.

  ## Examples

      iex> list = LinkedList.from_list([2, 4, 6, 8])
      [2, 4, 6, 8]

      iex> LinkedList.empty?(list)
      false
  """

  @spec from_list(list) :: t
  def from_list(list) when is_list list do
    list
    |> Enum.reverse
    |> Enum.reduce(
      %LinkedList{value: nil, next: nil},
      fn curr, acc ->
        create(curr, acc)
      end
    )
  end

  # Exporting Nodes

  @doc """
  Converts a linked list to a regular list.
  """

  @spec to_list(empty) :: []
  def to_list(%LinkedList{value: nil, next: nil}), do: []

  @spec to_list(t) :: [any]
  def to_list(%LinkedList{value: value, next: next}) do
    [value, to_list(next)] |> List.flatten
  end

  # Get length of nodes

  @spec length(empty) :: 0
  def length(%LinkedList{value: nil, next: nil}), do: 0

  @spec length(t) :: non_neg_integer
  def length(%LinkedList{next: next}) do
    1 + LinkedList.length(next)
  end

  # Map nodes

  @spec map(empty, ((any) -> any)) :: empty
  def map(%LinkedList{value: nil, next: nil}, _fun), do: %LinkedList{value: nil, next: nil}

  @spec map(t, ((any) -> any)) :: t
  def map(%LinkedList{value: value, next: next}, fun) do
    create(fun.(value), map(next, fun))
  end

  # Filter nodes

  @spec filter(empty, ((any) -> boolean)) :: empty
  def filter(%LinkedList{value: nil, next: nil}, _fun), do: %LinkedList{value: nil, next: nil}

  @spec filter(t, ((any) -> boolean)) :: t
  def filter(%LinkedList{value: value, next: next}, fun) do
    if (fun.(value) == true) do
      create(value, filter(next, fun))
    else
      filter(next, fun)
    end
  end

  # Reduce nodes

  @spec reduce(empty, ((any, any) -> any)) :: empty
  def reduce(%LinkedList{value: nil, next: nil}, _fun), do: %LinkedList{value: nil, next: nil}

  @spec reduce(t, ((any, any) -> any)) :: any
  def reduce(%LinkedList{value: value, next: %LinkedList{value: nil, next: nil}}, _fun), do: value

  @spec reduce(t, ((any, any) -> any)) :: any
  def reduce(%LinkedList{value: value, next: next}, fun) do
    reduce(next, value, fun)
  end

  @spec reduce(empty, any, any) :: any
  def reduce(%LinkedList{value: nil, next: nil}, initial_value, _fun) do
    initial_value
  end

  @spec reduce(t, any, ((any, any) -> any)) :: any
  def reduce(%LinkedList{value: value, next: next}, initial_value, fun) do
    reduce(next, fun.(initial_value, value), fun)
  end

  # Convert node values to strings

  def join(node, delim \\ "")

  @spec join(empty, binary) :: <<>>
  def join(%LinkedList{value: nil, next: nil}, _delim) do
    ""
  end

  @spec join(t, binary) :: binary
  def join(%LinkedList{value: value, next: next}, delim) do
    if next == %LinkedList{value: nil, next: nil} do
      "#{value}"
    else
      "#{value}#{delim}#{join(next, delim)}"
    end
  end

  @spec to_string(t) :: binary
  def to_string(node), do: "[" <> join(node, ", ") <> "]"

  # Concating nodes

  @spec concat(empty, empty) :: empty
  def concat(%LinkedList{value: nil, next: nil}, %LinkedList{value: nil, next: nil}) do
    %LinkedList{value: nil, next: nil}
  end

  @spec concat(t, empty) :: t
  def concat(node_a = %LinkedList{}, %LinkedList{value: nil, next: nil}), do: node_a

  @spec concat(empty, t) :: t
  def concat(%LinkedList{value: nil, next: nil}, node_b = %LinkedList{}), do: node_b

  @spec concat(t, t) :: t
  def concat(node_a = %LinkedList{}, node_b = %LinkedList{}) do
    create(node_a.value, concat(node_a.next, node_b))
  end

  # Sorting nodes
  # I really feel like there should be a sorting function in here

  @spec sort(empty) :: empty
  def sort(%LinkedList{value: nil, next: nil}), do: %LinkedList{value: nil, next: nil}

  @spec sort(t) :: t
  def sort(%LinkedList{value: value, next: next}) do
    left = filter(next, fn n -> n < value end)
    right = filter(next, fn n -> n > value end)
    concat(
      sort(left),
      concat(create(value, %LinkedList{value: nil, next: nil}), sort(right))
    )
  end

  # Reversing nodes

  @spec reverse(empty) :: empty
  def reverse(%LinkedList{value: nil, next: nil}), do: %LinkedList{value: nil, next: nil}

  @spec reverse(t) :: t
  def reverse(node = %LinkedList{}) do
    reduce(
      node,
      %LinkedList{value: nil, next: nil},
      fn acc, curr -> create(curr, acc) end
    )
  end

  # Testing node value truthiness

  @spec every(empty, any) :: false
  def every(%LinkedList{value: nil, next: nil}, _fun), do: false

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

  @spec some(empty, any) :: false
  def some(%LinkedList{value: nil, next: nil}, _fun), do: false

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

  @spec eq(empty, empty) :: true
  def eq(%LinkedList{value: nil, next: nil}, %LinkedList{value: nil, next: nil}), do: true

  @spec eq(empty, t) :: false
  def eq(%LinkedList{value: nil, next: nil}, _node), do: false

  @spec eq(t, empty) :: false
  def eq(_node, %LinkedList{value: nil, next: nil}), do: false

  @spec eq(t, t) :: boolean
  def eq(node_a = %LinkedList{}, node_b = %LinkedList{}) do
    node_a == node_b
  end
end
