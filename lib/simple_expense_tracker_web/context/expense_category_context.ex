defmodule SimpleExpenseTrackerWeb.Context.ExpenseCategoryContext do
  alias SimpleExpenseTracker.Repo
  alias SimpleExpenseTracker.Schema.ExpenseCategory

  def get_all_expense_categories do
    Repo.all(ExpenseCategory)
  end

  def get_expense_category_by_id(id) do
    Repo.get_by(ExpenseCategory, id: id)
  end

  def create_expense_category(params) do
    %ExpenseCategory{}
    |> ExpenseCategory.changeset(params)
    |> Repo.insert()
  end

  def update_expense_category(%ExpenseCategory{} = expense_category, params) do
    expense_category
    |> ExpenseCategory.changeset(params)
    |> Repo.update()
  end

  def get_total_spent_and_recent_expenses_per_category() do
    today = Date.utc_today()
    current_year = today.year
    current_month = today.month

    categories =
      Repo.all(ExpenseCategory)
      |> Repo.preload(:expenses)

    Enum.map(categories, fn category ->
      # Filter only expenses in the current month
      current_month_expenses =
        Enum.filter(category.expenses, fn exp ->
          exp.date.year == current_year and exp.date.month == current_month
        end)

      total_spent =
        current_month_expenses
        |> Enum.reduce(Decimal.new("0"), fn exp, acc -> Decimal.add(acc, exp.amount) end)

      recent_expenses =
        current_month_expenses
        |> Enum.sort_by(& &1.date, {:desc, Date})
        |> Enum.take(3)

      %{
        category: category,
        total_spent: total_spent,
        recent_expenses: recent_expenses
      }
    end)
  end
end
