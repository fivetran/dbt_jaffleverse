# dbt_jaffleverse

This is a simulated source specific dbt package, put together the way a real package is. The goal 
of this project is to encourage and welcome contributions. The package ecosystem is made for and by the community.
It's only as good as the community who contributes to it, and this project is meant to simulate how to contribute
back to the ecosystem and have fun doing it!

👉 **[Choose your adventure](../../issues/new/choose)** · 📖 **[Contributing guide](CONTRIBUTING.md)**

---

## The dbt package ecosystem

The [Package Hub](https://hub.getdbt.com/) is where you look before you build. Somebody has
usually met your source schema already, worked out the nuance, tested around it, built complex reporting, and
published the result. You install that instead of rediscovering it, and run it in production. An often missed element
is contributing back when you notice an issue or discover/build something yourself. This exercise is meant to showcase and
highlight the importance of that final (often missing) piece of the ecosystem. In all, the ecosystem only exists 
because the people who hit it wrote it down somewhere others could find.

A few example packages:

| Package | What it gives you |
|---|---|
| [dbt-labs/dbt_utils](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) | Cross database macros almost every other package depends on, including this one. |
| [metaplane/dbt_expectations](https://hub.getdbt.com/metaplane/dbt_expectations/latest/) | A data quality testing vocabulary, built and maintained by the community. |
| [dbt-labs/dbt_project_evaluator](https://hub.getdbt.com/dbt-labs/dbt_project_evaluator/latest/) | Common project problems, expressed as tests you can run against your own. |
| [Datavault-UK/automate_dv](https://hub.getdbt.com/Datavault-UK/automate_dv/latest/) | A whole modelling methodology, packaged. |
| [elementary-data/elementary](https://hub.getdbt.com/elementary-data/elementary/latest/) | Observability and anomaly detection for dbt projects. |
| [dbt-labs/audit_helper](https://hub.getdbt.com/dbt-labs/audit_helper/latest/) | Row by row comparison of two versions of a model, for migrations. |
| [fivetran/zendesk](https://hub.getdbt.com/fivetran/zendesk/latest/) | Ticket metrics, SLA policies and business hours worked out against a real schema. |
| [fivetran/netsuite](https://hub.getdbt.com/fivetran/netsuite/latest/) | A financial model over one of the less forgiving source schemas out there. |
| [fivetran/shopify](https://hub.getdbt.com/fivetran/shopify/latest/) | Orders, refunds, discounts and customer cohorts. |
| [fivetran/salesforce_formula_utils](https://hub.getdbt.com/fivetran/salesforce_formula_utils/latest/) | Recreates Salesforce formula fields in your warehouse. |

---

## Let's get contributing!

Four routes, from a two minute CSV edit to a full model, each with a
worked example already in the repo to copy. Everything you add flows through the package into the
final models, and you can watch it happen.

| | Route | Time | What you edit |
|---|---|---|---|
| 🌱 | Stock the Shelves: invent a product, customer or order | ~2 min | `integration_tests/seeds/*.csv` |
| 🧪 | Trust the Data: write a data test | ~5 min | `models/**/*.yml` |
| 🔧 | Automate It: write a macro | ~10 min | `macros/` |
| 🏗️ | Build a Model: add a new model | ~15 min | `models/marts/` |

For details on how to effectively contribute, refer to [CONTRIBUTING.md](CONTRIBUTING.md)

Pick one up whenever suits you. A maintainer reads the PR, runs the build and merges it. Open
issues are labelled by route if you would rather take one than invent something.

`AGENTS.md` at the root holds the conventions, the seed data rules, and a table pointing at the
procedure for each route. Most AI coding tools read it on their own. If yours does not, point it
there. Some will also pick up the four routes in `.claude/skills/` as slash commands, though you
do not need them: this is enough.

> *"Add a product to the Jaffleverse seed data, something passive aggressive for the Aggressive
> Comfort division."*

Your assistant will pick a free ID in the reserved range, resolve the foreign keys, match the
tone of the catalogue and keep to the no real people rule, because all of that is written down
where it can read it.

---

## What's in the package

**Eleven source tables**, one clean star. Everything is one hop from `jaffle_order`, with no
bridge tables and no many to many. If you can read a CSV, you can read this schema.

```
jaffle_division ──< jaffle_product_category ──< jaffle_product >── jaffle_supplier
                                                      │
jaffle_customer ──┐                                   │
jaffle_employee ──┼──< jaffle_order ──< jaffle_order_item
jaffle_promotion ─┘         │  │
                            │  └──< jaffle_payment
                            └─────< jaffle_review
```

**Staging models and a Mart layer**

| Layer | Shipped | Deliberately missing |
|---|---|---|
| Staging | all 11 source tables | tests on 10 of them |
| Intermediate | `int_jaffleverse__order_items_enriched` | |
| Marts | `jaffleverse__orders`, `jaffleverse__customers`, `jaffleverse__products` | divisions, employees, suppliers, daily sales, cohorts, promotion effectiveness |
| Macros | `jaffleverse_segment_rank` | almost everything |

---

## Maintenance

This is a demo package, not a production data model. It is not on the dbt Package Hub and does
not currently aim to be.

## Resources

- [What is a dbt package?](https://docs.getdbt.com/docs/build/packages)
- [Building your own package](https://docs.getdbt.com/guides/building-packages)
- [The dbt Package Hub](https://hub.getdbt.com/)
- [dbt Community Slack](https://www.getdbt.com/community/). Say hi in `#package-ecosystem`
