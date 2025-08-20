# SimpleExpenseTracker

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


**Run Seed:** 

    mix run priv/repo/seeds.exs

**Currency Handling**

    At present, I use the Decimal type to handle currency values, since I am working with USD and need to support fractional amounts.

**Extending to Multiple Currencies:**

    To support multiple currencies, I plan to add a currency field in a generic configurations table and manage currency handling and conversions within the codebase as needed.

**Shortcut:**
    
    I do not create factory for writing tests just to save time

**Testing Strategy:**
    
    I tested the validations first that they are working fine
    Test monthly_budget that it cannot be negative

    Expense:
    validations: 
     - Test validations for this modal

    Budget Enforcement:
     - Test expenses that it should not exceed from monthly budget

    Functional Tetsing: 
     - Test all contexts working fine with respect to their functionality

    Liveview Testing: 
     - Test that live view are rendering data perfectly without need to refresh page

    Unit Testcases: 
     - Write testcases for all controller methods
     - Add testcases for liveview
     - Add testcase for currency calculations
      