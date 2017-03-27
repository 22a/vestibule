defmodule Vestibule.Repo.Migrations.CreateTeam do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :affiliation, :string

      timestamps()
    end

  end
end
