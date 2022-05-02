defmodule PheonixLiveWeb.CustomerLive.Groups do
  use PheonixLiveWeb, :live_view

  alias PheonixLive.Group
  alias PheonixLiveWeb.UserAuth

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = UserAuth.fetch_current_user_by_token(user_token)
    list = get_group_list(user.id)
    {:ok,
    socket
    |> assign(:groups, list)
    |> assign(:user, user)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing CustomerReport")
    |> assign(:customer_report, nil)
  end

  def handle_event("redirect_" <> group, _params, socket) do
    {:noreply,
    socket
    |> push_redirect(to: "/report/#{group}")}
  end

  # defp save_customer_report(socket, :new, customer_report_params) do
  #   case CompanyCustomerReport.create_customer_report(customer_report_params) do
  #     {:ok, _customer_report} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Customer Report created successfully")
  #        |> push_redirect(to: "/")}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, changeset: changeset)}
  #   end
  # end

  # def handle_event("enter_id",%{"key" => "Enter","value" => id}, socket) when id != "" do
  #   case Group.get_specific_report_group(%{"user_id" => socket.assigns.user.id, "group_name" => socket.assigns.current_path}) do
  #     nil -> add_in_group_and_save_report(socket.assigns.user.id, socket.assigns.current_path, id, socket)
  #     _ -> save_new_report(id, socket)
  #   end
  # end

  def handle_event(_,_, socket) do
    {:noreply,socket}
  end

  defp get_group_list(user_id) do
    Group.list_report_group(user_id)
  end

end
