defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :string, null: false, default: ""
      add :completed, :boolean, default: false, null: false
      add :minutes_spent, :integer, null: false, default: 0
      timestamps()
    end

  end
end
