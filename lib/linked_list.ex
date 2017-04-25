defmodule LinkedList do
  @moduledoc """
  ## LinkedList

  An O(n) linked list library.
  """
  require Logger

  defstruct value: :none, next: :none

  # Empty Testing

  def empty?(node) do
    node == :empty
  end

  # Creating Nodes

  def create() do
    :empty
  end

  def create(value) do
    %LinkedList{
      value: value,
      next: :empty
    }
  end

  def create(nil, _) do
    :empty
  end

  def create(value, next) do
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

  def to_list(:empty) do
    []
  end

  def to_list(%LinkedList{value: value, next: next}) do
    [
      value,
      next |> to_list
    ] |> List.flatten
  end

  def length(:empty) do
    0
  end

  def length(%LinkedList{ next: next }) do
    1 + LinkedList.length(next)
  end
end