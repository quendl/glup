defmodule Glup.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :password, :string
    field :username, :string
    field :email, :string
    field :location, :string, virtual: true

    timestamps()
  end

  # This function does the validations before inserting data into the database
  # return if user exists with the same username
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:name,
      name: :user_username_index,
      message: "USER_EXISTS_WITH_SAME_USERNAME"
    )
    |> unique_constraint(:email,
    name: :user_email_index,
    message: "USER_EXISTS_WITH_SAME_EMAIL"
  )
  end
end
