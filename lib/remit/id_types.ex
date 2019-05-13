defmodule Remit.IdTypes do
  use Ecto.Schema
  import Ecto.Query

  alias Remit.Repo

  @primary_key false

  schema "id_types" do
    field :name, :string, null: false
    field :slug, :string, null: false

    timestamps()
  end

  def all do
    Repo.all(from i in __MODULE__, select: [i.name, i.slug])
  end

end


