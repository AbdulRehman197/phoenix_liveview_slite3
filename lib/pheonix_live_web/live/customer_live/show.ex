defmodule PheonixLiveWeb.CustomerLive.Show do
  use PheonixLiveWeb, :live_view

  alias PheonixLive.Company

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:customer, Company.get_customer!(id))}
  end

  defp page_title(:show), do: "Show Customer"
  defp page_title(:edit), do: "Edit Customer"
end
