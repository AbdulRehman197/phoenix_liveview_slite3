defmodule PheonixLiveWeb.CustomerLive.Customers do
  use PheonixLiveWeb, :live_view

  alias PheonixLive.Company
  alias PheonixLive.Company.Customer

  @impl true
  def mount(_params, _session, socket) do
    customers_list = list_customers()
    list = Enum.zip([1..length(customers_list),customers_list])
    |> Enum.map(fn {index, customer} ->
      if rem(index, 2) === 0 do
        Map.put(customer, :class, "light_row")
      else
        Map.put(customer, :class, "dark_row")
      end
    end)
    {:ok, assign(socket, :customers, list)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Customer")
    |> assign(:customer, Company.get_customer!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Customer")
    |> assign(:customer, %Customer{})
  end


  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Customers")
    |> assign(:customer, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    customer = Company.get_customer(id)
    {:ok, _} = Company.delete_customer(customer)

    {:noreply, assign(socket, :customers, list_customers())}
  end

  defp save_customer(socket, :new, customer_params) do
    case Company.create_customer(customer_params) do
      {:ok, _customer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Customer created successfully")
         |> push_redirect(to: "/customers")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_customer(socket, :edit, customer, customer_params) do
    case Company.update_customer(customer, customer_params) do
      {:ok, _customer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Customer updated successfully")
         |> push_redirect(to: "/customers")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def input_handler(customer_params,socket) do
    save_customer(socket, :new, customer_params)
  end

  def handle_event("new_" <> field,%{"key" => "Enter","value" => value}, socket) when value != "" do
    params = Map.replace(%{
      "fullname" => "",
      "info1" => "",
      "info2" => "",
      "info3" => "",
      "name" => "",
      "phone_address" => ""
    },field,value)
    input_handler(params,socket)
  end

  def handle_event("update:" <> params,%{"value" => value}, socket) when value != "" do
    [field,id] = String.split(params,":")
    customer = Company.get_customer(id)
    save_customer(socket, :edit, customer, %{field => value})
  end

  def handle_event(_,_, socket) do
    {:noreply,socket}
  end

  defp add_class(last_item,new_item) when last_item.id === new_item.id do
    Map.put(new_item, :class, last_item.class)
  end

  defp add_class(last_item,new_item) do
    if last_item.class === "light_row" do
      Map.put(new_item, :class, "dark_row")
    else
      Map.put(new_item, :class, "light_row")
    end
  end

  defp list_customers do
    Company.list_customers()
  end
end
