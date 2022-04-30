defmodule PheonixLive.CompanyCustomerReport do
  @moduledoc """
  The Company context.
  """

  import Ecto.Query, warn: false
  alias PheonixLive.Repo

  alias PheonixLive.Company.CustomerReport

  @doc """
  Returns the list of customer_report.

  ## Examples

      iex> list_customer_report()
      [%CustomerReport{}, ...]

  """
  def list_customer_report do
    Repo.all(CustomerReport)
  end

  def list_specific_customer_report(group_name) do
    qry = from r in CustomerReport,
    where: r.group_ref == ^group_name
    Repo.all(qry)
  end

  @doc """
  Gets a single customer_report.

  Raises `Ecto.NoResultsError` if the CustomerReport does not exist.

  ## Examples

      iex> get_customer_report!(123)
      %CustomerReport{}

      iex> get_customer_report!(456)
      ** (Ecto.NoResultsError)

  """
  def get_customer_report(id) do
    Repo.get(CustomerReport, id)
  end

  @doc """
  Creates a customer_report.

  ## Examples

      iex> create_customer_report(%{field: value})
      {:ok, %CustomerReport{}}

      iex> create_customer_report(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer_report(attrs \\ %{}) do
    %CustomerReport{}
    |> CustomerReport.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a customer_report.

  ## Examples

      iex> update_customer_report(customer_report, %{field: new_value})
      {:ok, %CustomerReport{}}

      iex> update_customer_report(customer_report, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_customer_report(%CustomerReport{} = customer_report, attrs) do
    customer_report
    |> CustomerReport.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a customer_report.

  ## Examples

      iex> delete_customer_report(customer_report)
      {:ok, %CustomerReport{}}

      iex> delete_customer_report(customer_report)
      {:error, %Ecto.Changeset{}}

  """
  def delete_customer_report(%CustomerReport{} = customer_report) do
    Repo.delete(customer_report)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking customer_report changes.

  ## Examples

      iex> change_customer_report(customer_report)
      %Ecto.Changeset{data: %CustomerReport{}}

  """
  def change_customer_report(%CustomerReport{} = customer_report, attrs \\ %{}) do
    CustomerReport.changeset(customer_report, attrs)
  end
end
