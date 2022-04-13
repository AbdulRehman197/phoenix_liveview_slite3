defmodule PheonixLive.CompanyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PheonixLive.Company` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        fullname: "some fullname",
        info1: "some info1",
        info2: "some info2",
        info3: "some info3",
        name: "some name",
        phone_address: "some phone_address"
      })
      |> PheonixLive.Company.create_customer()

    customer
  end
end
