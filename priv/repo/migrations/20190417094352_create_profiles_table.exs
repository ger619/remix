defmodule Remit.Repo.Migrations.CreateProfilesTable do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :string, null: false
      add :type, :string, null: false
      add :slug, :string, null: false
      add :currency, :string, null: false
      add :archived, :boolean, null: false, default: false

      timestamps()
    end

    create unique_index(:profiles, [:slug])
  end
end
