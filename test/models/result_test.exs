defmodule Vestibule.ResultTest do
  use Vestibule.ModelCase

  alias Vestibule.Result

  @valid_attrs %{output: "some content", pass: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Result.changeset(%Result{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Result.changeset(%Result{}, @invalid_attrs)
    refute changeset.valid?
  end
end
