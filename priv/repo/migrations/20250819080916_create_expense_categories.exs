defmodule SimpleExpenseTracker.Repo.Migrations.CreateExpenseCategories do
  use Ecto.Migration

  def change do
    create table(:expense_categories, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :description, :string
      add :monthly_budget, :decimal, null: false, default: 0.0

      timestamps()
    end

    create unique_index(:expense_categories, [:name])
  end
end
