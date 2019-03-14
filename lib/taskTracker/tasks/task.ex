defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false, null: false
    field :description, :string, null: true, default: ""
    field :start_time, :utc_datetime, null: true, default: nil
    field :end_time, :utc_datetime, null: true, default: nil
    field :title, :string, null: false
    belongs_to :user, TaskTracker.Users.User
    belongs_to :assigner, TaskTracker.Users.User
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :completed, :description, :user_id, :start_time, :end_time, :assigner_id])
    |> validate_required([:title, :completed])
    |> foreign_key_constraint(:user_id, [message: "user not found"])
    |> foreign_key_constraint(:assigner_id, [message: "You must be logged in to assign a task"])
    |> validate_length(:title)
    |> validate_length(:description)
    |> validate_ends_after_start(:start_time, :end_time) |> IO.inspect
  end

  def validate_ends_after_start(changeset, startField, finishField) do
    changeset |> IO.inspect
    start = Ecto.Changeset.get_field(changeset, startField) |> IO.inspect
    finish = Ecto.Changeset.get_field(changeset, finishField) |> IO.inspect
    cond do
      finish == nil -> changeset
      start == nil ->
          changeset
            |> Ecto.Changeset.add_error(finishField, "cannot finish a task before it's started")
      DateTime.compare(start, finish) == :gt ->
          changeset
              |> Ecto.Changeset.add_error(startField, "end time must be after start")
              |> Ecto.Changeset.add_error(finishField, "end time must be after start")
      true -> changeset
    end
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
