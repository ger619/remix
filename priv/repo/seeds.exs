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
alias Remit.User

Repo.delete_all(User)

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin",
    phone_number: "123456",
    email: "admin@app.com",
    id_number: "32424",
    id_type: "national id",
    password_hash: Bcrypt.hash_pwd_salt("admin123")
  })
)

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin2",
    phone_number: "696896",
    email: "adwedmin@app.com",
    id_number: "32424",
    password_hash: Bcrypt.hash_pwd_salt("admin123")
  })
)

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin4",
    phone_number: "9820222",
    email: "admin@app.com",
    id_number: "32424",
    password_hash: Bcrypt.hash_pwd_salt("admin123")
  })
)

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin5",
    phone_number: "020222",
    email: "admin@app.com",
    id_number: "32424",
    password_hash: Bcrypt.hash_pwd_salt("admin123")
  })
)
