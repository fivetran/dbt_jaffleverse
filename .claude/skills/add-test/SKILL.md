---
name: add-test
description: Add a data test to the Jaffleverse dbt package. Use when a contributor wants to write a test, enforce a data rule, or take the data-test contribution route.
---

Help the user add a data test.

**Never run `dbt build` yourself unless they ask.** Whether and when to build is their call.

## 1. Find something worth catching

The seed data is internally consistent, so a well-written test should pass. Ten of the eleven
staging models have no tests at all, which is the gap worth filling: as people add seed data
through the contribution routes, nothing currently stops an inconsistent row slipping in.

Rules that hold today and are worth locking in: quantity of at least 1, nothing sold after its
`discontinued_date`, no order after an employee's `terminated_date`, every completed order has
a payment, promotions only used inside their window, ratings between 1 and 5, primary keys
unique and not null on any untested staging model.

Ask which rule they want to enforce, or suggest one from that list.

## 2. Ask them to direct it: you do the writing

**You write the test. They decide what it should catch.** Ask what rule they want enforced, at
whatever level of precision they have:

> **What should the data never do?** Any of these is enough to go on:
> - **a specific rule**: "a product shouldn't sell after it's discontinued"
> - **a rough instinct**: "something about refunds looks off to me"
> - **nothing yet**: pick one from the list above and I'll write a test for it

Once you have their direction, write it and walk them through what it does before they keep it.
If they want to change the logic, change it. Their test, their PR.

## 3. Pick the form

- **Generic**: a few lines in a `.yml`. Ten of the eleven staging models have no tests at all;
  `models/staging/stg_jaffleverse.yml` has the only worked example. Note that generic test
  arguments go under an `arguments:` key.
- **Singular**: a `.sql` in `integration_tests/tests/` returning the offending rows, empty
  result passes. `assert_every_order_has_line_items.sql` is the worked example.

## 4. If it fails

A well-written test should pass on this data. If one fails, **do not weaken it to force green**.
Work out whether the test or the data is wrong, tell the user which, and put that in the PR.
Either answer is a good contribution, but quietly loosening the assertion is not.

## 5. Hand it back, do not build

> That is ready. Open the PR as-is and a maintainer will run it. If you would rather see it go
> green now, run `cd integration_tests && dbt seed && dbt build`, or say the word and I will.

If they ask you to run it, report the real result and show the offending rows.
