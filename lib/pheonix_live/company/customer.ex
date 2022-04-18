defmodule PheonixLive.Company.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :fullname, :string
    field :info1, :string
    field :info2, :string
    field :info3, :string
    field :name, :string
    field :phone_address, :string

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :fullname, :phone_address, :info1, :info2, :info3])
    # |> validate_required([:name, :fullname, :phone_address, :info1, :info2, :info3])
  end
end
