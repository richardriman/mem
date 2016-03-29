defmodule Mem.Cleaners.LRUTest do
  use ExUnit.Case, async: true

  test "lru" do
    value = String.duplicate("a", 100)
    1..100 |> Enum.each(&M.LRU.set(&1, value))
    :timer.sleep(2000)

    assert Mem.Utils.storage_name(:data, M.LRU).memory_used <= 3000
  end

end
