defmodule Vestibule.ContestTest do
  use Vestibule.ModelCase

  alias Vestibule.Contest

  @valid_attrs %{activate_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, deactivate_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, description: "some content", end_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, freeze_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, name: "some content", start_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, thaw_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Contest.changeset(%Contest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Contest.changeset(%Contest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
