defmodule GlupWeb.Plugs.RateLimiter do
  import Plug.Conn
  use GlupWeb, :controller
  alias GlupWeb.Location.Info
  require Logger

  @limit 2

  def init(options), do: options

  def call(conn, _opts) do
    ip = Info.ip(conn)

    case Hammer.check_rate(ip, 60_000, @limit) do
      {:allow, count} ->
        assign(conn, :requests_count, count)

      {:deny, _limit} ->
        Logger.debug("Rate limit exceeded for #{inspect(ip)}")
        error_response(conn)
    end
  end

  defp error_response(conn) do
    conn
    |> put_status(:service_unavailable)
    |> json(%{message: "service unavailable"})
    |> halt()
  end
end
