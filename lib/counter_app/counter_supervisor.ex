defmodule CounterApp.CounterSupervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    try do
      :ets.new(:counter_table, [:set, :public, :named_table])
    rescue
      ArgumentError -> :ok  # Table already exists
    end

    children = [
      {CounterApp.Counter, 0}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
