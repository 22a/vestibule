defmodule Vestibule.Repo.Migrations.CreateResult do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :pass, :string
      add :output, :string
      add :attempt_id, references(:attempts, on_delete: :nothing)

      timestamps()
    end
    create index(:results, [:attempt_id])

  end
end
