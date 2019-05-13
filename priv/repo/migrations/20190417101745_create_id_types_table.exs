defmodule Remit.Repo.Migrations.CreateIdTypesTable do
  use Ecto.Migration

  def change do
    create table(:id_types, primary_key: false) do
      add :slug, :string, null: false, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end
