defmodule TaskTracker.TimeBlocks do
  @moduledoc """
  The TimeBlocks context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo

  alias TaskTracker.TimeBlocks.TimeBlock

  @doc """
  Returns the list of timeblocks.

  ## Examples

      iex> list_timeblocks()
      [%TimeBlock{}, ...]

  """
  def list_timeblocks do
    Repo.all(TimeBlock)
  end

  @doc """
  Gets a single time_block.

  Raises `Ecto.NoResultsError` if the Time block does not exist.

  ## Examples

      iex> get_time_block!(123)
      %TimeBlock{}

      iex> get_time_block!(456)
      ** (Ecto.NoResultsError)

  """
  def get_time_block!(id), do: Repo.get!(TimeBlock, id)
  def get_time_block(id), do: Repo.get!(TimeBlock, id) |> preload(:user)


  @doc """
  Creates a time_block.

  ## Examples

      iex> create_time_block(%{field: value})
      {:ok, %TimeBlock{}}

      iex> create_time_block(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_time_block(attrs \\ %{}) do
    now = DateTime.utc_now
          |> Timex.to_datetime("America/New_York")
   attrs = Map.put(attrs, "start_time", now)
            |> Map.put("end_time", nil)
            |> IO.inspect
    %TimeBlock{}
    |> TimeBlock.changeset(attrs)
    |> Repo.insert()
    |> IO.inspect
  end

  @doc """
  Updates a time_block.

  ## Examples

      iex> update_time_block(time_block, %{field: new_value})
      {:ok, %TimeBlock{}}

      iex> update_time_block(time_block, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_time_block(%TimeBlock{} = time_block, attrs) do
    attrs = if(attrs["finished"]) do
      now = DateTime.utc_now
          |> Timex.to_datetime("America/New_York")

      attrs |> Map.put("end_time", now) |> validate_datetime("start_time") |> Map.delete("finished")
    else
    validate_datetime(attrs, "start_time")
          |> validate_datetime("end_time")
          end

    time_block
    |> TimeBlock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TimeBlock.

  ## Examples

      iex> delete_time_block(time_block)
      {:ok, %TimeBlock{}}

      iex> delete_time_block(time_block)
      {:error, %Ecto.Changeset{}}

  """
  def delete_time_block(%TimeBlock{} = time_block) do
    Repo.delete(time_block)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking time_block changes.

  ## Examples

      iex> change_time_block(time_block)
      %Ecto.Changeset{source: %TimeBlock{}}

  """
  def change_time_block(%TimeBlock{} = time_block) do
    TimeBlock.changeset(time_block, %{})
  end

  def validate_datetime(attrs, field) do
    dateTime = attrs[field]
    hour = dateTime["hour"]
    minute = dateTime["minute"]
    day = dateTime["day"]
    month = dateTime["month"]
    year = dateTime["year"]
    tody = DateTime.utc_now() |> Timex.to_datetime("America/New_York");
    cond do
      hour == "" && minute == "" && day == "" && month == "" && year == "" -> attrs
      year == "" && month == "" && day == "" ->
        newtime = attrs[field]
              |> Map.put("day", tody.day)
              |> Map.put("month", tody.month)
              |> Map.put("year" , tody.year);

        Map.put(attrs, field, newtime)
      hour == "" && minute == ""->
          newTime = attrs[field]
                  |> Map.put("minute", 0)
                  |> Map.put("hour", 0)

          Map.put(attrs, field, newTime)
      true -> attrs
    end
  end

end
