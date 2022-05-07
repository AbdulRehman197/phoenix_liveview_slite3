defmodule PheonixLiveWeb.CustomerLive.ManageGroup do
  use PheonixLiveWeb, :live_view

  alias PheonixLive.Group
  alias PheonixLiveWeb.UserAuth

  @impl true
  def mount(%{"group" => group}, %{"user_token" => user_token}, socket) do
    user = UserAuth.fetch_current_user_by_token(user_token)
    {:ok,
    socket
    |> assign(:user, user)
    |> assign(:current_path, group)
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

  def handle_event("add_member_in_group", %{"value" => value}, socket) do
    case Group.get_specific_report_group(%{"user_id" => socket.assigns.user.id, "group_name" => socket.assigns.current_path}) do
      nil -> {:noreply, put_flash(socket, :error, "You are not member of this group.")}
      group -> check_user_and_add(group.group_name,value,socket)
    end
  end

  def handle_event(_,_, socket) do
    {:noreply,socket}
  end

  defp check_user_and_add(group_name, user_email, socket) do
    case UserAuth.fetch_user_by_email(user_email) do
      nil -> {:noreply, put_flash(socket, :error, "User you are trying to add is not existed.")}
      user -> add_user(group_name, user.id, socket)
    end
  end

  defp add_user(group_name, user_id, socket) do
    case Group.get_specific_report_group(%{"user_id" => user_id, "group_name" => group_name}) do
      nil -> add_in_group(group_name, user_id, socket)
      _ -> {:noreply,
      socket
      |> put_flash(:error, "User already member of this group.")
      |> push_redirect(to: "/#{socket.assigns.current_path}/add")}
    end
  end

  defp add_in_group(group_name, user_id, socket) do
    case Group.create_report_group(%{"user_id" => user_id, "group_name" => group_name}) do
      {:ok, _group} ->
        {:noreply,
        socket
        |> put_flash(:info, "User added successfully.")
        |> push_redirect(to: "/#{socket.assigns.current_path}/add")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
