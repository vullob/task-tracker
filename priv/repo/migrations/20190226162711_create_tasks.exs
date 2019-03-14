defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :string, null: false, default: ""
      add :completed, :boolean, default: false, null: false
      add :start_time, :utc_datetime, null: true, default: nil
      add :end_time, :utc_datetime, null: true, default: nil
      timestamps()
    end

  end
end
