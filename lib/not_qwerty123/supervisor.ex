defmodule NotQwerty123.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    children = [
      NotQwerty123.WordlistManager
    ]

    opts = [strategy: :one_for_all]

    Supervisor.init(children, opts)
  end
end
