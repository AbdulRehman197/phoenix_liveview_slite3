defmodule PheonixLive.CompanyTest do
  use PheonixLive.DataCase

  alias PheonixLive.Company

  describe "customers" do
    alias PheonixLive.Company.Customer

    import PheonixLive.CompanyFixtures

    @invalid_attrs %{fullname: nil, info1: nil, info2: nil, info3: nil, name: nil, phone_address: nil}

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Company.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Company.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      valid_attrs = %{fullname: "some fullname", info1: "some info1", info2: "some info2", info3: "some info3", name: "some name", phone_address: "some phone_address"}

      assert {:ok, %Customer{} = customer} = Company.create_customer(valid_attrs)
      assert customer.fullname == "some fullname"
      assert customer.info1 == "some info1"
      assert customer.info2 == "some info2"
      assert customer.info3 == "some info3"
      assert customer.name == "some name"
      assert customer.phone_address == "some phone_address"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Company.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      update_attrs = %{fullname: "some updated fullname", info1: "some updated info1", info2: "some updated info2", info3: "some updated info3", name: "some updated name", phone_address: "some updated phone_address"}

      assert {:ok, %Customer{} = customer} = Company.update_customer(customer, update_attrs)
      assert customer.fullname == "some updated fullname"
      assert customer.info1 == "some updated info1"
      assert customer.info2 == "some updated info2"
      assert customer.info3 == "some updated info3"
      assert customer.name == "some updated name"
      assert customer.phone_address == "some updated phone_address"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Company.update_customer(customer, @invalid_attrs)
      assert customer == Company.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Company.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Company.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Company.change_customer(customer)
    end
  end
end
