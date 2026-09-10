---
name: add-macro
description: Add a reusable macro to the Jaffleverse dbt package. Use when a contributor wants to write a macro or take the macro contribution route.
---

Help the user write a macro in `macros/`.

**Never run `dbt build` yourself unless they ask.** Whether and when to build is their call.

## 1. Read the worked example

`macros/jaffleverse_segment_rank.sql` is the only macro in the package. Match its shape and its
comment density: one `{# ... #}` block saying what it does and how to extend it. No per-line
commentary.

## 2. Ask them to direct it: you do the writing

**You write the macro. They decide what it does.** Ask what they want, at whatever level:

> **What should it do?** Any of these works:
> - **a specific function**: "margin as a percentage, without dividing by zero"
> - **a frustration**: "I keep seeing the same `case` statement copy-pasted around"
> - **nothing yet**: I'll suggest a few and you pick

If they need options: `safe_divide()`, `margin_pct()`, `order_status_group()`,
`lead_time_bucket()`, `is_promotion_valid_on()`. But ask what annoyed them about the SQL they
have read so far first. That is usually a better macro than anything on a list.

An absurd-but-working macro is a fine contribution. `jaffleverse_is_it_tuesday()` is a real
option if it amuses them and something calls it.

## 3. Make it good

- Agree a name. Prefix with `jaffleverse_` if it could collide with another package.
- Use dbt cross-database macros (`dbt.datediff()`, `dbt.concat()`, `dbt.type_numeric()`) rather
  than warehouse-specific SQL.
- **Wire it into a model.** A macro nothing calls is dead code. Find the mart where it belongs.

## 4. Hand it back, do not build

> That is ready. Open the PR as-is and a maintainer will build it. If you would like to see the
> compiled SQL first, run `cd integration_tests && dbt seed && dbt build`, or say the word and I will run it
> and show you what your macro expanded to.

If they ask you to build, run it and report the real result. Show the compiled SQL from
`target/compiled/`, because seeing the expansion is the satisfying part.
