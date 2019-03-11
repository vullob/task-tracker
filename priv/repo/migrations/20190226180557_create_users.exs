defmodule TaskTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
     timestamps()
    end

    create unique_index(:users, [:email])

    alter table(:tasks) do
      add :user_id, references(:users, on_delete: :delete_all), null: true, default: nil
    end

  end
end
