@moduledoc """
    We are using Mailgun as the basic email service.
    Feel free to use your owns (sandbox if dev mode)
"""

defmodule Glup.Mailer do
  use Bamboo.Mailer, otp_app: :glup
end
