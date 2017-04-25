defmodule LinkedList.Test do
  use ExUnit.Case, async: true

  require LinkedList

  test "from_list/1" do
    assert %LinkedList{ value: 1, next: %LinkedList{ value: :none, next: :none } } |> LinkedList.from_list |> LinkedList.to_list == [1]
    assert (
      %LinkedList{
        value: 1,
        next: %LinkedList{
          value: 2,
          next: %LinkedList{
            value: :none,
            next: :none
          }
        }
      } |> LinkedList.to_list
    ) == [1, 2]
  end

  test "to_list/1" do
    assert [] |> LinkedList.from_list |> LinkedList.to_list == []
    assert [1] |> LinkedList.from_list |> LinkedList.to_list == [1]
    assert [1, 2, 3] |> LinkedList.from_list |> LinkedList.to_list == [1, 2, 3]
  end

  test "map/2" do
    assert [] |> LinkedList.from_list |> LinkedList.map(fn x -> x * 2 end) == []
    assert [1] |> LinkedList.from_list |> LinkedList.map(fn x -> x * 2 end) == [2]
    assert [1, 2, 3] |> LinkedList.from_list |> LinkedList.map(fn x -> x * 2 end) == [2, 4, 6]
  end
  
end