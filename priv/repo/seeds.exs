# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Remit.Repo.insert!(%Remit.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Remit.Repo
alias Remit.IdTypes

Repo.insert(Ecto.Changeset.change(%IdTypes{}, %{ 
  slug: "national-id",
  name: "National Id",
  inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
  updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)
}))

Repo.insert(Ecto.Changeset.change(%IdTypes{}, %{
  slug: "passport",
  name: "Passport",
  inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
  updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)
}))

Repo.insert(Ecto.Changeset.change(%IdTypes{}, %{
  slug: "resident-id",
  name: "Resident Id",
  inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
  updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)
}))



