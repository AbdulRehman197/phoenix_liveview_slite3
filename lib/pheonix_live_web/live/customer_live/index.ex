defmodule PheonixLiveWeb.CustomerLive.Index do
  use PheonixLiveWeb, :live_view

  alias PheonixLive.Company
  alias PheonixLive.CompanyCustomerReport
  alias PheonixLive.Company.CustomerReport
  alias PheonixLive.Group
  alias PheonixLiveWeb.UserAuth

  @impl true
  def mount(%{"group" => group}, %{"user_token" => user_token}, socket) do
    user = UserAuth.fetch_current_user_by_token(user_token)
    case get_report_list(%{"id" => user.id, "group" => group}, socket) do
      nil -> {:ok, push_redirect(socket, to: "/")}
      list -> {:ok,
      socket
      |> assign(:customer_reports, list)
      |> assign(:user, user)
      |> assign(:current_path, group)
      }
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit CustomerReport")
    |> assign(:customer_report, CompanyCustomerReport.get_customer_report(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New CustomerReport")
    |> assign(:customer_report, %CustomerReport{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing CustomerReport")
    |> assign(:customer_report, nil)
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   customer_report = CompanyCustomerReport.get_customer_report(id)
  #   {:ok, _} = CompanyCustomerReport.delete_customer_report(customer_report)

  #   {:noreply, assign(socket, :customer_reports, list_customer_report())}
  # end

  def handle_event("reirect_member_page", _param, socket) do
    {:noreply, push_redirect(socket, to: "/#{socket.assigns.current_path}/add")}
  end

  defp save_customer_report(socket, :new, customer_report_params) do
    case CompanyCustomerReport.create_customer_report(customer_report_params) do
      {:ok, _customer_report} ->
        {:noreply,
         socket
         |> put_flash(:info, "Customer Report created successfully")
         |> push_redirect(to: "/report/#{socket.assigns.current_path}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_customer_report(socket, :edit, customer_report, customer_report_params) do
    case CompanyCustomerReport.update_customer_report(customer_report, customer_report_params) do
      {:ok, customer_report} ->
        customer_report
        #  |> push_redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("enter_id",%{"key" => "Enter","value" => id}, socket) when id != "" do
    case Group.get_specific_report_group(%{"user_id" => socket.assigns.user.id, "group_name" => socket.assigns.current_path}) do
      nil -> {:noreply,
      socket
      |> put_flash(:error, "You are not Member of this group.")}
      _ -> save_new_report(id, socket)
    end
  end

  def handle_event("update_report",%{"value" => value, "field" => field, "id" => id}, socket) when value != "" do
    customer_report = CompanyCustomerReport.get_customer_report(id)
    customer_report = save_customer_report(socket, :edit, customer_report, %{field => value})
    updated_reports = Enum.map(socket.assigns.customer_reports, fn report ->
      if report.id == customer_report.id do
        customer_report
        |> Map.put(:class, report.class)
      else
        report
      end
    end)
    {:noreply, assign(socket, :customer_reports, updated_reports)}
  end

  def handle_event(_,_, socket) do
    {:noreply,socket}
  end

  defp add_class(last_item,new_item) when last_item.customer_id === new_item.customer_id do
    Map.put(new_item, :class, last_item.class)
  end

  defp add_class(last_item,new_item) do
    if last_item.class === "light_row" do
      Map.put(new_item, :class, "dark_row")
    else
      Map.put(new_item, :class, "light_row")
    end
  end

  defp list_customer_report(group_name) do
    CompanyCustomerReport.list_specific_customer_report(group_name)
  end

  defp add_class_list([head | tail],new_list) do
    new_item = add_class(Enum.at(new_list,-1),head)
    add_class_list(tail,new_list ++ [new_item])
  end

  defp add_class_list([],new_list) do
    new_list
  end

  defp get_report_list(%{"id" => user_id, "group" => group}, socket) do
    case Group.get_specific_report_group(%{"user_id" => user_id, "group_name" => group}) do
      nil -> nil
      group -> list_with_class(group.group_name)
    end
  end

  defp list_with_class(group_name) do
    case list_customer_report(group_name) do
      [] -> []
      [head | customer_report_list] -> add_class_list(customer_report_list, [Map.put(head,:class,"light_row")])
    end
  end

  defp save_new_report(id, socket) do
    case Company.get_customer(id) do
      nil -> {:noreply, socket}
      customer -> save_customer_report(socket, :new, %{"customer_id" => customer.id, "customer_detail" => "#{customer.name} #{customer.fullname} #{customer.phone_address} #{customer.info1} #{customer.info2} #{customer.info3}", "report1" => "", "report2" => "", "report3" => "", "report4" => "", "report5" => "", "group_ref" => socket.assigns.current_path})
    end
  end

  defp add_in_group_and_save_report( user_id, group, customer_id, socket) do
    case Group.create_report_group(%{"user_id" => user_id, "group_name" => group}) do
      {:ok, _struct} -> save_new_report(customer_id, socket)
      {:error, changeset} -> nil
    end
  end

end
