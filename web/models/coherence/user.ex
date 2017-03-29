defmodule Vestibule.User do
  use Vestibule.Web, :model
  use Coherence.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    field :is_admin, :boolean, default: false
    belongs_to :team, Vestibule.Team
    has_many :attempts, Vestibule.Attempt, on_delete: :delete_all
    coherence_schema()

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email, :team_id, :is_admin] ++ coherence_fields())
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end
end
