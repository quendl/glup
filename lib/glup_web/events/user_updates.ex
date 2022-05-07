defmodule GlupWeb.Events.User do
  use GenServer
  require Logger
  alias Phoenix.PubSub
  alias GlupWeb.Mails.UserMails

  @topic "user_updates"

  # Client

  def start_link(params) do
    GenServer.start_link(__MODULE__, params, name: __MODULE__)
  end

  # Server (callbacks)

  @impl true
  def init(_params) do
    PubSub.subscribe(Glup.PubSub, @topic)
    Logger.info("User Events Subscriber started successfully")
    {:ok, nil}
  end

  @impl true
  def handle_info({:created, user}, state) do
    Logger.info("Received a new user #{inspect(user)}")

    user
    |> UserMails.welcome()

    {:noreply, state}
  end

  @impl true
  def handle_info(_, state) do
    Logger.info("Event didn't match")
    {:noreply, state}
  end
end
