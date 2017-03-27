defmodule Vestibule.Result do
  use Vestibule.Web, :model

  schema "results" do
    field :pass, :string
    field :output, :string
    belongs_to :attempt, Vestibule.Attempt

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:pass, :output])
    |> validate_required([:pass, :output])
  end
end
