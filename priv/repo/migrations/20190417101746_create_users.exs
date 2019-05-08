defmodule Remit.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :phone_number, :string, null: false
      add :email, :string
      add :id_number, :string
      add :id_type, :string
      add :password_hash, :string
      add :deleted_at, :timestamptz
      timestamps()
    end

    create unique_index(:users, [:phone_number])
  end
end
