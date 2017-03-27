defmodule Vestibule.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :team_id, references(:teams, on_delete: :nothing)
      add :is_admin, :boolean, default: false
    end
  end
end
