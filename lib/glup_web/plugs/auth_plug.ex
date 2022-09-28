defmodule GlupWeb.Plugs.AuthPlug do
  alias Glup.Users
  import Plug.Conn

  use GlupWeb, :controller

  @moduledoc """
  This module handles the authentication of the user.

  - logging in (with jwt tokens)
  - authorization, running DB queries etc.
  """

  def init(options), do: options

  def call(conn, _opts) do
    allowed_actions = ["/signup", "/signup/"]

    cond do
      Enum.member?(allowed_actions, conn.request_path) ->
        conn

      @doc """
      Validate the users access with JWT tokens, return an error if the user is not authorized.
      """
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
