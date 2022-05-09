defmodule GlupWeb.Mails.UserMails do
  @moduledoc """
  Defines Emails sent to user
  """
  import Bamboo.Email
  alias Glup.Users.User

  def welcome(%User{email: email, username: name, location: location}) do
    # TODO: Move no~reply@glup.io to config
    # TODO: Move html body to html template
    new_email(
      to: {name, email},
      from: {"Glup", from_email()},
      subject: "Welcome to Glup.",
      html_body:
      "Thanks for registering a new account at Glup #{name}, you are now able to login to your account.

      <p><a href='https://google.com'><button>Login</button></a></p>

      <hr>
      Here are your account details:
      <p><strong>Username:</strong> #{name}</p>
      <p><strong>Location:</strong> #{location}</p>

      <hr>

      <p><a href='https://google.com'>Privacy Policy</a></p> <p><a href='https://google.com'>Support</a></p>
      ",
      text_body: "Thanks for joining Glup!"
    )
    |> Glup.Mailer.deliver_now!()
  end

  defp from_email() do
    # Define your from email here, default to mailgun's sandbox email
    System.fetch_env!("MAIL_GUN_SANDBOX_EMAIL")
  end
end
