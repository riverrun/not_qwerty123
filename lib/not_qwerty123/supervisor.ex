defmodule NotQwerty123.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    children = [
      worker(NotQwerty123.WordlistManager, [])
    ]

    supervise(children, strategy: :one_for_all)
  end
end
