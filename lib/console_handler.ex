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
    page = :binary.list_to_bin(:code.priv_dir(:dynamite)) <> "/fuse/views/" <> page <> ".eex"
    EEx.eval_file page, opts
  end
  
  def terminate(_reason, _request, _state) do
    :ok
  end

  def get_sites() do
    Application.fetch_env!(:dynamite, :sites)
  end

end

defmodule CommandHandler do

  def init(_type, req, opts) do
    { :ok, req, opts }
  end

  def handle(request, state) do
    {command, _} = :cowboy_req.binding(:com, request)
    IO.puts "State: #{state}"
    ret = case command do
      "sites" -> Poison.encode!(%{sites: 2, active: 1})
      "site" -> Poison.encode!(%{site: "active"})
      other -> "{\"error\": \"Unknown command\", \"command\": \"" <> other <> "\"}"
    end
    { :ok, reply } = :cowboy_req.reply(200,
      [ {"content-type", "application/json"} ],
      ret, request
    )
		{:ok, reply, state}
  end

  def terminate(_reason, _request, _state) do
    :ok
  end

  def get_sites() do
    Application.fetch_env!(:dynamite, :sites)
  end

end
