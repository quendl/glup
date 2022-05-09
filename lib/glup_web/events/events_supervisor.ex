defmodule GlupWeb.Events.Supervisor do
  use Supervisor
  alias GlupWeb.Events.User

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {User, [nil]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
