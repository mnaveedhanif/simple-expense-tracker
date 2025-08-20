defmodule SimpleExpenseTrackerWeb.ExpenseCategoryController do
  alias SimpleExpenseTrackerWeb.Context.ExpenseCategoryContext
  use SimpleExpenseTrackerWeb, :controller

  alias SimpleExpenseTracker.Repo
  alias SimpleExpenseTracker.Schema.ExpenseCategory
  alias SimpleExpenseTrackerWeb.Context.ExpenseCategoryContext

  def new(conn, _params) do
    changeset = ExpenseCategory.changeset(%ExpenseCategory{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"expense_category" => category_params}) do
    case ExpenseCategoryContext.create_expense_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Expense category created successfully.")
        |> redirect(to: Routes.expense_category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    case Repo.get(ExpenseCategory, id) do
      nil ->
        conn
        |> put_flash(:error, "Expense Category not found")
        |> redirect(to: Routes.expense_category_path(conn, :index))

      expense_category ->
        render(conn, "show.html", expense_category: expense_category)
    end
  end

  def edit(conn, %{"id" => id}) do
    expense_category = ExpenseCategoryContext.get_expense_category_by_id(id)
    changeset = ExpenseCategory.changeset(expense_category, %{})
    render(conn, "edit.html", expense_category: expense_category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "expense_category" => expense_category_params}) do
    expense_category = ExpenseCategoryContext.get_expense_category_by_id(id)

    case ExpenseCategoryContext.update_expense_category(expense_category, expense_category_params) do
      {:ok, expense_category} ->
        Phoenix.PubSub.broadcast(
          SimpleExpenseTracker.PubSub,
          "expense_categories",
          {:expense_category_updated, expense_category}
        )

        conn
        |> put_flash(:info, "Expense category updated successfully.")
        |> redirect(to: Routes.expense_category_path(conn, :show, expense_category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", expense_category: expense_category, changeset: changeset)
    end
  end
end
