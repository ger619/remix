defmodule Remit.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :phone_number, :string, null: false
      add :email, :string
      add :id_number, :string
      add :id_type, references(:id_types, column: :slug, type: :string)
      add :password_hash, :string
      add :deleted_at, :timestamptz
      add :confirmed_at, :utc_datetime
      add :reset_sent_at, :utc_datetime
      add :super_admin, :boolean, null: false, default: false
      add :require_password_change, :boolean, null: false, default: false

      timestamps()
    end

    create unique_index(:users, [:phone_number])
  end
end
