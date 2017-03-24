defmodule Vestibule.Repo.Migrations.CreateProblem do
  use Ecto.Migration

  def change do
    create table(:problems) do
      add :name, :string
      add :description, :string
      add :test_input, :string
      add :expected_output, :string
      add :time_limit, :integer
      add :memory_limit, :integer
      add :output_limit, :integer
      add :filesize_limit, :integer
      add :contest_id, references(:contests, on_delete: :nothing)

      timestamps()
    end
    create index(:problems, [:contest_id])

  end
end
