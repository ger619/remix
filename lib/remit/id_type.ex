defmodule Remit.IDType do
  use Ecto.Schema
  alias Remit.Repo

  @primary_key false
  schema "id_types" do
    field(:slug, :string, primary_key: true)
    field(:name, :string)

    timestamps()
  end

  def all do
    Repo.all(__MODULE__)
  end

end
