defmodule SimpleExpenseTrackerWeb.ExpenseController do
  use SimpleExpenseTrackerWeb, :controller

  alias SimpleExpenseTracker.Repo
  alias SimpleExpenseTracker.Schema.Expense
  alias SimpleExpenseTracker.Schema.ExpenseCategory
  alias SimpleExpenseTrackerWeb.Context.ExpenseContext

  plug :put_view, SimpleExpenseTrackerWeb.ExpenseView

  # GET /expenses
  def index(conn, _params) do
    expenses = Repo.all(Expense)
    render(conn, "index.html", expenses: expenses)
  end

  def new(conn, _params) do
    changeset = Expense.changeset(%Expense{}, %{})
    categories = Repo.all(ExpenseCategory)

    render(conn, "new.html", changeset: changeset, categories: categories)
  end

  # POST /expenses
  def create(conn, %{"expense" => expense_params}) do
    case ExpenseContext.create_expense(expense_params) do
      {:ok, expense} ->
        Phoenix.PubSub.broadcast(
          SimpleExpenseTracker.PubSub,
          "expenses",
          {:expense_added, expense}
        )

        conn
        |> put_flash(:info, "Expense created successfully.")
        |> redirect(to: Routes.expense_path(conn, :show, expense))

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Repo.all(ExpenseCategory)
        render(conn, "new.html", changeset: changeset, categories: categories)
    end
  end

  # GET /expenses/:id
  def show(conn, %{"id" => id}) do
    case Repo.get(Expense, id) do
      nil ->
        conn
        |> put_flash(:error, "Expense not found")
        |> redirect(to: Routes.expense_path(conn, :index))

      expense ->
        render(conn, "show.html", expense: expense)
    end
  end

  # GET /expenses/:id/edit
  def edit(conn, %{"id" => id}) do
    expense = ExpenseContext.get_expense_by_id(id)
    changeset = Expense.changeset(expense, %{})
    render(conn, "edit.html", expense: expense, changeset: changeset)
  end

  # PUT /expenses/:id
  def update(conn, %{"id" => id, "expense" => expense_params}) do
    expense = ExpenseContext.get_expense_by_id(id)

    case ExpenseContext.update_expense(expense, expense_params) do
      {:ok, expense} ->
        Phoenix.PubSub.broadcast(
          SimpleExpenseTracker.PubSub,
          "expenses",
          {:expense_updated, expense}
        )

        conn
        |> put_flash(:info, "Expense updated successfully.")
        |> redirect(to: Routes.expense_path(conn, :show, expense))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", expense: expense, changeset: changeset)
    end
  end
end
