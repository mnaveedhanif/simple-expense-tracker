defmodule SimpleExpenseTracker.ExpenseTest do
  use SimpleExpenseTracker.DataCase, async: true

  alias SimpleExpenseTracker.Schema.{Expense, ExpenseCategory}

  describe "validate budget" do
    setup do
      # Ensure the database is clean (optional depending on your test setup)
      Repo.delete_all(Expense)
      Repo.delete_all(ExpenseCategory)

      # Insert a sample expense category with a monthly budget
      category =
        %ExpenseCategory{
          name: "Food",
          description: "Monthly food expenses",
          monthly_budget: Decimal.new("500.00")
        }
        |> Repo.insert!()

      {:ok, category: category}
    end

    test "allows expense within the monthly budget", %{category: category} do
      changeset =
        %Expense{}
        |> Expense.changeset(%{
          description: "Groceries",
          amount: Decimal.new("100.00"),
          date: ~D[2025-08-20],
          expense_category_id: category.id
        })

      assert changeset.valid?
    end

    test "rejects expense exceeding the monthly budget", %{category: category} do
      # Insert an existing expense to partially fill the budget
      %Expense{
        description: "Previous groceries",
        amount: 450.00,
        date: ~D[2025-08-01],
        expense_category_id: category.id
      }
      |> Repo.insert!()

      # Try to insert an expense that would exceed the budget
      changeset =
        %Expense{}
        |> Expense.changeset(%{
          description: "Extra groceries",
          amount: 100.00,
          date: ~D[2025-08-20],
          expense_category_id: category.id
        })

      refute changeset.valid?

      assert {"would exceed the monthly budget of $500.00", _} =
               changeset.errors[:amount]
    end

    test "allows expense that exactly fills the remaining budget", %{category: category} do
      # Insert an existing expense
      %Expense{
        description: "Previous groceries",
        amount: Decimal.new("300.00"),
        date: ~D[2025-08-01],
        expense_category_id: category.id
      }
      |> Repo.insert!()

      # Insert an expense that exactly reaches the budget
      changeset =
        %Expense{}
        |> Expense.changeset(%{
          description: "Remaining groceries",
          amount: Decimal.new("200.00"),
          date: ~D[2025-08-20],
          expense_category_id: category.id
        })

      assert changeset.valid?
    end
  end

  describe "currency calculations" do
    setup do
      # Create a category with a monthly budget
      category = %ExpenseCategory{
        name: "Groceries",
        description: "Monthly groceries",
        monthly_budget: Decimal.new("500.00")
      }

      {:ok, category: category}
    end

    test "adding expenses within budget succeeds", %{category: category} do
      expense1 = %Expense{
        description: "Supermarket",
        amount: Decimal.new("120.50"),
        date: ~D[2025-08-20],
        expense_category_id: category.id
      }

      expense2 = %Expense{
        description: "Farmers market",
        amount: Decimal.new("80.25"),
        date: ~D[2025-08-21],
        expense_category_id: category.id
      }

      total_spent =
        Decimal.add(expense1.amount, expense2.amount)

      remaining_budget =
        Decimal.sub(category.monthly_budget, total_spent)

      assert Decimal.compare(remaining_budget, Decimal.new("0")) != :lt
    end

    test "expense exceeding budget is detected", %{category: category} do
      # Expense higher than budget
      expense = %Expense{
        description: "Expensive groceries",
        amount: Decimal.new("600.00"),
        date: ~D[2025-08-20],
        expense_category_id: category.id
      }

      remaining_budget =
        Decimal.sub(category.monthly_budget, expense.amount)

      assert Decimal.compare(remaining_budget, Decimal.new("0")) == :lt
    end

    test "correctly handles fractional cents", %{category: category} do
      expense = %Expense{
        description: "Coffee",
        amount: Decimal.new("0.99"),
        date: ~D[2025-08-20],
        expense_category_id: category.id
      }

      remaining_budget =
        Decimal.sub(category.monthly_budget, expense.amount)

      assert Decimal.equal?(remaining_budget, Decimal.new("499.01"))
    end
  end
end
