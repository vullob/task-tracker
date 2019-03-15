defmodule TaskTracker.Repo.Migrations.CreateTimeblocks do
  use Ecto.Migration

  def change do
    create table(:timeblocks) do
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :task_id, references(:tasks, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:timeblocks, [:user_id])
  end
end
