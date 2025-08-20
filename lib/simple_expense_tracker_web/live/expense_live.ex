defmodule SimpleExpenseTrackerWeb.ExpenseLive do
  use SimpleExpenseTrackerWeb, :live_view
  alias SimpleExpenseTrackerWeb.Context.ExpenseContext

  @impl true
  @spec mount(any(), any(), Phoenix.LiveView.Socket.t()) :: {:ok, any()}
  def mount(_params, _session, socket) do
    if connected?(socket), do: IO.puts("[ExpenseLive] Socket Connected!")
    expenses = ExpenseContext.get_all_expenses()
    {:ok, assign(socket, expenses: expenses)}
  end

  @impl true
  @spec render(any()) :: any()
  def render(assigns) do
    Phoenix.View.render(SimpleExpenseTrackerWeb.ExpenseView, "index.html", assigns)
  end
end
