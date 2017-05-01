defmodule LinkedListSpec do
  use ESpec, async: true
  doctest LinkedList

  context "create" do
    it "creates an empty node" do
      expect LinkedList.create() |> to(eq %LinkedList{value: nil, next: nil})
    end

    it "creates a single node" do
      expect LinkedList.create(1) |> to(eq %LinkedList{
        value: 1,
        next: %LinkedList{
          value: nil,
          next: nil
        }
      })
    end

    it "creates multiple nodes" do
      expect(
        LinkedList.create(1, LinkedList.create(2, LinkedList.create(3)))
      ) |> to(eq %LinkedList{
        value: 1,
        next: %LinkedList{
          value: 2,
          next: %LinkedList{
            value: 3,
            next: %LinkedList{
              value: nil,
              next: nil
            }
          }
        }
      })
    end
  end

  context "empty?" do
    it "can tell if an empty node is empty" do
      expect LinkedList.empty?(%LinkedList{value: nil, next: nil})
      |> to(eq true)
    end

    it "can tell if a non-empty node is" do
      expect LinkedList.empty?(LinkedList.create(1))
      |> to(eq false)
    end
  end

  context "from_list" do
    it "creates an empty linked list from an empty list" do
      expect([] |> LinkedList.from_list)
      |> to(eq LinkedList.create())
    end

    it "creates a single-node linked-list from a single-value list" do
      expect([1] |> LinkedList.from_list)
      |> to(eq LinkedList.create(1))
    end

    it "creates a large linked-list from a large list" do
      expect([1, 2, 3] |> LinkedList.from_list)
      |> to(eq LinkedList.create(1, LinkedList.create(2, LinkedList.create(3))))
    end
  end

  context "to_list" do
    it "creates an empty list from an empty linked list" do
      expect([] |> LinkedList.from_list |> LinkedList.to_list)
      |> to(eq [])
    end

    it "creates a single-value list from a single-node linked list" do
      expect([1] |> LinkedList.from_list |> LinkedList.to_list)
      |> to(eq [1])
    end

    it "creates a large list from a large linked-list" do
      expect([1, 2, 3] |> LinkedList.from_list |> LinkedList.to_list)
      |> to(eq [1, 2, 3])
    end
  end

  context "length" do
    it "returns 0 from an empty linked-list" do
      expect([] |> LinkedList.from_list |> LinkedList.length)
      |> to(eq 0)
    end

    it "returns 1 from a single-node linked-list" do
      expect([1] |> LinkedList.from_list |> LinkedList.length)
      |> to(eq 1)
    end

    it "returns a large number from a large linked-list" do
      expect([1, 2, 3] |> LinkedList.from_list |> LinkedList.length)
      |> to(eq 3)
    end
  end

  context "map" do
    it "returns an empty linked list if given an empty linked list" do
      expect(
        []
        |> LinkedList.from_list
        |> LinkedList.map(fn x -> x * 2 end)
        |> LinkedList.to_list
      ) |> to(eq [])
    end

    it "maps a single-node linked list" do
      expect(
        [1]
        |> LinkedList.from_list
        |> LinkedList.map(fn x -> x * 2 end)
        |> LinkedList.to_list
      ) |> to(eq [2])
    end

    it "maps a large linked list" do
      expect(
        [1, 2, 3]
        |> LinkedList.from_list
        |> LinkedList.map(fn x -> x * 2 end)
        |> LinkedList.to_list
      ) |> to(eq [2, 4, 6])
    end
  end

  context "filter" do
    it "returns an empty linked list if given an empty linked list" do
      expect(
        []
        |> LinkedList.from_list
        |> LinkedList.filter(fn x -> x < 5 end)
        |> LinkedList.to_list
      ) |> to(eq [])
    end

    it "filters a single-node linked list" do
      expect(
        [1]
        |> LinkedList.from_list
        |> LinkedList.filter(fn x -> x < 5 end)
        |> LinkedList.to_list
      ) |> to(eq [1])
    end

    it "filters a large linked list" do
      expect(
        [1, 2, 2, 4, 3, 6, 4, 8]
        |> LinkedList.from_list
        |> LinkedList.filter(fn x -> x < 5 end)
        |> LinkedList.to_list
      ) |> to(eq [1, 2, 2, 4, 3, 4])
    end
  end

  context "reduce" do
    it "returns an empty linked list if given an empty linked list" do
      expect(
        []
        |> LinkedList.from_list
        |> LinkedList.reduce(0, fn curr, acc -> curr + acc end)
      ) |> to(eq 0)
    end

    it "reduces a single-node linked list" do
      expect(
        [1]
        |> LinkedList.from_list
        |> LinkedList.reduce(0, fn curr, acc -> curr + acc end)
      ) |> to(eq 1)
    end

    it "reduces a large linked list" do
      expect(
        [1, 2, 3, 4, 5]
        |> LinkedList.from_list
        |> LinkedList.reduce(0, fn curr, acc -> curr + acc end)
      ) |> to(eq 15)
    end

    it "reduces an empty linked list without an initial value" do
      expect(
        []
        |> LinkedList.from_list
        |> LinkedList.reduce(fn curr, acc -> curr + acc end)
        |> LinkedList.to_list
      ) |> to(eq [])
    end

    it "reduces a single-node linked list without an initial value" do
      expect(
        [1]
        |> LinkedList.from_list
        |> LinkedList.reduce(fn curr, acc -> curr + acc end)
      ) |> to(eq 1)
    end

    it "reduces a large linked list without an initial value" do
      expect(
        [1, 2, 3]
        |> LinkedList.from_list
        |> LinkedList.reduce(fn curr, acc -> curr + acc end)
      ) |> to(eq 6)
    end
  end

  context "join" do
    it "returns an empty linked list if given an empty linked list" do
      expect(
        []
        |> LinkedList.from_list
        |> LinkedList.join(" ")
      ) |> to(eq "")
    end

    it "joins single-node linked list" do
      expect(
        [1]
        |> LinkedList.from_list
        |> LinkedList.join(" ")
      ) |> to(eq "1")
    end

    it "joins a large linked list with no delimeter provided" do
      expect(
        [1, 2, 3]
        |> LinkedList.from_list
        |> LinkedList.join
      ) |> to(eq "123")
    end

    it "joins a large linked list" do
      expect(
        [1, 2, 3]
        |> LinkedList.from_list
        |> LinkedList.join(" ")
      ) |> to(eq "1 2 3")
    end
  end

  context "to_string" do
    it "turns an empty linked list to a string" do
      expect(
        []
        |> LinkedList.from_list
        |> LinkedList.to_string
      ) |> to(eq "[]")
    end

    it "turns a single-node linked list to a string" do
      expect(
        [1]
        |> LinkedList.from_list
        |> LinkedList.to_string
      ) |> to(eq "[1]")
    end

    it "turns a large linked list to a string" do
      expect(
        [1, 2, 3]
        |> LinkedList.from_list
        |> LinkedList.to_string
      ) |> to(eq "[1, 2, 3]")
    end
  end

  context "concat" do
    it "returns an empty linked list if given empty linked lists" do
      expect(
        LinkedList.concat(LinkedList.create(), LinkedList.create())
        |> LinkedList.to_list
      ) |> to(eq [])
    end

    it "concats a linked list with an empty linked list" do
      expect(
        LinkedList.concat(LinkedList.create(1), LinkedList.create())
        |> LinkedList.to_list
      ) |> to(eq [1])
    end

    it "concats an empty linked list with a linked list" do
      expect(
        LinkedList.concat(LinkedList.create(), LinkedList.create(5))
        |> LinkedList.to_list
      ) |> to(eq [5])
    end

    it "concats a linked list with a linked list" do
      expect(
        LinkedList.concat(LinkedList.create(1), LinkedList.create(2))
        |> LinkedList.to_list
      ) |> to(eq [1, 2])
    end
  end

  context "sort" do
    it "returns an empty linked list if given an empty linked list" do
      expect(
        []
        |> LinkedList.from_list
        |> LinkedList.sort
        |> LinkedList.to_list
      ) |> to(eq [])
    end

    it "sorts a single-node linked list" do
      expect(
        [1]
        |> LinkedList.from_list
        |> LinkedList.sort
        |> LinkedList.to_list
      ) |> to(eq [1])
    end

    it "sorts a large linked list" do
      expect(
        [5, 4, 3, 2, 1]
        |> LinkedList.from_list
        |> LinkedList.sort
        |> LinkedList.to_list
      ) |> to(eq [1, 2, 3, 4, 5])
    end
  end

  context "reverse" do
    it "returns an empty linked list if given an empty linked list" do
      expect(
        []
        |> LinkedList.from_list
        |> LinkedList.reverse
        |> LinkedList.to_list
      ) |> to(eq [])
    end

    it "reduces a single-node linked list if given a single-node linked" do
      expect(
        [1]
        |> LinkedList.from_list
        |> LinkedList.reverse
        |> LinkedList.to_list
      ) |> to(eq [1])
    end

    it "reverses a large linked list" do
      expect(
        [1, 2, 3, 4, 5]
        |> LinkedList.from_list
        |> LinkedList.reverse
        |> LinkedList.to_list
      ) |> to(eq [5, 4, 3, 2, 1])
    end
  end

  context "every" do
    it "returns false if given an empty linked list" do
      expect(
        []
        |> LinkedList.from_list
        |> LinkedList.every(fn x -> x < 5 end)
      ) |> to(eq false)
    end

    it "checks a single-node linked list" do
      expect(
        [1]
        |> LinkedList.from_list
        |> LinkedList.every(fn x -> x < 5 end)
      ) |> to(eq true)
    end

    it "checks a large linked list" do
      expect(
        [1, 2, 4, 8, 2]
        |> LinkedList.from_list
        |> LinkedList.every(fn x -> x < 5 end)
      ) |> to(eq false)
    end
  end

  context "some" do
    it "returns false if given an empty linked list" do
      expect(
        []
        |> LinkedList.from_list
        |> LinkedList.some(fn x -> x < 5 end)
      ) |> to(eq false)
    end

    it "checks a single-node linked list" do
      expect(
        [1]
        |> LinkedList.from_list
        |> LinkedList.some(fn x -> x < 5 end)
      ) |> to(eq true)
    end

    it "checks a large linked list" do
      expect(
        [9, 8, 4, 6]
        |> LinkedList.from_list
        |> LinkedList.some(fn x -> x < 5 end)
      ) |> to(eq true)
    end

    it "checks a large linked list" do
      expect(
        [9, 8, 7, 6]
        |> LinkedList.from_list
        |> LinkedList.some(fn x -> x < 5 end)
      ) |> to(eq false)
    end
  end

  context "eq" do
    it "returns true if given empty linked lists" do
      expect(LinkedList.eq(LinkedList.create(), LinkedList.create())) |> to(eq true)
    end

    it "checks if a non-empty linked list is equal to an empty linked list" do
      expect(
        LinkedList.eq(LinkedList.create(1), LinkedList.create())
      ) |> to(eq false)
    end

    it "checks if an empty linked list is equal to a non-empty linked list" do
      expect(
        LinkedList.eq(LinkedList.create(), LinkedList.create(1))
      ) |> to(eq false)
    end

    it "checks if identical linked lists are equal to each other" do
      expect(
        LinkedList.eq(LinkedList.create(1), LinkedList.create(1))
      ) |> to(eq true)
    end

    it "checks if different linked lists are equal to each other" do
      expect(
        LinkedList.eq(LinkedList.create(1), LinkedList.create(2))
      ) |> to(eq false)
    end
  end

  describe "Enumerable count implementation" do
    it "returns a count of an empty linked list" do
      expect(LinkedList.create() |> Enum.count)
      |> to(eq 0)
    end

    it "returns a count of a single-node linked list" do
      expect(LinkedList.create(1) |> Enum.count)
      |> to(eq 1)
    end

    it "returns a count of a large linked list" do
      expect(LinkedList.create(1, LinkedList.create(2, LinkedList.create(3))) |> Enum.count)
      |> to(eq 3)
    end
  end

  describe "Enumerable member? implementation" do
    it "returns false if given an empty linked list" do
      expect(LinkedList.create() |> Enum.member?(1))
      |> to(eq false)
    end

    it "determines if a node exists in a single-node linked list" do
      expect(LinkedList.create(1) |> Enum.member?(1))
      |> to(eq true)

      expect(LinkedList.create(1) |> Enum.member?(0))
      |> to(eq false)
    end

    it "determines if a node exists in a large linked list" do
      expect(LinkedList.create(1, LinkedList.create(2, LinkedList.create(3))) |> Enum.member?(1))
      |> to(eq true)

      expect(LinkedList.create(1, LinkedList.create(2, LinkedList.create(3))) |> Enum.member?(0))
      |> to(eq false)
    end
  end

  describe "Enumerable reduce implementation" do
    it "reduces an empty linked list" do
      expect(
        []
        |> LinkedList.from_list
        |> Enum.reduce(0, fn curr, acc -> curr + acc end)
      ) |> to(eq 0)
    end

    it "reduces a single-node linked list" do
      expect(
        [1]
        |> LinkedList.from_list
        |> Enum.reduce(0, fn curr, acc -> curr + acc end)
      ) |> to(eq 1)
    end

    it "reduces a large linked list" do
      expect(
        [1, 2, 3]
        |> LinkedList.from_list
        |> Enum.reduce(0, fn curr, acc -> curr + acc end)
      ) |> to(eq 6)
    end
  end
end
