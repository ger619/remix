defmodule RemitWeb.TestUtil do
  import Ecto.Query, only: [from: 2]

  alias Remit.Repo

  def newest(queryable) do
    from(q in queryable, order_by: [desc: :id], limit: 1)
    |> Repo.one()
  end

  def count(queryable) do
    from(q in queryable, select: count("*"))
    |> Repo.one!()
  end
end
