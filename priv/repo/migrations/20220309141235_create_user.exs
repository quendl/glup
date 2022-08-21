defmodule Glup.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :username, :string
      add :password, :string
      add :email, :string

      timestamps()
    end

    create unique_index("user", [:username])
    create unique_index("user", [:email])
  end
end
