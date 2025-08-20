defmodule SimpleExpenseTracker.Repo do
  use Ecto.Repo,
    otp_app: :simple_expense_tracker,
    adapter: Ecto.Adapters.Postgres
end
