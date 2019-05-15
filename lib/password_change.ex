defmodule Remit.PasswordChange do
  use Ecto.Schema
  alias Remit.Repo
  alias Remit.User
  import Ecto.Changeset

  embedded_schema do
    field :current_password
    field :password
    field :password_confirmation
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password, :current_password])
    |> validate_required([:password, :current_password])
    |> validate_confirmation(:password, message: "Password dont match")
  end

  def update_password(
        %{"current_password" => _, "password" => new_password} = params,
        user
      ) do
    changes = changeset(%__MODULE__{}, params)

    if changes.valid? do
      current_pwd = get_change(changes, :current_password)

      if Bcrypt.verify_pass(current_pwd, user.password_hash) do
        User.changeset(user, %{password_hash: new_password})
        |> Repo.update()
      else
        changes = add_error(changes, :current_password, "doesnt match existing password")
        {:error, %{changes | action: :update}}
      end
    else
      {:error, changes}
    end
  end
end
