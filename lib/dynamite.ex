defmodule Dynamite do
  use Application

  def start(_type, _args) do
    Application.fetch_env!(:dynamite, :sites)
      |>launch
    device = File.open!("dbg.log", [:write])
    Application.put_env(:dbg, :device, device) 
    Dynamite.Supervisor.start_link([])
  end
  
  def site_info(site, :static_path) do
    sites = Application.fetch_env!(:dynamite, :sites)
    site = sites[site]
    table = site[:routing_table]
    route = table[:static]
  end

  defp launch([]) do
  end

  defp launch(sites) do
    [site|rest] = sites
    {name,info} = site
    {:ok,pid} = :cowboy.start_http(name, 100,
      [{:port, info[:port]}], [{ :env, [{:dispatch, []}]}]
    )
    table = info[:routing_table]
    EEx.eval_file table[:routes]<>"main.eex"
    IO.puts("info for #{name}: #{inspect(pid)}")
    launch(rest)
  end
  
end
