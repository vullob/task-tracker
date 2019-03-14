defmodule TaskTracker.TimeBlocks.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset


  schema "timeblocks" do
    field :end_time, :utc_datetime, null: true
    field :start_time, :utc_datetime, null: false
    belongs_to :user, TaskTracker.Users.User
    belongs_to :task, TaskTracker.Tasks.Task
    timestamps()
  end

  @doc false
  def changeset(time_block, attrs) do
    time_block
    |> cast(attrs, [:start_time, :end_time, :user_id, :task_id])
    |> validate_required([:start_time])
    |> foreign_key_constraint(:user_id, [message: "user not found"])
    |> foreign_key_constraint(:task_id, [message: "task not found"])
    |> validate_ends_after_start(:start_time, :end_time)
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

end
