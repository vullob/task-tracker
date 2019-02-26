defmodule TaskTracker.Repo do
  use Ecto.Repo,
    otp_app: :taskTracker,
    adapter: Ecto.Adapters.Postgres
end
