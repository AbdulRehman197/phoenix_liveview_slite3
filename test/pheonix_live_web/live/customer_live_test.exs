defmodule PheonixLiveWeb.CustomerLiveTest do
  use PheonixLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import PheonixLive.CompanyFixtures

  @create_attrs %{fullname: "some fullname", info1: "some info1", info2: "some info2", info3: "some info3", name: "some name", phone_address: "some phone_address"}
  @update_attrs %{fullname: "some updated fullname", info1: "some updated info1", info2: "some updated info2", info3: "some updated info3", name: "some updated name", phone_address: "some updated phone_address"}
  @invalid_attrs %{fullname: nil, info1: nil, info2: nil, info3: nil, name: nil, phone_address: nil}

  defp create_customer(_) do
    customer = customer_fixture()
    %{customer: customer}
  end

  describe "Index" do
    setup [:create_customer]

    test "lists all customers", %{conn: conn, customer: customer} do
      {:ok, _index_live, html} = live(conn, Routes.customer_index_path(conn, :index))

      assert html =~ "Listing Customers"
      assert html =~ customer.fullname
    end

    test "saves new customer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.customer_index_path(conn, :index))

      assert index_live |> element("a", "New Customer") |> render_click() =~
               "New Customer"

      assert_patch(index_live, Routes.customer_index_path(conn, :new))

      assert index_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#customer-form", customer: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.customer_index_path(conn, :index))

      assert html =~ "Customer created successfully"
      assert html =~ "some fullname"
    end

    test "updates customer in listing", %{conn: conn, customer: customer} do
      {:ok, index_live, _html} = live(conn, Routes.customer_index_path(conn, :index))

      assert index_live |> element("#customer-#{customer.id} a", "Edit") |> render_click() =~
               "Edit Customer"

      assert_patch(index_live, Routes.customer_index_path(conn, :edit, customer))

      assert index_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#customer-form", customer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.customer_index_path(conn, :index))

      assert html =~ "Customer updated successfully"
      assert html =~ "some updated fullname"
    end

    test "deletes customer in listing", %{conn: conn, customer: customer} do
      {:ok, index_live, _html} = live(conn, Routes.customer_index_path(conn, :index))

      assert index_live |> element("#customer-#{customer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#customer-#{customer.id}")
    end
  end

  describe "Show" do
    setup [:create_customer]

    test "displays customer", %{conn: conn, customer: customer} do
      {:ok, _show_live, html} = live(conn, Routes.customer_show_path(conn, :show, customer))

      assert html =~ "Show Customer"
      assert html =~ customer.fullname
    end

    test "updates customer within modal", %{conn: conn, customer: customer} do
      {:ok, show_live, _html} = live(conn, Routes.customer_show_path(conn, :show, customer))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Customer"

      assert_patch(show_live, Routes.customer_show_path(conn, :edit, customer))

      assert show_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#customer-form", customer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.customer_show_path(conn, :show, customer))

      assert html =~ "Customer updated successfully"
      assert html =~ "some updated fullname"
    end
  end
end
