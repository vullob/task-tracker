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
    attrs = attrs
          |> Map.put("user_id", id)
    %Task{}
       |> Task.changeset(attrs)
       |> Repo.insert
  end
  def new_task(attrs \\ %{}, %{} = assigner) do
    assignee = case attrs["user"]["email"] do
            nil -> nil
            "" -> nil
            _ -> Users.get_user_by_email(attrs["user"]["email"]) || %{}
          end
    attrs = attrs
          |> Map.put("user_id", Map.get(assignee, :id) || -1)
          |> Map.put("assigner_id", Map.get(assigner, :id) || -2)
     if assigner.id == nil || assignee == nil || assignee == %{} || assignee.manager_id == assigner.id do
      %Task{}
         |> Task.changeset(attrs)
         |> Repo.insert
    else
     Task.changeset(%Task{}, attrs) |> Ecto.Changeset.add_error(:user_id, "user must be an underling") |> Ecto.Changeset.apply_action(:update)
    end
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
    task
         |> Task.changeset(attrs)
         |> Repo.update()
  end

  def assign_task(%Task{} = task, attrs, %{} = assigner) do
    assignee  = case attrs["user"]["email"] do
            nil -> nil
            "" -> nil
            _ -> Users.get_user_by_email(attrs["user"]["email"]) || %{}
          end

    attrs =  Map.put(attrs, "user_id", Map.get(assignee, :id) || -20)
            |> Map.put("assigner_id", Map.get(assigner, :id) || -20)
            |> Map.delete(:user)
    if assigner.id == nil || assignee == nil || assignee == %{} || assignee.manager_id == assigner.id do
        task
         |> Task.changeset(attrs)
         |> Repo.update()
    else
     Task.changeset(task, attrs) |> Ecto.Changeset.add_error(:user_id, "user must be an underling") |> Ecto.Changeset.apply_action(:update)
    end
  end

  def assign_task(%Task{} = task, attrs, nil) do
    attrs = Map.put(attrs, "assigner_id", -20)
    task
      |> Task.changeset(attrs)
      |> Repo.update()
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
