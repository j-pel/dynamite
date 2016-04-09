defmodule Dynamite do
  use Application

  def set_site(site) do
    Application.put_env(:dynamite,:site,site)
    compile_routes
  end
  
  def compile_routes do
    site = Application.fetch_env!(:dynamite, :site)
    sites = Application.fetch_env!(:dynamite, :sites)
    table = sites[site][:routing_table]
    EEx.eval_file table[:routes]<>"main.eex"
    :ok
  end

  def start(_type, _args) do
    site = Application.fetch_env!(:dynamite, :site)
    sites = Application.fetch_env!(:dynamite, :sites)
    port = sites[site][:port]
    { :ok, _ } = :cowboy.start_http(:http, 
                                    100,
                                   [{:port, port}],  
                                   [{ :env, [{:dispatch, []}]}]
                                   ) 

    compile_routes
    device = File.open!("dbg.log", [:write])
    Application.put_env(:dbg, :device, device) 
    Dynamite.Supervisor.start_link([])
  end

end
