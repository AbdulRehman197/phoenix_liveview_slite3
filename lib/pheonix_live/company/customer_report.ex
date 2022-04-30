defmodule PheonixLive.Company.CustomerReport do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers_report" do
    field :customer_id, :integer
    field :customer_detail, :string
    field :report1, :string
    field :report2, :string
    field :report3, :string
    field :report4, :string
    field :report5, :string
    field :group_ref, :string

    timestamps()
  end

  @doc false
  def changeset(customer_report, attrs) do
    customer_report
    |> cast(attrs, [:customer_id, :customer_detail, :report1, :report2, :report3, :report4, :report5, :group_ref])
    # |> validate_required([:customer_id, :customer_detail, :report1, :report2, :report3, :report4, :report5])
  end
end
