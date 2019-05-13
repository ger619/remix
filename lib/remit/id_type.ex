defmodule Remit.IDType do
  use Ecto.Schema

  @primary_key false
  schema "id_types" do
    field(:slug, :string, primary_key: true)
    field(:name, :string)

    timestamps()
  end
end
