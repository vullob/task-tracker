use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :taskTracker, TaskTrackerWeb.Endpoint,
  secret_key_base: "HE+tC9Qw5oLgHajx1LkE5pakSBcPVkAMGSHP/CCPIJwZo9wYux2Bm1o6mz4UFwD2"

# Configure your database
config :taskTracker, TaskTracker.Repo,
  username: "task_tracker",
  password: "task_tracker",
  database: "tasktracker_prod",
  pool_size: 15
