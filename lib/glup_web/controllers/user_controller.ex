defmodule GlupWeb.UserController do
  use GlupWeb, :controller

  alias Glup.Users
  alias Glup.Users.User
  alias Phoenix.PubSub

  action_fallback GlupWeb.FallbackController

  @user_topic "user_updates"

  def index(conn, _params) do
    user = Users.list_user()
    render(conn, "index.json", user: user)
  end

  # Function to create the user
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  # Function to update the user
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  # Function to delete the user
  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  # Login functionality is handled here
  def login(conn, _params) do
    user_details = conn.assigns.user_details

    data = %{
      "username" => user_details[:username],
      "jwt" => user_details[:jwt]
    }

    conn
    |> put_status(:ok)
    |> render("status.json", %{status_code: "SUCCESS", attribute: "", data: data})
  end

  # Signup functionality is handled here
  def signup(conn, %{"email" => _e, "username" => _u, "password" => pass} = params) do
    # Fetch in the background
    location = Task.async(fn -> GlupWeb.Location.Info.user_location(conn) end)
    signed_pwd = Users.sign_pwd(pass)
    user_params = Map.put(params, "password", signed_pwd)

    with {:ok, %User{username: username, email: email} = user} <- Users.create_user(user_params) do
      user = Map.put(user, :location, Task.await(location, :infinity))
      # Publish event to phoenix pub sub
      PubSub.broadcast(Glup.PubSub, @user_topic, {:created, user})

      conn
      |> put_status(:created)
      |> render("status.json", %{
        status_code: "SUCCESS",
        attribute: "",
        data: %{username: username, email: email}
      })
    end
  end

  # Test API functionality is handled here
  def test(conn, _params) do
    send_resp(conn, 200, "Test Success. Authenticated")
  end
end
