defmodule SimpleExpenseTrackerWeb.ExpenseControllerTest do
  use SimpleExpenseTrackerWeb.ConnCase

  alias SimpleExpenseTracker.Repo
  alias SimpleExpenseTracker.Schema.{Expense, ExpenseCategory}

  @valid_expense_attrs %{
    "description" => "Lunch",
    "amount" => "15.50",
    "date" => ~D[2025-08-19],
    "notes" => "Business lunch",
    "expense_category_id" => nil
  }

  @invalid_expense_attrs %{
    "description" => "",
    "amount" => "-5",
    "date" => nil,
    "expense_category_id" => nil
  }

  setup do
    category = Repo.insert!(%ExpenseCategory{name: "Food"})
    {:ok, category: category}
  end

  describe "GET /expenses" do
    test "lists all expenses", %{conn: conn} do
      conn = get(conn, Routes.expense_path(conn, :index))
      assert html_response(conn, 200) =~ "Expenses"
    end
  end

  describe "GET /expenses/new" do
    test "renders form", %{conn: conn, category: category} do
      conn = get(conn, Routes.expense_path(conn, :new))
      assert html_response(conn, 200) =~ "New Expense"
      assert conn.assigns.categories |> Enum.any?(fn c -> c.id == category.id end)
    end
  end

  describe "POST /expenses" do
    test "creates expense with valid data", %{conn: conn, category: category} do
      valid_attrs = Map.put(@valid_expense_attrs, "expense_category_id", category.id)

      conn = post(conn, Routes.expense_path(conn, :create), %{"expense" => valid_attrs})
      expense = Repo.get_by!(Expense, description: "Lunch")

      assert get_flash(conn, :info) =~ "Expense created successfully"
      assert redirected_to(conn) == Routes.expense_path(conn, :show, expense)
    end

    test "does not create expense with invalid data", %{conn: conn} do
      conn = post(conn, Routes.expense_path(conn, :create), %{"expense" => @invalid_expense_attrs})
      assert html_response(conn, 200) =~ "Oops, something went wrong!"
    end
  end

  describe "GET /expenses/:id" do
    test "shows expense when found", %{conn: conn, category: category} do
      expense = Repo.insert!(%Expense{description: "Lunch", amount: 10, date: ~D[2025-08-19], expense_category_id: category.id})

      conn = get(conn, Routes.expense_path(conn, :show, expense))
      assert html_response(conn, 200) =~ "Lunch"
    end

    test "redirects when expense not found", %{conn: conn} do
      conn = get(conn, Routes.expense_path(conn, :show, Ecto.UUID.generate()))
      assert get_flash(conn, :error) =~ "Expense not found"
      assert redirected_to(conn) == Routes.expense_path(conn, :index)
    end
  end

  describe "GET /expenses/:id/edit" do
    test "renders edit form", %{conn: conn, category: category} do
      expense = Repo.insert!(%Expense{description: "Dinner", amount: 20, date: ~D[2025-08-19], expense_category_id: category.id})
      conn = get(conn, Routes.expense_path(conn, :edit, expense))
      assert html_response(conn, 200) =~ "Edit Expense"
    end
  end

  describe "PUT /expenses/:id" do
    test "updates expense with valid data", %{conn: conn, category: category} do
      expense = Repo.insert!(%Expense{description: "Coffee", amount: 5, date: ~D[2025-08-19], expense_category_id: category.id})
      update_attrs = %{"description" => "Updated Coffee", "amount" => "6.50"}

      conn = put(conn, Routes.expense_path(conn, :update, expense), %{"expense" => update_attrs})
      assert get_flash(conn, :info) =~ "Expense updated successfully"
      assert redirected_to(conn) == Routes.expense_path(conn, :show, expense)

      updated_expense = Repo.get!(Expense, expense.id)
      assert updated_expense.description == "Updated Coffee"
      assert Decimal.equal?(updated_expense.amount, Decimal.new("6.50"))
    end

    test "does not update expense with invalid data", %{conn: conn, category: category} do
      expense = Repo.insert!(%Expense{description: "Coffee", amount: 5, date: ~D[2025-08-19], expense_category_id: category.id})

      conn = put(conn, Routes.expense_path(conn, :update, expense), %{"expense" => @invalid_expense_attrs})
      assert html_response(conn, 200) =~ "Edit Expense"
    end
  end
end
