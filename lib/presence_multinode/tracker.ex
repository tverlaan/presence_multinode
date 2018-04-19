defmodule PresenceMultinode.Tracker do
  @behaviour Phoenix.Tracker
  require Logger

  def list() do
    Phoenix.Tracker.list(__MODULE__, "test")
  end

  def track(meta) do
    Phoenix.Tracker.track(__MODULE__, self(), "test", "#{inspect(self())}", meta)
  end

  def update(meta) do
    Phoenix.Tracker.update(__MODULE__, self(), "test", "#{inspect(self())}", meta)
  end

  def start_link(opts) do
    opts = Keyword.merge([name: __MODULE__], opts)
    GenServer.start_link(Phoenix.Tracker, [__MODULE__, opts, opts], name: __MODULE__)
  end

  def init(opts) do
    server = Keyword.fetch!(opts, :pubsub_server)
    {:ok, %{pubsub_server: server, node_name: Phoenix.PubSub.node_name(server)}}
  end

  def handle_diff(diff, state) do
    for {topic, {joins, leaves}} <- diff do
      for {key, meta} <- joins do
        Logger.debug("presence join: key \"#{key}\" with meta #{inspect(meta)}")
        msg = {:join, key, meta}
        Phoenix.PubSub.direct_broadcast!(state.node_name, state.pubsub_server, topic, msg)
      end

      for {key, meta} <- leaves do
        Logger.debug("presence leave: key \"#{key}\" with meta #{inspect(meta)}")
        msg = {:leave, key, meta}
        Phoenix.PubSub.direct_broadcast!(state.node_name, state.pubsub_server, topic, msg)
      end
    end

    {:ok, state}
  end
end
