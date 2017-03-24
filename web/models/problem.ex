defmodule Vestibule.Problem do
  use Vestibule.Web, :model

  schema "problems" do
    field :name, :string
    field :description, :string
    field :test_input, :string
    field :expected_output, :string
    field :time_limit, :integer
    field :memory_limit, :integer
    field :output_limit, :integer
    field :filesize_limit, :integer
    belongs_to :contest, Vestibule.Contest

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :test_input, :expected_output, :time_limit, :memory_limit, :output_limit, :filesize_limit, :contest_id])
    |> validate_required([:name, :description, :test_input, :expected_output, :time_limit, :memory_limit, :output_limit, :filesize_limit, :contest_id])
  end
end
