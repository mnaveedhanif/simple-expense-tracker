defmodule SimpleExpenseTrackerWeb.Context.ExpenseContext do
  alias SimpleExpenseTracker.Repo
  alias SimpleExpenseTracker.Schema.Expense

  def create_expense(attrs \\ %{}) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  def get_expense_by_id(id), do: Repo.get!(Expense, id)

  def get_all_expenses do
    Repo.all(Expense)
  end

  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end
end
