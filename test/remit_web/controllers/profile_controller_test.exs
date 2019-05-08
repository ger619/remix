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

  test "POST /profiles when valid", %{conn: conn} do
    conn =
      post(conn, Routes.profile_path(conn, :create), %{
        "profile" => %{"name" => "An Agent", "type" => "business", "currency" => "USD"},
        "profile_type" => "business"
      })

    assert profile = newest(Profile)
    assert redirected_to(conn) == Routes.profile_path(conn, :show, profile)
  end

  test "POST /profiles when invalid", %{conn: conn} do
    conn =
      post(conn, Routes.profile_path(conn, :create), %{
        "profile" => %{"name" => "An Agent", "type" => "business", "currency" => ""},
        "profile_type" => "business"
      })

    assert html_response(conn, 200)
  end

  test "GET /profiles/:id", %{conn: conn} do
    {:ok, profile} =
      Profile.create(%{name: "An Agent", type: "business", currency: "USD"}, "business")

    conn = get(conn, Routes.profile_path(conn, :show, profile))
    assert html_response(conn, 200)
  end

  test "GET /profiles/:id/edit", %{conn: conn} do
    {:ok, profile} =
      Profile.create(%{name: "An Agent", type: "business", currency: "USD"}, "business")

    conn = get(conn, Routes.profile_path(conn, :edit, profile))
    assert html_response(conn, 200)
  end

  test "PUT /profiles/:id", %{conn: conn} do
    {:ok, profile} =
      Profile.create(%{name: "An Agent", type: "business", currency: "USD"}, "business")

    conn =
      put(conn, Routes.profile_path(conn, :update, profile), %{
        "profile" => %{"name" => "Another Agent", type: "business", currency: "USD"}
      })

    assert redirected_to(conn) == Routes.profile_path(conn, :show, profile)
    assert %{name: "Another Agent"} = Repo.get!(Profile, profile.id)
  end

  @tag :skip
  test "DELETE /profiles/:id", %{conn: conn} do
    {:ok, profile} =
      Profile.create(%{name: "An Agent", type: "business", currency: "USD"}, "business")

    conn = delete(conn, Routes.profile_path(conn, :delete, profile))
    assert redirected_to(conn) == Routes.profile_path(conn, :show, profile)
    %{deleted_at: deleted_at} = Repo.get!(Profile, profile.id)
    assert deleted_at
  end
end
