defmodule GlupWeb.Mails.UserMails do
  @moduledoc """
  Defines Emails sent to user
  """
  import Swoosh.Email
  alias Glup.Users.User

  def welcome(%User{email: email, username: name}) do
    # TODO: Move no~reply@glup.io to config
    # TODO: Move html body to html template
    new()
    |> to({name, email})
    |> from({"Glup", "no~reply@glup.io"})
    |> subject("Welcome")
    |> html_body("<h1>Hello #{name}</h1>")
    |> text_body("Hello #{name}\n")
    |> Mailer.deliver()
    |> IO.inspect()
  end
end
