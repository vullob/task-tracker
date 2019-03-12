defmodule TaskTracker.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :admin, :boolean
    belongs_to :manager, TaskTracker.Users.User
    has_many :tasks, TaskTracker.Tasks.Task
    has_many :underlings, TaskTracker.Users.User, foreign_key: :manager_id
    has_many :tasks_assigned, TaskTracker.Tasks.Task
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :admin, :manager_id])
    |> validate_required([:email, :admin])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> foreign_key_constraint(:manager_id, [message: "user not found"])
  end
end
