defmodule CounterApp.Counter do
  use GenServer

  # Client API
  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def increment do
    GenServer.cast(__MODULE__, :increment)
  end

  def decrement do
    GenServer.cast(__MODULE__, :decrement)
  end

  def get_count do
    GenServer.call(__MODULE__, :get_count)
  end

  #Server Callbacks
  @impl true
  def init(initial_value) do
    count = case :ets.lookup(:counter_table, :count) do
      [{:count, value}] -> value
      [] -> initial_value
    end
    {:ok, count}
  end

  @impl true
  def handle_cast(:increment, count) do
    new_count = count + 1
    :ets.insert(:counter_table, {:count, new_count})
    Phoenix.PubSub.broadcast(CounterApp.PubSub, "counter", {:count_update, new_count})
    {:noreply, new_count}
  end

  @impl true
  def handle_cast(:decrement, count) do
    new_count = count - 1
    :ets.insert(:counter_table, {:count, new_count})
    Phoenix.PubSub.broadcast(CounterApp.PubSub, "counter", {:count_update, new_count})
    {:noreply, new_count}
  end

  @impl true
  def handle_call(:get_count, _from, count) do
    {:reply, count, count}
  end
end
