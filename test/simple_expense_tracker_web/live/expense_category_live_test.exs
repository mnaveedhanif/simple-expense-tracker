defmodule SimpleExpenseTrackerWeb.ExpenseCategoryLiveTest do
  use SimpleExpenseTrackerWeb.ConnCase
  import Phoenix.LiveViewTest

  alias SimpleExpenseTracker.Schema.ExpenseCategory
  alias SimpleExpenseTracker.Repo

  describe "ExpenseCategoryLive" do
    test "mounts the live view and displays categories", %{conn: conn} do
      # Insert a test category
      Repo.insert!(%ExpenseCategory{name: "Food"})

      # Mount the LiveView
      {:ok, _view, html} = live(conn, Routes.expense_category_path(conn, :index))

      # Assert the rendered HTML contains the category name
      assert html =~ "Food"
    end
  end
end
