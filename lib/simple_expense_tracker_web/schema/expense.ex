defmodule SimpleExpenseTracker.Schema.Expense do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias SimpleExpenseTracker.Repo
  alias SimpleExpenseTracker.Schema.ExpenseCategory

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "expenses" do
    field :description, :string
    field :amount, :decimal
    field :date, :date
    field :notes, :string

    belongs_to :expense_category, SimpleExpenseTracker.Schema.ExpenseCategory, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:description, :amount, :date, :notes, :expense_category_id])
    |> validate_required([:description, :amount, :date, :expense_category_id])
    |> validate_number(:amount, greater_than_or_equal_to: 0.0, message: "must be zero or greater")
    |> assoc_constraint(:expense_category)
    |> validate_budget()
  end

   # Custom validation to prevent exceeding monthly budget
   defp validate_budget(changeset) do
    category_id = get_field(changeset, :expense_category_id)
    amount = get_field(changeset, :amount)
    date = get_field(changeset, :date)

    if category_id && amount && date do
      {year, month, _day} = {date.year, date.month, date.day}

      # Get total expenses for this category in the same month
      total_spent =
        Repo.one(
          from e in __MODULE__,
            where:
              e.expense_category_id == ^category_id and
                fragment("date_part('year', ?)", e.date) == ^year and
                fragment("date_part('month', ?)", e.date) == ^month,
            select: coalesce(sum(e.amount), 0)
        )

      # Fetch category monthly budget
      category = Repo.get!(ExpenseCategory, category_id)

      sum = Decimal.add(total_spent, amount)

      if Decimal.compare(sum, category.monthly_budget) == :gt do
        add_error(
          changeset,
          :amount,
          "would exceed the monthly budget of $#{category.monthly_budget}"
        )
      else
        changeset
      end
    else
      changeset
    end
  end
end
