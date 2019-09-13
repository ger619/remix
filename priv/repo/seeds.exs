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
alias Remit.IDType

alias Remit.User

Repo.delete_all(User)
Repo.delete_all(IDType)

entries =
  [%{slug: "national_id", name: "National ID"}]
  |> Enum.map(fn id_type ->
    id_type
    |> Map.put(:inserted_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> Map.put(:updated_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
  end)

{1, _} = Repo.insert_all(Remit.IDType, entries)

entries =
  [%{slug: "passport", name: "PassPort"}]
  |> Enum.map(fn id_type ->
    id_type
    |> Map.put(:inserted_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> Map.put(:updated_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
  end)

{1, _} = Repo.insert_all(Remit.IDType, entries)

entries =
  [%{slug: "resident_id", name: "Resident ID"}]
  |> Enum.map(fn id_type ->
    id_type
    |> Map.put(:inserted_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> Map.put(:updated_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
  end)

{1, _} = Repo.insert_all(Remit.IDType, entries)

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin",
    phone_number: "123456",
    email: "admin@app.com",
    id_number: "32424",
    id_type: "national_id",
    password_hash: Bcrypt.hash_pwd_salt("admin123")
  })
)

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin2",
    phone_number: "696896",
    email: "adwedmin@app.com",
    id_number: "32425",
    id_type: "national_id",
    password_hash: Bcrypt.hash_pwd_salt("admin123")
  })
)

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin4",
    phone_number: "9820222",
    email: "admin@app.com",
    id_number: "32426",
    id_type: "national_id",
    password_hash: Bcrypt.hash_pwd_salt("admin123")
  })
)

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin5",
    phone_number: "020222",
    email: "admin@app.com",
    id_number: "32427",
    id_type: "national_id",
    password_hash: Bcrypt.hash_pwd_salt("admin123")
  })
)
