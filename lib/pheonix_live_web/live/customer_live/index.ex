defmodule PheonixLiveWeb.CustomerLive.Index do
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
    customer = Company.get_customer!(id)
    {:ok, _} = Company.delete_customer(customer)

    {:noreply, assign(socket, :customers, list_customers())}
  end

  def handle_event("enter_id",%{"key" => "Enter","value" => id}, socket) when id != "" do
    case Company.get_customer(id) do
    nil -> {:noreply, socket}
    customer -> new_customer = add_class(Enum.at(socket.assigns.customers,-1),customer)
      {:noreply, assign(socket, :customers, socket.assigns.customers ++ [new_customer])}
    end
  end

  def handle_event("enter_id",_, socket) do
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