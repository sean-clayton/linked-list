defmodule LinkedList.Test do
  use ExUnit.Case, async: true

  import LinkedList

  test "create/2" do
    assert create(:none, :none) == %LinkedList{ value: :none, next: :none}
    assert create(1, :none) == %LinkedList{ value: 1, next: empty_linked_list() }
    assert (
      create(
        1,
        create(
          2,
          :none
        )
      )
    ) |> to_list == [1, 2]
  end

  test "from_list/1" do
    assert %LinkedList{ value: 1, next: %LinkedList{ value: :none, next: :none } } |> from_list |> to_list == [1]
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
    assert [] |> from_list |> to_list == []
    assert [1] |> from_list |> to_list == [1]
    assert [1, 2, 3] |> from_list |> to_list == [1, 2, 3]
  end

  test "map/2" do
    assert [] |> from_list |> map(fn x -> x * 2 end) == []
    assert [1] |> from_list |> map(fn x -> x * 2 end) == [2]
    assert [1, 2, 3] |> from_list |> map(fn x -> x * 2 end) == [2, 4, 6]
  end
  
end