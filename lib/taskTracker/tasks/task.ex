defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false, null: false
    field :desc, :string, null: true
    field :time, :integer, null: false, default: 0
    field :title, :string, null: false
    belongs_to :user, TaskTracker.Users.User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :desc, :completed, :time, :user_id])
    |> validate_required([:title, :desc, :completed, :time, :user_id])
  end
end
