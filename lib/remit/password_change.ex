defmodule Remit.PasswordChange do
  use Ecto.Schema
  alias Remit.{Repo, User}
  import Ecto.Changeset

  embedded_schema do
    field :current_password
    field :password
    field :password_confirmation
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:current_password, :password, :current_password])
    |> validate_required([:current_password, :password])
    |> validate_confirmation(:password, message: "Password doesn't match")
  end

  def update_password(params, user) do
    changes = changeset(%__MODULE__{}, params)

    with {:ok, struct} <- apply_action(changes, :update),
         true <- Bcrypt.verify_pass(struct.current_password, user.password_hash) do
      user
      |> User.changeset(%{password_hash: struct.password})
      |> change(require_password_change: false)
      |> Repo.update()
    else
      false ->
        changes = add_error(changes, :current_password, "doesnt match existing password")
        {:error, %{changes | action: :update}}

      error ->
        error
    end
  end
end
