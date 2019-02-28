defmodule TaskTracker.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo

  alias TaskTracker.Tasks.Task
  alias TaskTracker.Users

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  def get_task(id) do
    Repo.one from t in Task,
      where: t.id == ^id,
      preload: [:user]
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    id  = case attrs["user"]["email"] do
            nil -> nil
            "" -> nil
            _ -> Map.get(Users.get_user_by_email(attrs["user"]["email"]) || %{}, :id) || -1
          end
    attrs = Map.put(attrs, "start", DateTime.utc_now())
          |> Map.put("user_id", id)
    %Task{}
       |> Task.changeset(attrs)
       |> Repo.insert
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    id  = case attrs["user"]["email"] do
            nil -> nil
            "" -> nil
            _ -> Map.get(Users.get_user_by_email(attrs["user"]["email"]) || %{}, :id) || -20
          end
    attrs =  Map.put(attrs, "user_id", id) |> Map.delete(:user)

    # first we check to see if the user has changed, and update the
    # time started accordingly
    attrs = cond do
             Map.get(task, :user_id) != id -> Map.put(attrs, "start", DateTime.utc_now())
              true -> attrs
            end

    # then we check to see if the task has been completed, and update
    # the time ended accordingly (and set time started if not already there)
    now = DateTime.truncate(DateTime.utc_now(), :second)
    attrs |> IO.inspect
    attrs = cond do
              attrs["completed"] == "true" && Map.get(task, :start) == nil -> "DOING THIS ONE" |> IO.inspect; attrs |> Map.merge(%{"start" => now,"finish" => now});
              attrs["completed"] == "true" -> "SETTING FINISH TO NOW" |> IO.inspect; 
                                    attrs |> Map.merge(%{"finish" => now})
              attrs["completed"] == "false" -> "RESETTING FInIsh" |> IO.inspect;
                                      attrs |> Map.merge(%{"finish" => nil});
              true -> "BASE CASE" |> IO.inspect; task
            end
    task |> IO.inspect
    "updated task" |> IO.inspect
    task
         |> Task.changeset(attrs)
         |> Repo.update()
         |> IO.inspect
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end
end
