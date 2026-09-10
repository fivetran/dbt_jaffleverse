# Contributing to dbt_jaffleverse

This repo exists to be contributed to.

If this is your first time opening a pull request against a dbt package, you are exactly the
person we built it for. Pick a route below, open an issue, open a PR. If it does not build, we
will fix it together. Nobody is going to be precious about it.

---

## Choose your route

Four ways in, ordered by how long they take. All four are equally welcome; Route 1 is not a
lesser contribution than Route 4.

| | Route | Time | What you edit |
|---|---|---|---|
| 🌱 | **[Stock the Shelves](#-route-1-stock-the-shelves)**: invent a product, customer or order | ~2 min | `integration_tests/seeds/*.csv` |
| 🧪 | **[Trust the Data](#-route-2-trust-the-data)**: write a data test | ~5 min | `models/**/*.yml`, `integration_tests/tests/` |
| 🔧 | **[Automate It](#-route-3-automate-it)**: write a macro | ~10 min | `macros/` |
| 🏗️ | **[Build a Model](#-route-4-build-a-model)**: add a new model | ~15 min | `models/marts/` |

Start by opening an issue. The [issue chooser](../../issues/new/choose) walks you through each
route and asks the few questions we need.

---

## 🌱 Route 1: Stock the Shelves

You are adding raw data. No SQL required. You are editing a CSV.

**The three rules:**

1. **Use an ID between 9000 and 9999.** Every table reserves that range for contributors, so no
   two people end up claiming the same ID.
2. **Append to the end of the file.** Never edit or reorder existing rows.
3. **Leave a trailing newline.** Otherwise the next person's row lands on top of yours.

**The easiest possible contribution**: one line in `integration_tests/seeds/jaffle_product.csv`:

```csv
9001,502,4,Alarm Clock That Apologises,"Wakes you, then says sorry about it.",34.00,12.50,true,2026-09-01,
```

Every table's columns, required fields and foreign keys are documented in
[`integration_tests/seeds/README.md`](integration_tests/seeds/README.md), along with recipes for
adding a customer and a complete order.

**No real people, no personal data.** Every person in this dataset is a public-domain fictional
character. If you add a customer or employee, add a fictional character too. Do not use a real person's name, including
your own. There are deliberately no email, phone or address columns anywhere in the dataset;
please do not add any.

Keep it weird, keep it kind. This is a public repo, so anything you would not want read aloud to
a room of strangers does not belong here.

---

## 🧪 Route 2: Trust the Data

You are adding a rule the data must satisfy on every build.

**The seed data is internally consistent**, so a well-written test should pass. Payments
reconcile to their line items, nobody orders before they sign up, nothing sells after it is
discontinued, and every foreign key resolves.

That is deliberate. Your PR should go green and merge on the day.

What is missing is the tests themselves. Ten of the eleven staging models have none, so as
people add seed data through these routes, nothing stops an inconsistent row slipping in. The
test you write today is what catches it tomorrow.

Ideas, all of which pass on the current data:

- every line item has a quantity of at least one
- no product is sold after its `discontinued_date`
- no order is taken after the employee's `terminated_date`
- every completed order has a payment against it
- a promotion is only ever applied inside its validity window
- ratings fall between 1 and 5
- primary keys on any of the ten untested staging models

If a test you write does fail, do not weaken it to force green. Work out whether the test or the
data is wrong and say which in the PR. Either answer is a good contribution.

**Generic tests** go in a `.yml` file. Worked example in `models/staging/stg_jaffleverse.yml`:

```yaml
- name: customer_segment
  tests:
    - accepted_values:
        arguments:
          values: ['consumer', 'small_business', 'enterprise', 'reseller']
```

**Singular tests** are SQL files that return the offending rows, and an empty result passes. Worked
example: `integration_tests/tests/assert_every_order_has_line_items.sql`.

Ten of the eleven staging models have no tests at all. That is on purpose. Help yourself.

---

## 🔧 Route 3: Automate It

You are writing reusable SQL that every project installing this package gets for free.

There is exactly one macro today: `macros/jaffleverse_segment_rank.sql`. Copy its shape.

**Two things make a macro good here:**

1. **It works on more than one warehouse.** Use dbt's cross-database macros
   (`{{ dbt.datediff(...) }}`, `{{ dbt.concat(...) }}`, `{{ dbt.type_numeric() }}`) rather than
   warehouse-specific SQL.
2. **Something actually calls it.** A macro nothing uses is dead code. Wire it into a model.

Ideas if you want one: `margin_pct()`, `safe_divide()`, `order_status_group()`,
`lead_time_bucket()`, `is_promotion_valid_on()`.

---

## 🏗️ Route 4: Build a Model

You are adding a table the package produces for everyone who installs it.

All eleven source tables already have a staging model, so you can `ref()` anything without
building groundwork first. Only three marts exist, so copy whichever is closest.

**The three rules of a model here:**

1. **State the grain in the description.** "One row per X." If you cannot finish that sentence,
   the model is not ready.
2. **`ref()` the staging models**, never the sources directly.
3. **Document every column and test the primary key** in `models/marts/jaffleverse.yml`.

The obvious gaps: `jaffleverse__divisions`, `jaffleverse__employees`, `jaffleverse__suppliers`,
`jaffleverse__daily_sales`, promotion effectiveness, review sentiment, customer cohorts. Or build
something we have not thought of.

---

## Do I have to run it locally?

**No.** Open the PR anyway. A maintainer will run the build and tell you what happened. This is
a completely normal path, and it is not a lesser contribution.

If you would like to run it, and it is genuinely satisfying to watch your product appear in a
built table, here is the whole setup:

Navigate to the Jaffleverse integration_tests folder

```bash
cd integration_tests
```

```bash
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
```

Add a DuckDB target to your `~/.dbt/profiles.yml`. DuckDB needs no credentials and no warehouse
account. It writes to a file next to the project:

```yaml
integration_tests:
  target: duckdb
  outputs:
    duckdb:
      type: duckdb
      path: jaffleverse.duckdb
      schema: jaffleverse_dev
      threads: 4
```

Then:

```bash
dbt deps
dbt seed
dbt build
```

`dbt seed` matters on the first run. The staging models read from sources rather than refs, so
dbt has no ordering edge from the seeds to them, and on a brand new database the models would
run first and find nothing. After that, plain `dbt build` is enough.

A full build takes a couple of seconds. If you see `Completed successfully`, you are done.

---

## What happens to your PR

A maintainer reads it, runs the build, and merges it. If something needs changing we will say
what, and help you change it if you want the help.

There is no window and no deadline. Contribute whenever you get to it, whether that is today or
in six months. Every merged change goes into the changelog.

## Ground rules

Be kind, be weird, keep it work-appropriate. The
[dbt Community Code of Conduct](https://docs.getdbt.com/community/resources/code-of-conduct)
applies here.
