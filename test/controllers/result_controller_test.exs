defmodule Vestibule.ResultControllerTest do
  use Vestibule.ConnCase

  alias Vestibule.Result
  @valid_attrs %{output: "some content", pass: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, result_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing results"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, result_path(conn, :new)
    assert html_response(conn, 200) =~ "New result"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, result_path(conn, :create), result: @valid_attrs
    assert redirected_to(conn) == result_path(conn, :index)
    assert Repo.get_by(Result, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, result_path(conn, :create), result: @invalid_attrs
    assert html_response(conn, 200) =~ "New result"
  end

  test "shows chosen resource", %{conn: conn} do
    result = Repo.insert! %Result{}
    conn = get conn, result_path(conn, :show, result)
    assert html_response(conn, 200) =~ "Show result"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, result_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    result = Repo.insert! %Result{}
    conn = get conn, result_path(conn, :edit, result)
    assert html_response(conn, 200) =~ "Edit result"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    result = Repo.insert! %Result{}
    conn = put conn, result_path(conn, :update, result), result: @valid_attrs
    assert redirected_to(conn) == result_path(conn, :show, result)
    assert Repo.get_by(Result, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    result = Repo.insert! %Result{}
    conn = put conn, result_path(conn, :update, result), result: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit result"
  end

  test "deletes chosen resource", %{conn: conn} do
    result = Repo.insert! %Result{}
    conn = delete conn, result_path(conn, :delete, result)
    assert redirected_to(conn) == result_path(conn, :index)
    refute Repo.get(Result, result.id)
  end
end
