defmodule Remit.Repo.Migrations.CreateProfilesTable do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :string, null: false
      add :type, :string, null: false
      add :slug, :string, null: false
      add :currency, :string, null: false
      add :user_id, references(:users)
      add :deleted_at, :timestamptz

      timestamps()
    end

    create unique_index(:profiles, [:slug])
  end
end
