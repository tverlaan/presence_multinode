defmodule PresenceMultinode.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      supervisor(Phoenix.PubSub.PG2, [PresenceMultinode.PubSub, [pool_size: 1]]),
      worker(PresenceMultinode.Tracker, [
        [name: PresenceMultinode.Tracker, pubsub_server: PresenceMultinode.PubSub]
      ])
    ]

    opts = [strategy: :one_for_one]
    supervise(children, opts)
  end
end
