defmodule PresenceMultinode.Demo do
  def run_short do
    spawn(fn ->
      PresenceMultinode.Tracker.track(%{state: :tracked})
    end)
  end

  def run_long do
    spawn(fn ->
      PresenceMultinode.Tracker.track(%{state: :tracked})
      :timer.sleep(2000)
    end)
  end

  def run_short_update do
    spawn(fn ->
      PresenceMultinode.Tracker.track(%{state: :tracked})
      :timer.sleep(2000)
      PresenceMultinode.Tracker.update(%{state: :updated})
    end)
  end

  def run_long_update do
    spawn(fn ->
      PresenceMultinode.Tracker.track(%{state: :tracked})
      :timer.sleep(2000)
      PresenceMultinode.Tracker.update(%{state: :updated})
      :timer.sleep(2000)
    end)
  end
end
