defmodule PheonixLive.Group do
  @moduledoc """
  The Company context.
  """

  import Ecto.Query, warn: false
  alias PheonixLive.Repo

  alias PheonixLive.Company.ReportGroup

  @doc """
  Returns the list of report_group.

  ## Examples

      iex> list_report_group()
      [%ReportGroup{}, ...]

  """
  def list_report_group do
    Repo.all(ReportGroup)
  end

  @doc """
  Gets a single report_group.

  Raises `Ecto.NoResultsError` if the ReportGroup does not exist.

  ## Examples

      iex> get_report_group!(123)
      %ReportGroup{}

      iex> get_report_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_report_group(id) do
    Repo.get(ReportGroup, id)
  end


  def get_specific_report_group(%{"user_id" => user_id, "group_name" => group_name}) do
    qry = from g in ReportGroup,
    where: g.user_id == ^user_id and g.group_name == ^group_name
    Repo.one(qry)
  end

  @doc """
  Creates a report_group.

  ## Examples

      iex> create_report_group(%{field: value})
      {:ok, %ReportGroup{}}

      iex> create_report_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_report_group(attrs \\ %{}) do
    %ReportGroup{}
    |> ReportGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a report_group.

  ## Examples

      iex> update_report_group(report_group, %{field: new_value})
      {:ok, %ReportGroup{}}

      iex> update_report_group(report_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_report_group(%ReportGroup{} = report_group, attrs) do
    report_group
    |> ReportGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a report_group.

  ## Examples

      iex> delete_report_group(report_group)
      {:ok, %ReportGroup{}}

      iex> delete_report_group(report_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_report_group(%ReportGroup{} = report_group) do
    Repo.delete(report_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking report_group changes.

  ## Examples

      iex> change_report_group(report_group)
      %Ecto.Changeset{data: %ReportGroup{}}

  """
  def change_report_group(%ReportGroup{} = report_group, attrs \\ %{}) do
    ReportGroup.changeset(report_group, attrs)
  end
end
