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
    site = Application.fetch_env!(:dynamite, :site)
    sites = Application.fetch_env!(:dynamite, :sites)
    table = sites[site][:routing_table]
		EEx.eval_file table[:views] <> page <> ".eex", opts
  end
  
  def get_info(:db_server) do
    site = Application.fetch_env!(:dynamite, :site)
    sites = Application.fetch_env!(:dynamite, :sites)
    sites[site][:database][:server]
  end

  def terminate(_reason, _request, _state) do
    :ok
  end
end
