defmodule Vestibule.Repo.Migrations.CreateScore do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :team_id, references(:teams, on_delete: :nothing)
      add :contest_id, references(:contests, on_delete: :nothing)

      timestamps()
    end
    create index(:scores, [:team_id])
    create index(:scores, [:contest_id])

  end
end
