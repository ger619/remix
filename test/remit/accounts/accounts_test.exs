defmodule Remit.AccountsTest do
  use Remit.DataCase

  alias Remit.Accounts

  describe "users" do
    alias Remit.User

    @valid_attrs %{
      email: "some@email.com",
      id_number: "some_id_number",
      id_type: "national_id",
      name: "some_name",
      password_hash: "some_password_hash",
      phone_number: "some_phone_number"
    }
    @update_attrs %{
      email: "some@updatedemail.com",
      id_number: "some_updated_id_number",
      id_type: "national_id",
      name: "some_updated_name",
      password_hash: "some_updated_password_hash",
      phone_number: "some_updated_phone_number"
    }
    @invalid_attrs %{
      email: nil,
      id_number: nil,
      id_type: nil,
      name: nil,
      password_hash: nil,
      phone_number: nil
    }

    def user_fixture(attrs \\ %{}) do
      now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

      Repo.insert!(
        %Remit.IDType{
          slug: @valid_attrs.id_type,
          name: "National ID",
          inserted_at: now,
          updated_at: now
        },
        on_conflict: :nothing
      )

      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user_fixture()
      assert [user | _] = Accounts.list_users()
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.id_number == "some_id_number"
      assert user.id_type == "national_id"
      assert user.name == "some_name"
      assert Bcrypt.verify_pass("some_password_hash", user.password_hash)
      assert user.phone_number == "some_phone_number"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some@updatedemail.com"
      assert user.id_number == "some_updated_id_number"
      assert user.id_type == "national_id"
      assert user.name == "some_updated_name"
      assert Bcrypt.verify_pass("some_updated_password_hash", user.password_hash)
      assert user.phone_number == "some_updated_phone_number"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert %User{deleted_at: deleted_at} = Accounts.delete_user!(user)
      assert deleted_at
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
