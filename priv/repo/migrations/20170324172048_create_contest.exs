defmodule Vestibule.Repo.Migrations.CreateContest do
  use Ecto.Migration

  def change do
    create table(:contests) do
      add :name, :string
      add :description, :string
      add :activate_time, :datetime
      add :start_time, :datetime
      add :freeze_time, :datetime
      add :end_time, :datetime
      add :thaw_time, :datetime
      add :deactivate_time, :datetime

      timestamps()
    end

  end
end
