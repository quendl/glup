defmodule GlupWeb.UserView do
  use GlupWeb, :view
  alias GlupWeb.UserView
  alias Glup.Helpers.Messages

  def render("index.json", %{user: user}) do
    %{data: render_many(user, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  # This prepares the response to be shown to the user
  def render("status.json", %{status_code: status_code, attribute: attribute, data: data}) do
    Messages.common_response_msg(status_code, attribute, data)
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username, password: user.password}
  end
end
