# dbt_jaffleverse: working notes for agents

A deliberately unfinished dbt package that exists to be contributed to. Your job is usually to
help someone make **one small, correct, conforming contribution**, not to build everything you
notice is missing.

## The company

Jaffleverse Holdings: a toastie shop that became a conglomerate. Five divisions selling
unrelated absurd products (*Noise Cancelling Plant*, *Emotional Support Brick*, *Decaf Espresso
(Regular Strength)*). The tone is dry and deadpan. Keep it work-appropriate.

## The four contribution routes

**All four procedures live in `.claude/skills/<route>/SKILL.md`. Read the matching one before
you start.** Some tools expose them as slash commands (`/add-seed`); it does not matter if yours
does not. The table below tells you which file to open for any request, and the essentials are
repeated inline so you can act correctly even if you only read this file.

| If they ask for something like… | Route | Read |
|---|---|---|
| "add a product", "add a customer", "add an order", "add seed data", "invent something" | seed data | `.claude/skills/add-seed/SKILL.md` |
| "add a test", "check that…", "make sure the data…", "enforce a rule" | data test | `.claude/skills/add-test/SKILL.md` |
| "add a macro", "make this reusable", "I keep repeating this SQL" | macro | `.claude/skills/add-macro/SKILL.md` |
| "add a model", "build a table", "I want to know X per Y" | model | `.claude/skills/add-model/SKILL.md` |

Across every route: **ask them to direct it, then you do the writing.** Do not ask whether they
would rather type it themselves. Ask what they want it to *be*, and meet them wherever they are:
a fully-formed idea, a vague direction ("something passive-aggressive"), or nothing at all, in
which case pitch three options and let them pick, mix, or reject.

### 🌱 Add seed data
Edit a CSV in `integration_tests/seeds/`. Read `integration_tests/seeds/README.md` first for the
table reference and foreign keys. Use an unused ID in **9000–9999**, append to the **end** of the
file, keep the trailing newline, quote fields containing commas, and check every foreign key
resolves. Take their idea exactly as given, however strange. Your job is formatting and foreign
keys, not editorial.

### 🧪 Add a data test
Generic tests go in a model `.yml` (arguments nest under an `arguments:` key); singular tests go
in `integration_tests/tests/` and pass when they return no rows. Ten of the eleven staging models
have no tests at all, which is the gap. **The seed data is internally consistent, so a
well-written test should pass.** If one fails, do not weaken it to force green: work out whether
the test or the data is wrong, and say which in the PR.

### 🔧 Add a macro
Follow the shape and comment density of `macros/jaffleverse_segment_rank.sql`: one `{# ... #}`
block, no per-line commentary. Prefix with `jaffleverse_` if it could collide. **Wire it into a
model**; a macro nothing calls is dead code.

### 🏗️ Add a model
Get them to finish "one row per ___" before writing anything; if they cannot, the model is not
ready. Copy the closest existing mart. Document every column in `models/marts/jaffleverse.yml`
and put `unique` + `not_null` on the primary key.

## Layout

```
models/staging/       11 models, one per source table. Rename, cast, light cleanup only.
models/intermediate/  1 ephemeral model. Joins, no aggregation to a new grain.
models/marts/         3 models. The things consumers actually select from.
macros/               1 macro.
integration_tests/    A consumer project that installs the package via `local: ../`.
integration_tests/seeds/  The 11 raw CSVs. This is where seed contributions go.
```

Seeds live **only** in `integration_tests/seeds/`. Never add seeds to the package root, because a
package must not dump demo data into a consumer's warehouse.

There is **no root `tests/` directory** and there should never be one. Singular tests go in
`integration_tests/tests/`; generic tests go in the model `.yml` files.

## Conventions

- Model names: `stg_jaffleverse__<plural>`, `int_jaffleverse__<description>`,
  `jaffleverse__<plural>`.
- CTE style: one CTE per source, a `final` CTE, then `select * from final`.
- **One space before `as` in a column alias.** Never pad aliases to align them.
- Lowercase SQL keywords.
- Staging models `ref()` nothing. They select from `{{ source('jaffleverse', 'jaffle_x') }}`.
  Marts `ref()` staging or intermediate models, never sources.
- Use dbt cross-database macros (`dbt.type_numeric()`, `dbt.datediff()`, `dbt.concat()`) rather
  than warehouse-specific SQL. This package should build on more than DuckDB.
- Lateral column aliasing is **not** portable. Repeat the expression instead of referring to an
  alias defined in the same `select`.

## Optional subject areas

`jaffleverse_using_reviews` and `jaffleverse_using_promotions` gate their staging models with
`{{ config(enabled=var('...', True)) }}`, and gate the corresponding CTEs and joins in the marts
with `{% if var('...', True) %}`.

**If you touch a guarded model or a mart that joins one, you must build with the var both on and
off before claiming it works.** A guarded path that only ever ran in one state is unverified.

## Seed data rules

- Contributor IDs are **9000–9999** in every table. Baseline data stays below 9000.
- Append to the end of the file. Never edit or reorder existing rows.
- Every CSV must end with a trailing newline.
- Every foreign key must resolve. `integration_tests/seeds/README.md` documents them all.

### No real people, no PII: this is binding

Every customer and employee is a **public-domain fictional character** (Jane Eyre, Ebenezer
Scrooge, Sherlock Holmes). If you add one, add a fictional character. **Never** use a real
person's name, not the user's, not a colleague's, not one from anywhere else in the session.

The dataset has **no email, phone or address columns** and must never gain one. If a user asks
for an email column or a realistic contact field, push back: this is a public repo that a room
full of strangers will contribute to, and a plausible-looking address field invites people to
paste in their own.

### The seed data is consistent, keep it that way

Payments reconcile to their line items, customers sign up before they order, products are not
sold after discontinuation or before launch, promotions are only applied inside their window,
and reviews only exist on completed orders. Anything you add must hold to the same rules, so
check the dates and amounts line up rather than only the foreign keys.

### Who decides whether to build

**When you are helping someone contribute, do not run the build unless they ask.** Whether and
when to build is theirs to choose. Plenty of contributors will open the PR and let a maintainer
run it, and that is a completely valid path. Offer, do not assume.

This does not license claiming things work. If you have not run the build, say so plainly. Use
"this is ready, I have not run it" rather than implying it passes. If you *do* run it, report
the real result including failures. A successful Jinja parse is never evidence that a model
works.

## Scope discipline

The gaps in this package are deliberate. They are the contribution backlog. Do not fill them
unprompted. If someone asks for one model, build one model.

## Where the agent files live

`AGENTS.md` (this file) is the single source of truth for conventions. `CLAUDE.md` is a one-line
import of it, because Claude Code reads `CLAUDE.md` rather than `AGENTS.md`.

The four route procedures live in **`.claude/skills/<route>/SKILL.md`**: one folder, no copies.
Claude Code and Cursor both load that directory and expose the routes as slash commands. Other
tools will not, which is why the routing table above exists: open the file directly. Do not
create parallel skill directories for other tools; add to the table instead.
