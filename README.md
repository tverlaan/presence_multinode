# PresenceMultinode

This repo demonstrates a case which you might not expect to happen using `Phoenix.Tracker`

## Steps to reproduce

Start two nodes and connect them.

```
iex --sname first@localhost -S mix
iex --sname second@localhost -S mix
```

Run commands on first node:

1. `Node.ping :"second@localhost"`
2. `PresenceMultinode.Demo.run_short_update`

On the first node you'll see this:

```elixir
iex(first@localhost)1> Node.ping :"second@localhost"
:pong
iex(first@localhost)2> PresenceMultinode.Demo.run_short_update
#PID<0.186.0>
iex(first@localhost)3>
11:09:01.002 [debug] presence join: key "#PID<0.186.0>" with meta %{phx_ref: "f7bFPvanMkM=", state: :tracked}

11:09:03.004 [debug] presence join: key "#PID<0.186.0>" with meta %{phx_ref: "imjF5GHJKYU=", phx_ref_prev: "f7bFPvanMkM=", state: :updated}

11:09:03.004 [debug] presence leave: key "#PID<0.186.0>" with meta %{phx_ref: "f7bFPvanMkM=", state: :tracked}

11:09:03.004 [debug] presence leave: key "#PID<0.186.0>" with meta %{phx_ref: "imjF5GHJKYU=", phx_ref_prev: "f7bFPvanMkM=", state: :updated}
```

On the second node you'll see this:

```elixir
iex(second@localhost)1>
11:09:01.733 [debug] presence join: key "#PID<0.186.0>" with meta %{phx_ref: "f7bFPvanMkM=", state: :tracked}

11:09:03.225 [debug] presence leave: key "#PID<0.186.0>" with meta %{phx_ref: "f7bFPvanMkM=", state: :tracked}
```

Listing the topic is eventually the same. The second node didn't receive the last update since after updating on the first node the process "untracked" by terminating.

Please see the implementation for more details.
