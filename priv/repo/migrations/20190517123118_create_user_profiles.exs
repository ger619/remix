defmodule Remit.Repo.Migrations.CreateUserProfiles do
  use Ecto.Migration

  def change do
    create table(:user_profiles) do
      add :role, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :profile_id, references(:profiles, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:user_profiles, [:user_id, :profile_id])
  end
end
