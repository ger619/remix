defmodule Remit.IDType do
  use Ecto.Schema
  import Ecto.Query
  alias Remit.Repo

  @primary_key false
  schema "id_types" do
    field(:slug, :string, primary_key: true)
    field(:name, :string)

    timestamps()
  end

  def all do
    Repo.all(from i in __MODULE__, select: [i.name, i.slug])
  end

end
