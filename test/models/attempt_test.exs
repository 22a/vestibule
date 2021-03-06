defmodule Vestibule.AttemptTest do
  use Vestibule.ModelCase

  alias Vestibule.Attempt

  @valid_attrs %{code: "some content", language: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Attempt.changeset(%Attempt{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Attempt.changeset(%Attempt{}, @invalid_attrs)
    refute changeset.valid?
  end
end
