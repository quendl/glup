defmodule GlupWeb.Location.Info do
  require Logger

  # helper function for the connection
  def user_location(conn) do
    conn
    |> ip()
    |> url()
    |> fetch_location()
  end

  @doc """
  Here we are using an APi to fetch the location of the user, based on the IP address.

  - https://hexdocs.pm/httpoison/HTTPoison.html
  - https://hexdocs.pm/elixir/1.12/Map.html
  """

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
    access_key = Application.get_env(:glup, :access_key)
    "http://api.ipstack.com/#{ip}?access_key=#{access_key}"
  end

  # manually recieving the IP address of the connected user
  def ip(conn) do
    with %Plug.Conn{remote_ip: remote_ip} <- conn do
      ip = to_string(:inet_parse.ntoa(remote_ip))

      if ip == "127.0.0.1" do
        "52.155.68.130"
      else
        ip
      end
    end
  end
end
