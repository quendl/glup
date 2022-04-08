defmodule Glup.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Glup.Repo

  alias Glup.Users.User
  alias Glup.Token

  @doc """
  Returns the list of user.
  
  ## Examples
  
      iex> list_user()
      [%User{}, ...]
  
  """
  def list_user do
    Repo.all(User)
  end

  @doc """
  Gets a single user.
  
  Raises `Ecto.NoResultsError` if the User does not exist.
  
  ## Examples
  
      iex> get_user!(123)
      %User{}
  
      iex> get_user!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.
  
  ## Examples
  
      iex> create_user(%{field: value})
      {:ok, %User{}}
  
      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  
  ## Examples
  
      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}
  
      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.
  
  ## Examples
  
      iex> delete_user(user)
      {:ok, %User{}}
  
      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  
  ## Examples
  
      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}
  
  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  # This function validates user data in th login request
  def validate_user(conn) do
    body_params = conn.body_params
    user_input_name = body_params["username"]
    user_input_pwd = body_params["password"]
    user = get_user_from_username(user_input_name)

    if user != nil do
      pwd = user.password

      if Pbkdf2.verify_pass(user_input_pwd, pwd) do
        user_data = %{"username" => user_input_name}
        jwt_token = create_jwt_token(user_data)
        {:ok, jwt_token, user_input_name}
      else
        :error
      end
    else
      :error
    end
  end

  # This function search and return user from the DB
  def get_user_from_username(username) do
    username = to_string(username)
    query = from u in User, where: u.username == ^username
    Repo.one(query)
  end

  # This function Signs thw pwd
  def sign_pwd(pwd) do
    if to_string(pwd) != "" do
      Pbkdf2.hash_pwd_salt(pwd)
    else
      ""
    end
  end

  # This function generates a JWT
  def create_jwt_token(user_data) do
    unix_now = DateTime.utc_now() |> DateTime.to_unix()
    unix_exp_time = unix_now + 3600
    token_data = user_data |> Map.put("exp", unix_exp_time)
    {:ok, token, _claims} = Token.generate_and_sign(token_data)
    token
  end

  # This function validates token in the TEST API and any other API that uses token
  def validate_token(token) do
    case Token.verify_and_validate(token) do
      {:ok, claims} ->
        username = claims["username"]
        {:ok, username}

      _ ->
        :error
    end
  end
end
