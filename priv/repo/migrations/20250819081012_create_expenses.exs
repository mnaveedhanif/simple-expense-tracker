defmodule SimpleExpenseTracker.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :description, :string, null: false
      add :amount, :decimal, null: false
      add :date, :date, null: false
      add :notes, :string

      add :expense_category_id,
          references(:expense_categories, on_delete: :delete_all, type: :uuid),
          null: false

      timestamps()
    end

    create index(:expenses, [:expense_category_id])
    create index(:expenses, [:date])
  end
end
