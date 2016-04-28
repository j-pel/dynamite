defmodule ViewsHandler do

  def init(_type, req, opts) do
    { :ok, req, opts }
  end

  def handle(request, state) do
    [page: page] = state
    { :ok, reply } = :cowboy_req.reply( 
      200, 
      [ {"content-type", "text/html"} ],
      eval("index", [req: request, page: page]),
      request
    )
		{:ok, reply, state}
  end

  def eval(page, opts) do
    {port,_} = :cowboy_req.port(opts[:req])
    {_site, info} = get_info(port)
    EEx.eval_file info[:routing_table][:views] <> page <> ".eex", opts
  end
  
  def get_info(port) do
    Application.fetch_env!(:dynamite, :sites)
      |> Enum.find(fn(x) -> { _, [{:port, p}| _]} = x
          p == port
        end)
  end

  def terminate(_reason, _request, _state) do
    #IO.puts("Terminating for reason: #{inspect(reason)}")
    #IO.puts("Terminating after request: #{inspect(request)}")
    #IO.puts("Terminating with state: #{inspect(state)}")
    :ok
  end
end
