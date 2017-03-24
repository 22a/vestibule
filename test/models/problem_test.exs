defmodule Vestibule.ProblemTest do
  use Vestibule.ModelCase

  alias Vestibule.Problem

  @valid_attrs %{description: "some content", expected_output: "some content", filesize_limit: 42, memory_limit: 42, name: "some content", output_limit: 42, test_input: "some content", time_limit: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Problem.changeset(%Problem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Problem.changeset(%Problem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
