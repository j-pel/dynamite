defmodule Dynamite.Supervisor do
  use Supervisor

  def start_link(_) do
    {:ok, _sup} = Supervisor.start_link(__MODULE__, [], name: :supervisor)   
  end

  def init(_) do
    children = [
    ]
		supervise(children, strategy: :one_for_one)
  end

end
