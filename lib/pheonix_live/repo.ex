defmodule PheonixLive.Repo do
  use Ecto.Repo,
    otp_app: :pheonix_live,
    adapter: Ecto.Adapters.SQLite3
end
