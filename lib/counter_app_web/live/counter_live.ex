defmodule CounterAppWeb.CounterLive do
  use CounterAppWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
        Phoenix.PubSub.subscribe(CounterApp.PubSub, "counter")
    end

    {:ok, assign(socket, count: CounterApp.Counter.get_count())}
  end

  def handle_event("increment", _params, socket) do
    CounterApp.Counter.increment()
    {:noreply, socket}
  end

  def handle_event("decrement", _params, socket) do
    CounterApp.Counter.decrement()
    {:noreply, socket}
  end

  def handle_info({:count_update, new_count}, socket) do
    {:noreply, assign(socket, count: new_count)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      <div class="p-8 bg-white rounded-lg shadow-md">
        <h1 class="text-3xl font-bold mb-6 text-center">Real-time Counter</h1>
        <div class="flex items-center justify-center space-x-4">
          <button
            phx-click="decrement"
            class="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors"
          >
            -
          </button>
          <span class="text-4xl font-bold px-6"><%= @count %></span>
          <button
            phx-click="increment"
            class="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors"
          >
            +
          </button>
        </div>
      </div>
    </div>
    """
  end
end
