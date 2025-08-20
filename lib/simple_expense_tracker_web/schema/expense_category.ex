defmodule SimpleExpenseTracker.Schema.ExpenseCategory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "expense_categories" do
    field :name, :string
    field :description, :string
    field :monthly_budget, :decimal

    has_many :expenses, SimpleExpenseTracker.Schema.Expense

    timestamps()
  end

  @doc false
  def changeset(expense_category, attrs) do
    expense_category
    |> cast(attrs, [:name, :description, :monthly_budget])
    |> validate_required([:name, :monthly_budget])
    |> validate_number(:monthly_budget, greater_than_or_equal_to: 0)
    |> unique_constraint(:name, message: "Category name must be unique")
  end
end
