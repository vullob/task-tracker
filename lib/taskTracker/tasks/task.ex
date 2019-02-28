defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false, null: false
    field :description, :string, null: true, default: ""
    field :minutes_spent, :integer, null: false, default: 0
    field :title, :string, null: false
    belongs_to :user, TaskTracker.Users.User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    change = task
    |> cast(attrs, [:title, :completed, :description, :user_id, :minutes_spent], [:desc])
    |> validate_required([:title, :completed, :minutes_spent])
    |> foreign_key_constraint(:user_id, [message: "user not found"])

    change = if (attrs["description"] && String.length(attrs["description"]) > 255) do
      change |> add_error(:description, "description must be less than 255 characters")
    else change end

    change = if (attrs["name"] && String.length(attrs["name"]) > 255) do
      change |> add_error(:name, "name must be less than 255 characters")
    else change end

    if(attrs["minutes_spent"] != nil && rem(elem(Integer.parse(attrs["minutes_spent"]), 0), 15) != 0) do
      change |> add_error(:minutes_spent, "minutes spent must be in 15 minute increments")
    else
      change
    end

  end
end
