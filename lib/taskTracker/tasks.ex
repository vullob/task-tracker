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
    Repo.all(Task) |> Repo.preload(:user) |> Repo.preload(:time_blocks)
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
      preload: [:user, :time_blocks]
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
    assignee = get_assignee_from_input(attrs)
    attrs = if assignee != nil do
      update_assignment_in_attrs(attrs, assignee, assigner)
    else attrs end |> IO.inspect
    %Task{}
       |> Task.changeset(attrs)
       |> validate_underling_assignment(assigner, assignee)
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
    task
         |> Task.changeset(attrs)
         |> Repo.update()
  end

  def assign_task(%Task{} = task, attrs, %{} = assigner) do
    assignee = get_assignee_from_input(attrs)
    attrs = if assignee != nil do
      update_assignment_in_attrs(attrs, assignee, assigner)
    else attrs end
    time_block_errors = attrs["time_blocks"]
          |> Map.values()
          |> Enum.map(fn tb -> TaskTracker.TimeBlocks.update_time_block(TaskTracker.TimeBlocks.get_time_block!(tb["id"]), tb) end)
          |> Enum.flat_map(fn cs -> Map.get(elem(cs, 1), :errors) || [] end)
          |> Enum.uniq
    task =  task
         |> Task.changeset(attrs)
         |> validate_underling_assignment(assigner, assignee)
    Enum.reduce(time_block_errors, task, fn error, acc -> Ecto.Changeset.add_error(acc, elem(error, 0), elem(elem(error, 1) , 0)) end)
     |> Repo.update |> IO.inspect
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

  def get_assignee_from_input(attrs) do
     case attrs["user"]["email"] do
            nil -> nil
            "" -> nil
            _ -> Users.get_user_by_email(attrs["user"]["email"]) || %{}
          end
  end

  def update_assignment_in_attrs(attrs, assignee, assigner) do
      Map.put(attrs, "user_id", Map.get(assignee, :id) || -20)
            |> Map.put("assigner_id", Map.get(assigner, :id) || -20)
  end

  def validate_underling_assignment(changeset, assigner, assignee) do
    cond do
     assigner.id == nil || assignee == nil || assignee == %{} || assignee.manager_id == assigner.id -> changeset
     true -> Ecto.Changeset.add_error(changeset, :user_id, "user must be an underling")
    end
  end

end
