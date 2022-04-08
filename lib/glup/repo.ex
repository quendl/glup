defmodule Glup.Repo do
  use Ecto.Repo,
    otp_app: :glup,
    adapter: Ecto.Adapters.MyXQL
end
