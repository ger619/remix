defmodule Remit.Repo.Migrations.ProfilesDeletedAt do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :deleted_at, :timestampz
  end
end
