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

  def map(:empty, _) do
    :empty
  end

  def map(%LinkedList{value: value, next: next}, fun) do
    create(
      fun.(value),
      map(next, fun)
    )
  end

  def filter(:empty, _) do
    :empty
  end

  def filter(%LinkedList{ value: value, next: next }, fun) do
    cond do
      fun.(value) == true ->
        create(value, filter(next, fun))
      true ->
        filter(next, fun)
    end
  end

  def reduce(:empty, initial_value, _) do
    initial_value
  end

  def reduce(%LinkedList{ value: value, next: next }, initial_value, fun) do
    reduce(next, fun.(initial_value, value), fun)
  end

  def join(:empty, _) do
    ""
  end

  def join(%LinkedList{ value: value, next: next }, delim) do
    cond do
      next == :empty ->
        "#{value}"
      true ->
        "#{value}#{delim}#{join(next, delim)}"
    end
  end
end