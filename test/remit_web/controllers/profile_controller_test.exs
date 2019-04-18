defmodule RemitWeb.ProfileControllerTest do
  use RemitWeb.ConnCase

  alias Remit.Repo
  alias Remit.Profile

  test "GET /profiles", %{conn: conn} do
    conn = get(conn, Routes.profile_path(conn, :index))
    assert html_response(conn, 200)
  end

  test "GET /profiles/new", %{conn: conn} do
    conn = get(conn, Routes.profile_path(conn, :new))
    assert html_response(conn, 200)
  end

  test "POST /profiles", %{conn: conn} do
    conn =
      post(conn, Routes.profile_path(conn, :create), %{
        "profile" => %{"name" => "An Agent", "type" => "business", "currency" => "USD"}
      })

    assert profile = newest(Profile)
    assert redirected_to(conn) == Routes.profile_path(conn, :show, profile)
  end

  test "GET /profiles/:id", %{conn: conn} do
    {:ok, profile} = Profile.create(%{name: "An Agent", type: "business", currency: "USD"})
    conn = get(conn, Routes.profile_path(conn, :show, profile))
    assert html_response(conn, 200)
  end

  test "GET /profiles/:id/edit", %{conn: conn} do
    {:ok, profile} = Profile.create(%{name: "An Agent", type: "business", currency: "USD"})
    conn = get(conn, Routes.profile_path(conn, :edit, profile))
    assert html_response(conn, 200)
  end

  test "PUT /profiles/:id", %{conn: conn} do
    {:ok, profile} = Profile.create(%{name: "An Agent", type: "business", currency: "USD"})

    conn =
      put(conn, Routes.profile_path(conn, :edit, profile), %{
        "profile" => %{"name" => "Another Agent", type: "business", currency: "USD"}
      })

    assert redirected_to(conn) == Routes.profile_path(conn, :show, profile)
    assert %{name: "Another Agent"} = Repo.get!(Profile, profile.id)
  end

  test "DELETE /profiles/:id", %{conn: conn} do
    {:ok, profile} = Profile.create(%{name: "An Agent", type: "business", currency: "USD"})
    conn = delete(conn, Routes.profile_path(conn, :delete, profile))
    assert redirected_to(conn) == Routes.profile_path(conn, :show, profile)
    assert %{archived: true} = Repo.get!(Profile, profile.id)
  end
end
