defmodule GlupWeb.PageController do
  use GlupWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
