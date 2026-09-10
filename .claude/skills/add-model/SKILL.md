---
name: add-model
description: Add a new mart model to the Jaffleverse dbt package. Use when a contributor wants to build a model or take the model contribution route.
---

Help the user add a model to `models/marts/`.

**Never run `dbt build` yourself unless they ask.** Whether and when to build is their call.

## 1. Nail the grain before writing anything

Ask what question the model answers, and get them to finish this sentence with you:
**"one row per ___".** If they cannot, the model is not ready, so work that out first. This is
the single most useful thing you can do for them.

Check `README.md` for the deliberate gaps. What they want may already be a named backlog item
(`jaffleverse__divisions`, `__employees`, `__suppliers`, `__daily_sales`, promotion
effectiveness, review sentiment, cohorts).

## 2. Ask them to direct it: you do the writing

**You write the SQL. They decide what the model is for.** Ask at whatever level they have:

> **What should it tell you?** Any of these is enough:
> - **a specific question**: "which division actually makes money once you count cost of goods"
> - **a subject area**: "something about suppliers", "something about time"
> - **nothing yet**: pick one of the gaps above and I'll build it

Draft it, then talk them through it and change whatever they disagree with. They should be able
to explain their own model to the maintainer merging it, so keep them with you as you go.

## 3. Follow the house shape

- Read the closest existing mart (`jaffleverse__orders`, `__customers`, `__products`) and follow
  its CTE structure.
- `ref()` staging or intermediate models, never sources.
- One space before each `as` alias. No aligned padding.
- Repeat expressions rather than relying on lateral column aliasing, which is not portable.
- Document **every** column in `models/marts/jaffleverse.yml`, with `unique` and `not_null` on
  the primary key.
- If the model touches reviews or promotions, guard the CTE and join with
  `{% if var('jaffleverse_using_reviews', True) %}`.

## 4. Hand it back, do not build

> That is ready. Open the PR as-is and a maintainer will build it. If you would like to see your
> table exist first, run `cd integration_tests && dbt seed && dbt build`, or say the word and I will run it
> and show you the rows.

If they ask you to build: run it, report the real row count and a sample. If the model is
guarded, build with those vars **off** as well. A guarded path that only ran in one state is
unverified. Report failures honestly rather than quietly fixing and re-running.

Build one model. Do not fill in the other gaps unprompted. They are someone else's contribution.
