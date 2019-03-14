defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false, null: false
    field :description, :string, null: true, default: ""
    field :title, :string, null: false
    has_many :time_blocks, TaskTracker.TimeBlocks.TimeBlock, foreign_key: :task_id
    belongs_to :user, TaskTracker.Users.User
    belongs_to :assigner, TaskTracker.Users.User
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :completed, :description, :user_id, :assigner_id])
    |> validate_required([:title, :completed])
    |> foreign_key_constraint(:user_id, [message: "user not found"])
    |> foreign_key_constraint(:assigner_id, [message: "You must be logged in to assign a task"])
    |> validate_length(:title)
    |> validate_length(:description)
  end

  def validate_length(changeset, field) do
    validate_change(changeset, field, fn _, name ->
    cond do
      String.length(name) > 255 && field == :title -> [title: "input cannot be longer than 255 characters"]
      String.length(name) > 255 && field == :description -> [description: "input cannot be longer than 255 characters"]
      true -> []
    end
    end)
  end
end
