defmodule Remit.PasswordChange do
  use Ecto.Schema
  import Ecto.Changeset
  alias Remit.Repo

  embedded_schema do
    field :password
    field :password_confirmation
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:password])
    |> validate_required([:password |> encrypt_password()])
    |> validate_confirmation(:password, message: "does not match password")
  end

  def update_password(attrs) do
    %__MODULE__{}
    |> changeset(attrs)

    # |> Repo.update()
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
