defmodule Remit.Repo.Migrations.AddDeletedAt do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :deleted_at, :timestampz
    end
  end
end
