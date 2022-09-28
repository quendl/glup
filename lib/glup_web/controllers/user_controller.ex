defmodule GlupWeb.UserController do
  use GlupWeb, :controller

  alias Glup.Users
  alias Glup.Users.User
  alias Phoenix.PubSub

  action_fallback GlupWeb.FallbackController

  @moduledoc """
  The `UserController` is responsible for handling all the requests related to the user.

  - https://hexdocs.pm/phoenix/Phoenix.Controller.html

  => Creating the user
  => Updating the user
  => Deleting the user
  => Fetching the user(s)

  => Logging in the user
  => SignUp functionality
  """

  @user_topic "user_updates"

  def index(conn, _params) do
    user = Users.list_user()
    render(conn, "index.json", user: user)
  end

  # Create the user (signup, in database)
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  # Lists the users
  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  # Update the users data
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  # Delete the user from the database
  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  # Handle the login and JWT token assignment
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

  # Signup, what else?!
  def signup(conn, %{"email" => _e, "username" => _u, "password" => pass} = params) do
    # background magic nobody should know about, psst!
    location = Task.async(fn -> GlupWeb.Location.Info.user_location(conn) end)
    signed_pwd = Users.sign_pwd(pass)
    user_params = Map.put(params, "password", signed_pwd)

    with {:ok, %User{username: username, email: email} = user} <- Users.create_user(user_params) do
      user = Map.put(user, :location, Task.await(location, :infinity))
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
