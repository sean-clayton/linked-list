defmodule LinkedList do
  @moduledoc """
  ## LinkedList

  An O(n) linked list library.
  """
  require Logger

  defstruct value: :none, next: :none

  def empty_linked_list do
    %LinkedList{
      value: :none,
      next: :none
    }
  end

  def is_empty(%LinkedList{value: :none, next: :none}) do
    true
  end

  def is_empty(%LinkedList{}) do
    false
  end

  def create_linked_list(value, next = %LinkedList{}) do
    %LinkedList{
      value: value,
      next: next
    }
  end

  def create_list_linked_list(value, :none) do
    %LinkedList{
      value: value,
      next: LinkedList.empty_linked_list()
    }
  end
  
  def from_list(list = []) when is_list list do
    []
  end

  def from_list([head | tail] = list) when is_list list do
    LinkedList.create_linked_list(
      head, Enum.reduce(
        tail |> Enum.reverse,
        LinkedList.empty_linked_list(),
        fn curr, acc ->
          LinkedList.create_linked_list(
            curr, acc
          )
        end
      )
    )
  end

  def to_list(%LinkedList{value: :none, next: :none}) do
    []
  end

  def to_list(%LinkedList{}) do
    []
  end

  def map(%LinkedList{value: :none, next: :none}, fun) do
    LinkedList.empty_linked_list()
  end
  
  def map(%LinkedList{}, fun) do
    
  end
end