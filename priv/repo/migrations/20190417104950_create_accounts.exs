defmodule Remit.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :profile_id, references(:profiles), null: false
      add :credits, :decimal, null: false, default: 0
      add :debits, :decimal, null: false, default: 0
      add :balance, :decimal, null: false, default: 0


      timestamps()
    end

    create unique_index(:accounts, [:profile_id])
  end
end
