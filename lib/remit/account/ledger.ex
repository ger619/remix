defmodule Remit.Account.Ledger do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ledgers" do
    field :account_id, :id
    field :transaction_id, :id
    field :credit, :decimal
    field :debit, :decimal
    field :balance, :decimal
    field :currency, :string

    timestamps()
  end

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:account_id, :transaction_id, :credit, :debit, :balance, :currency])
    |> validate_required([:account_id, :transaction_id, :credit, :debit, :balance, :currency])
  end
end
