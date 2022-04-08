defmodule GlupWeb.ErrorView do
  use GlupWeb, :view
  alias Glup.Helpers.Messages

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # Handle 404 error
  def render("404.json", _assigns) do
    Messages.common_response_msg("NO_ROUTE", "")
  end

  # Handle 500 error
  def render("500.json", _assigns) do
    Messages.common_response_msg("INTERNAL_SERVER_ERROR", "")
  end

  # Handle 401 error
  def render("401.json", _assigns) do
    Messages.common_response_msg("UNAUTHORIZED", "")
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
