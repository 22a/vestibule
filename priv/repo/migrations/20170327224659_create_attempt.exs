defmodule Vestibule.Repo.Migrations.CreateAttempt do
  use Ecto.Migration

  def change do
    create table(:attempts) do
      add :language, :string
      add :code, :string
      add :team_id, references(:teams, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :problem_id, references(:problems, on_delete: :nothing)

      timestamps()
    end
    create index(:attempts, [:team_id])
    create index(:attempts, [:user_id])
    create index(:attempts, [:problem_id])

  end
end
