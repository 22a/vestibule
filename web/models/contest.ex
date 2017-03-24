defmodule Vestibule.Contest do
  use Vestibule.Web, :model

  schema "contests" do
    field :name, :string
    field :description, :string
    field :activate_time, Ecto.DateTime
    field :start_time, Ecto.DateTime
    field :freeze_time, Ecto.DateTime
    field :end_time, Ecto.DateTime
    field :thaw_time, Ecto.DateTime
    field :deactivate_time, Ecto.DateTime
    has_many :problems, Vestibule.Problem, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :activate_time, :start_time, :freeze_time, :end_time, :thaw_time, :deactivate_time])
    |> validate_required([:name, :description, :activate_time, :start_time, :freeze_time, :end_time, :thaw_time, :deactivate_time])
  end
end
