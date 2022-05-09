defmodule GlupWeb.Location.Info do
  require Logger

  def user_location(conn) do
    conn
    |> ip()
    |> url()
    |> fetch_location()
  end

  defp fetch_location(url) do
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url) do
      case Jason.decode(body) do
        {:ok, data} ->
          Logger.debug("Received location info #{inspect(data)}")
          Map.get(data, "country_name", "")

        error ->
          Logger.error(
            "Encountered an error while trying to retrieve location info #{inspect(error)}"
          )

          nil
      end
    end
  end

  defp url(ip) do
    # move access key to config
    "http://api.ipstack.com/#{ip}?access_key=969d43bf82dfb8697d28a33c24cb0b13"
  end

  defp ip(conn) do
    with %Plug.Conn{remote_ip: remote_ip} <- conn do
      ip = to_string(:inet_parse.ntoa(remote_ip))

      if ip == "127.0.0.1" do
        "62.47.244.0"
      else
        ip
      end
    end
  end
end
