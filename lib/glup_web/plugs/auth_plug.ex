defmodule GlupWeb.Plugs.AuthPlug do
  alias Glup.Users
  import Plug.Conn

  use GlupWeb, :controller

  def init(options), do: options

  # this is the plug which handles authnetication
  def call(conn, _opts) do
    allowed_actions = ["/signup", "/signup/"]

    cond do
      Enum.member?(allowed_actions, conn.request_path) ->
        conn

      conn.request_path == "/login" or conn.request_path == "/login/" ->
        case Users.validate_user(conn) do
          {:ok, jwt, username} ->
            assign(conn, :user_details, %{jwt: jwt, username: username})

          :error ->
            conn
            |> put_status(:unauthorized)
            |> put_view(GlupWeb.ErrorView)
            |> Phoenix.Controller.render("401.json")
            |> halt
        end

      true ->
        auth = Plug.Conn.get_req_header(conn, "authorization")

        token =
          case auth do
            [token] ->
              token

            _ ->
              ""
          end

        case Users.validate_token(token) do
          {:ok, username} ->
            assign(conn, :user_details, %{jwt: token, username: username})

          _ ->
            conn
            |> put_status(:unauthorized)
            |> put_view(GlupWeb.ErrorView)
            |> Phoenix.Controller.render("401.json")
            |> halt
        end
    end
  end
end
