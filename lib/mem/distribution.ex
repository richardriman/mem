defmodule Distribution do
  require Logger

  def connect_to_nodes(nodes) do
    Logger.debug ">>> Try to connect on nodes: #{inspect nodes}"
    do_connect(nodes)
    Logger.debug ">>> DONE!!"
  end

  def first_node?(nodes, n) do
    (Enum.sort(nodes) |> hd) == n
  end

  def start_mnesia(nodes) do
    Logger.debug ">>> Starting mnesia remotely"
    ret = :rpc.multicall(nodes, Application, :start, [:mnesia])
    Logger.debug ">>> Starting mnesia remotely #{inspect ret} DONE!"
  end

  def stop_mnesia(nodes) do
    Logger.debug ">>> Stopping mnesia remotely ..."
    ret = :rpc.multicall(nodes, Application, :stop, [:mnesia])
    Logger.debug ">>> Stopping mnesia remotely #{inspect ret} DONE!"
  end

  def wait_mnesia_starting(times\\10) do
    app = Application.started_applications() |> Enum.filter(fn {a, _, _} -> a == :mnesia end)
    if (length(app) > 0) do
      :ok
    else
      if times > 0 do
        :timer.sleep(1000)
        wait_mnesia_starting(times - 1)
      else
        :timeout
      end
    end
  end

  defp do_connect([n | tail]) do
    if n != node() do
      connect_to_node(n)
    end
    if length(tail) > 0 do
      do_connect(tail)
    end
  end

  defp connect_to_node(n, times\\60) do
    Logger.debug ">>> Try to connect to node: #{n} ..."
    if r = Node.connect(n) do
      Logger.debug ">>> Connected to node: #{n} - #{inspect r}"
    else
      Logger.debug ">> WAIT node: #{n}"
      :timer.sleep(1000)
      if times > 0 do
        connect_to_node(n, times - 1)
      end
    end
  end

end
