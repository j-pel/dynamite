defmodule ConsoleHandler do

  def init(_type, req, opts) do
    { :ok, req, opts }
  end

  def handle(request, state) do
    [page: page] = state
    { :ok, reply } = :cowboy_req.reply( 
      200, 
      [ {"content-type", "text/html"} ],
      eval("console", [req: request, page: page]),
      request
    )
		{:ok, reply, state}
  end

  def eval(page, opts) do
    page = :binary.list_to_bin(:code.priv_dir(:dynamite)) <> "/console/views/" <> page <> ".eex"
    EEx.eval_file page, opts
  end
  
  def terminate(_reason, _request, _state) do
    :ok
  end

  def get_sites() do
    Application.fetch_env!(:dynamite, :sites)
  end

end
