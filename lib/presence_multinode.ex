defmodule PresenceMultinode do
  @moduledoc """
  Documentation for PresenceMultinode.
  """
  use Application

  def start(_, _) do
    PresenceMultinode.Supervisor.start_link()
  end
end
