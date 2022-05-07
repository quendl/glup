defmodule Glup.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :password, :string
    field :username, :string
    field :email, :string

    timestamps()
  end

  # This function does the validations before inserting data into DB
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:name,
      name: :user_username_index,
      message: "USER_EXISTS_WITH_SAME_USERNAME"
    )
  end
end
