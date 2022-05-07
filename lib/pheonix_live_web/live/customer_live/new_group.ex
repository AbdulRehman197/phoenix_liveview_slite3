defmodule PheonixLiveWeb.CustomerLive.NewGroup do
  use PheonixLiveWeb, :live_view

  alias PheonixLive.Group
  alias PheonixLiveWeb.UserAuth

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = UserAuth.fetch_current_user_by_token(user_token)
    {:ok,
    socket
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

  def handle_event("create_new_group", %{"value" => value}, socket) do
    case Group.get_by_name(value) do
      nil -> create_new_group(value, socket)
      _ -> {:noreply, put_flash(socket, :error, "Group already existed.")}
    end
  end

  def handle_event(_,_, socket) do
    {:noreply,socket}
  end

  defp create_new_group(group_name, socket) do
    case Group.create_report_group(%{"user_id" => socket.assigns.user.id, "group_name" => group_name}) do
      {:ok, _group} ->
        {:noreply,
        socket
        |> put_flash(:info, "Group created successfully.")
        |> push_redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
