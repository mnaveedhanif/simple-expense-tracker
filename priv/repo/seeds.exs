# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SimpleExpenseTracker.Repo.insert!(%SimpleExpenseTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias SimpleExpenseTracker.Repo
alias SimpleExpenseTracker.Schema.{ExpenseCategory, Expense}

# Create categories
food =
  Repo.insert!(%ExpenseCategory{
    name: "Food",
    description: "Groceries, restaurants, and takeout",
    monthly_budget: 500.00
  })

transport =
  Repo.insert!(%ExpenseCategory{
    name: "Transport",
    description: "Gas, public transit, ride-sharing",
    monthly_budget: 200.00
  })

entertainment =
  Repo.insert!(%ExpenseCategory{
    name: "Entertainment",
    description: "Movies, subscriptions, hobbies",
    monthly_budget: 150.00
  })

# Create expenses for Food
Repo.insert!(%Expense{
  description: "Supermarket groceries",
  amount: 120.50,
  date: ~D[2025-08-01],
  notes: "Weekly shopping",
  expense_category_id: food.id
})

Repo.insert!(%Expense{
  description: "Pizza night",
  amount: 35.00,
  date: ~D[2025-08-05],
  expense_category_id: food.id
})

# Create expenses for Transport
Repo.insert!(%Expense{
  description: "Gas refill",
  amount: 60.00,
  date: ~D[2025-08-03],
  expense_category_id: transport.id
})

Repo.insert!(%Expense{
  description: "Metro pass",
  amount: 75.00,
  date: ~D[2025-08-07],
  expense_category_id: transport.id
})

# Create expenses for Entertainment
Repo.insert!(%Expense{
  description: "Movie tickets",
  amount: 28.00,
  date: ~D[2025-08-10],
  notes: "Went with friends",
  expense_category_id: entertainment.id
})
