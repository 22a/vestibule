defmodule Vestibule.Team do
  use Vestibule.Web, :model

  schema "teams" do
    field :name, :string
    field :affiliation, :string
    has_many :users, Vestibule.User, on_delete: :nilify_all
    has_many :attempts, Vestibule.Attempt

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :affiliation])
    |> validate_required([:name, :affiliation])
  end
end
