defmodule Remit.PasswordChange do
  use Ecto.Schema
  alias Remit.Repo
  alias Remit.User

  embedded_schema do
    field :password
    field :password_confirmation
  end

  def update_password(%{"current_password" => current_pwd, "password" => new_password}, user) do
    if Comeonin.Bcrypt.verify_pass(user.password_hash, current_pwd) do
      new_user = %{
        name: user.name,
        phone_number: user.phone_number,
        email: user.email,
        id_number: user.id_number,
        id_type: user.id_type,
        password_hash: new_password
      }

      User.changeset(%User{}, new_user)
      |> Repo.update()
    else
    end
  end
end
