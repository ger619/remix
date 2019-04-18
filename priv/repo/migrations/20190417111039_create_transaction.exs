defmodule Remit.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :decimal, null: false
      add :service, :text, null: false
      add :currency, :string, null: false

      timestamps()
    end
  end
end
