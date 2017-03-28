defmodule Vestibule.Attempt do
  use Vestibule.Web, :model

  schema "attempts" do
    field :language, :string
    field :code, :string
    belongs_to :team, Vestibule.Team
    belongs_to :user, Vestibule.User
    belongs_to :problem, Vestibule.Problem
    has_one :result, Vestibule.Result, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:language, :code, :problem_id, :user_id, :team_id])
    |> validate_required([:language, :code, :problem_id])
  end
end
