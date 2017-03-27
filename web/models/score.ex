defmodule Vestibule.Score do
  use Vestibule.Web, :model

  schema "scores" do
    belongs_to :team, Vestibule.Team
    belongs_to :contest, Vestibule.Contest

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
