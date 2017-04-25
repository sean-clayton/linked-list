defmodule LinkedList.Test do
  use ExUnit.Case, async: true

  import LinkedList
  require Logger

  test "create/2" do
    assert create() == :empty
    assert create(1) == %LinkedList{ value: 1, next: :empty }
    assert (create(1, create(2))) == %LinkedList{
      value: 1,
      next: %LinkedList{
        value: 2,
        next: :empty
      }
    }
    assert (create(1, create(2, create(3)))) == %LinkedList{
      value: 1,
      next: %LinkedList{
        value: 2,
        next: %LinkedList{
          value: 3,
          next: :empty
        }
      }
    }
  end

  test "empty?/1" do
    assert empty?(:empty) == true
    assert empty?(create(1)) == false
  end

  test "from_list/1" do
    assert [] |> from_list == create()
    assert [1] |> from_list == create(1, :empty)
    assert [1, 2, 3] |> from_list == create(1, create(2, create(3, :empty)))
  end

  test "to_list/1" do
    assert [] |> from_list |> to_list == []
    assert [1] |> from_list |> to_list == [1]
    assert [1, 2, 3] |> from_list |> to_list == [1, 2, 3]
  end

  test "length/1" do
    assert [] |> from_list |> LinkedList.length == 0
    assert [1] |> from_list |> LinkedList.length == 1
    assert [1, 2, 3] |> from_list |> LinkedList.length == 3
  end
  
end