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

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin",
    phone_number: "02022",
    email: "admin@app.com",
    id_number: "32424",
    password_hash: "admin123"
  })
)

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin2",
    phone_number: "12345",
    email: "admin@appy.com",
    id_number: "32424234",
    password_hash: "admin123445"
  })
)

Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin3",
    phone_number: "1234567",
    email: "admin@application.com",
    id_number: "32424234567",
    password_hash: "admin123445678"
  })
)


Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin4",
    phone_number: "12345678",
    email: "admin@a.com",
    id_number: "324242345637",
    password_hash: "admin1234456378"
  })
)



Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin5",
    phone_number: "123456789",
    email: "admin@ai.com",
    id_number: "3242423456357",
    password_hash: "admin12344656378"
  })
)



Repo.insert!(
  Ecto.Changeset.change(%User{}, %{
    name: "Admin6",
    phone_number: "123456781",
    email: "admin@aie.com",
    id_number: "32424234563557",
    password_hash: "admin123446356378"
  })
)

