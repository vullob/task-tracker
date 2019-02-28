defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false, null: false
    field :desc, :string, null: true, default: ""
    field :time, :integer, null: false, default: 0
    field :title, :string, null: false
    belongs_to :user, TaskTracker.Users.User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :completed, :desc, :user_id, :time], [:desc])
    |> validate_required([:title, :completed])
    |> foreign_key_constraint(:user_id, [message: "not found"])
  end
end
