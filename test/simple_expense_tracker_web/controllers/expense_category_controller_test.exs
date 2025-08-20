defmodule SimpleExpenseTrackerWeb.ExpenseCategoryControllerTest do
  use SimpleExpenseTrackerWeb.ConnCase

  alias SimpleExpenseTracker.Repo
  alias SimpleExpenseTracker.Schema.ExpenseCategory

  @valid_attrs %{"name" => "Food", "monthly_budget" => "500"}
  @invalid_attrs %{"name" => ""}

  describe "GET /expense_categories/new" do
    test "renders new category form", %{conn: conn} do
      conn = get(conn, Routes.expense_category_path(conn, :new))
      assert html_response(conn, 200) =~ "New Expense Category"
    end
  end

  describe "POST /expense_categories" do
    test "creates category with valid data", %{conn: conn} do
      conn = post(conn, Routes.expense_category_path(conn, :create), %{"expense_category" => @valid_attrs})
      category = Repo.get_by!(ExpenseCategory, name: "Food")

      assert get_flash(conn, :info) =~ "Expense category created successfully"
      assert redirected_to(conn) == Routes.expense_category_path(conn, :show, category)
    end

    test "does not create category with invalid data", %{conn: conn} do
      conn = post(conn, Routes.expense_category_path(conn, :create), %{"expense_category" => @invalid_attrs})
      assert html_response(conn, 200) =~ "New Expense Category"
    end
  end

  describe "GET /expense_categories/:id" do
    test "shows category when found", %{conn: conn} do
      category = Repo.insert!(%ExpenseCategory{name: "Travel"})
      conn = get(conn, Routes.expense_category_path(conn, :show, category))
      assert html_response(conn, 200) =~ "Travel"
    end

    test "redirects when category not found", %{conn: conn} do
      conn = get(conn, Routes.expense_category_path(conn, :show, Ecto.UUID.generate()))
      assert get_flash(conn, :error) =~ "Expense Category not found"
      assert redirected_to(conn) == Routes.expense_category_path(conn, :index)
    end
  end

  describe "GET /expense_categories/:id/edit" do
    test "renders edit form", %{conn: conn} do
      category = Repo.insert!(%ExpenseCategory{name: "Health"})
      conn = get(conn, Routes.expense_category_path(conn, :edit, category))
      assert html_response(conn, 200) =~ "Edit Expense Category"
    end
  end

  describe "PUT /expense_categories/:id" do
    test "updates category with valid data", %{conn: conn} do
      category = Repo.insert!(%ExpenseCategory{name: "Utilities"})
      update_attrs = %{"name" => "Bills"}

      conn = put(conn, Routes.expense_category_path(conn, :update, category), %{"expense_category" => update_attrs})
      assert get_flash(conn, :info) =~ "Expense category updated successfully"
      assert redirected_to(conn) == Routes.expense_category_path(conn, :show, category)

      updated_category = Repo.get!(ExpenseCategory, category.id)
      assert updated_category.name == "Bills"
    end

    test "does not update category with invalid data", %{conn: conn} do
      category = Repo.insert!(%ExpenseCategory{name: "Groceries"})
      conn = put(conn, Routes.expense_category_path(conn, :update, category), %{"expense_category" => @invalid_attrs})
      assert html_response(conn, 200) =~ "Edit Expense Category"
    end
  end
end
