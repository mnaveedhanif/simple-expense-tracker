defmodule SimpleExpenseTrackerWeb.ExpenseCategoryLive do
  use SimpleExpenseTrackerWeb, :live_view
  alias SimpleExpenseTrackerWeb.Context.ExpenseCategoryContext

  @impl true
  @spec mount(any(), any(), Phoenix.LiveView.Socket.t()) :: {:ok, any()}
  def mount(_params, _session, socket) do
    if connected?(socket) do
      IO.puts("[ExpenseCategoryLive] Socket Connected!")
      Phoenix.PubSub.subscribe(SimpleExpenseTracker.PubSub, "expense_categories")
      Phoenix.PubSub.subscribe(SimpleExpenseTracker.PubSub, "expenses")
    end

    {:ok, load_data(socket)}
  end

  @impl true
  def handle_info({:expense_category_updated, _category}, socket) do
    {:noreply, load_data(socket)}
  end

  def handle_info({:expense_updated, _category}, socket) do
    {:noreply, load_data(socket)}
  end

  def handle_info({:expense_added, _category}, socket) do
    {:noreply, load_data(socket)}
  end

  defp load_data(socket) do
    categories_with_totals =
      ExpenseCategoryContext.get_total_spent_and_recent_expenses_per_category()

    assign(socket, categories_with_totals: categories_with_totals)
  end

  @impl true
  @spec render(any()) :: any()
  def render(assigns) do
    Phoenix.View.render(SimpleExpenseTrackerWeb.ExpenseCategoryView, "index.html", assigns)
  end
end
