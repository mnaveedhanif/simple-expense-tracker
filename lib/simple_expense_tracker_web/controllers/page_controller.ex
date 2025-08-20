defmodule SimpleExpenseTrackerWeb.PageController do
  use SimpleExpenseTrackerWeb, :controller

  # GET /expenses
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
