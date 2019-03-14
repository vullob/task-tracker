defmodule TaskTracker.Repo.Migrations.AddAdminUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :admin, :boolean, null: false, default: false
      add :manager_id, references(:users, on_delete: :nilify_all), null: true, default: nil
    end
    alter table(:tasks) do
      add :assigner_id, references(:users, on_delete: :nilify_all), null: true, default: nil
    end
  end
end
