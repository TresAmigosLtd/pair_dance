defmodule PairDanceWeb.ListComponent do
  use PairDanceWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="bg-gray-100 py-4 rounded-lg">
      <div class="space-y-5 mx-auto max-w-7xl px-4 space-y-4">
        <.header>
          <%= @list_name %>
        </.header>
        <div id={"#{@id}-items"} phx-hook="Sortable" data-list_id={@id}>
          <div
            :for={item <- @list}
            id={"#{@id}-#{item.id}"}
            class=""
            data-id={item.id}
          >
            <div class="flex">
              <button type="button" class="w-24">
                <span><%= item.status %></span>
              </button>
              <div class="flex-auto block text-sm leading-6 text-zinc-900">
                <%= item.name %>
              </div>
              <button type="button" class="w-10 -mt-1 flex-none">
                <span name="hero-x-mark">x</span>
             </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("reposition", params, socket) do
    #Put your logic here to deal with the changes to the list order
    #and persist the data
    IO.inspect(params)
    {:noreply, socket}
  end


  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end