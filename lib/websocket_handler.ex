defmodule WebsocketHandler do
  @behaviour :cowboy_websocket_handler

  def init({_tcp, _http}, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_TransportName, req, _opts) do
    ws_broadcast(:nodes, {:new, :erlang.pid_to_list(self())})
    {:ok, req, :undefined_state }
  end

  def websocket_terminate(_reason, _req, _state) do
    ws_broadcast(:nodes, {:bye, :erlang.pid_to_list(self())})
    :ok
  end

  def websocket_handle({:text, content}, req, state) do
    { :ok, %{ "message" => msg} } = Poison.decode(content)
    ws_broadcast(:custom,msg)
    { :ok, reply } = Poison.encode(%{ reply: msg})
    {:reply, {:text, reply}, req, state}
  end
  
  def websocket_handle(_data, req, state) do    
		#IO.puts("Message: #{inspect(_data)}")
    {:ok, req, state}
  end

  def websocket_info({:custom, ref, _foo}, req, state) do
    { :ok, reply } = Poison.encode(%{ reply: ref})
    {:reply, {:text, reply}, req, state}
  end

  def websocket_info({:nodes, ref, _foo}, req, state) do
    ret = case ref do
      { :new, pid } -> "new node "<>:erlang.list_to_binary(pid)
      { :bye, pid } -> "bye node "<>:erlang.list_to_binary(pid)
      other -> syntax_error(other)
    end
    nodes = ws_list
      |>Enum.map(fn(pid)->:erlang.pid_to_list(pid) end)
      |>:erlang.list_to_binary
    this_node = self()
      |> :erlang.pid_to_list
      |> :erlang.list_to_binary
    { :ok, reply } = Poison.encode(%{ nodes: nodes, reply: ret, self: this_node})
    {:reply, {:text, reply}, req, state}
  end

  def websocket_info(_info, req, state) do
    {:ok, req, state}
  end

  @doc """
  Gets the list of all active websocket PIDs from the ranch supervisor.
  """
  def ws_list() do
    Process.whereis(:ranch_sup) 
      |> Supervisor.which_children
      |> Enum.find(fn(x) -> elem(x,0) == {:ranch_listener_sup, :http} end)
      |> elem(1)
      |> Supervisor.which_children
      |> Enum.find(fn(x) -> elem(x,0) == :ranch_conns_sup end)
      |> elem(1)
      |> Supervisor.which_children
      |> Enum.map(fn(x) -> elem(x,1) end)
      |> Enum.filter(fn(b) -> 
        [current_function: {:cowboy_websocket, :handler_loop, 4}] ==
        Process.info(b,[:current_function]) end)
  end
  
  @doc """
  Broadcasts a `msg` to all active websockets supervised by ranch_conns_sup.
  """
  def ws_broadcast(type, msg, opts \\ []) do
    ws_list |> Enum.map(fn(pid) -> Process.send(pid,{type,msg,opts},[]) end)
  end

  ## Errors

  defp syntax_error(<<token :: utf8>> <> _) do
    throw({:invalid, <<token>>})
  end

  defp syntax_error(_) do
    throw(:invalid)
  end

end

