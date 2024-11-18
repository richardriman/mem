defmodule Mem.Storages.ETS.TTL do
  @moduledoc """
  TTL Storage

  Backend:     ETS
  Table Type:  set
  Data Format: {key, ttl}
  Index:       key
  """

  defmacro __using__(_) do
    quote do
      @name :"#{__MODULE__}.ETS"

      def create(_) do
        :ets.new(@name, [:set, :public, :named_table, :compressed, write_concurrency: true])
      end

      def memory_used do
        :ets.info(@name, :memory)
      end

      def get(key) do
        case :ets.lookup(@name, key) do
          [{^key, value}] -> {:ok, value}
          []              -> {:err, nil}
        end
      end

      def set(key, value) do
        :ets.insert(@name, {key, value})
      end

      def del(key) do
        :ets.delete(@name, key)
      end

      def flush do
        :ets.delete_all_objects(@name)
      end

      def first do
        :ets.first(@name)
      end

      def next(key) do
        :ets.next(@name, key)
      end

    end
  end

end
