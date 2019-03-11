defmodule TaskTracker.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :admin, :boolean
    belongs_to :manager, TaskTracker.Users.User
    has_many :tasks, TaskTracker.Tasks.Task
    has_many :underlings, TaskTracker.Users.User, foreign_key: :manager_id
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :admin])
    |> validate_required([:email, :admin])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
