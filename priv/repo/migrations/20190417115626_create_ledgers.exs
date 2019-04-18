defmodule Remit.Repo.Migrations.CreateLedgers do
  use Ecto.Migration

  def change do
    create table(:ledgers) do
      add :account_id, references(:accounts), null: false
      add :transaction_id, references(:transactions), null: false
      add :credit, :decimal
      add :debit, :decimal
      add :balance, :decimal, null: false
      add :currency, :string, null: false

      timestamps()
    end

    create constraint(:ledgers, "credit_or_debit_must_exist",
             check: "NOT(credit IS NULL AND debit IS NULL)"
           )
  end
end
