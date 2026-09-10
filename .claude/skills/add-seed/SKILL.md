---
name: add-seed
description: Add seed data to the Jaffleverse dbt package, such as a product, customer, order, supplier, review or employee. Use when a contributor wants to add data, invent a product, or take the seed-data contribution route.
---

Help the user add seed data to `integration_tests/seeds/`.

**Never run `dbt build` yourself unless they ask.** Whether and when to build is their call.

## 1. Read the rules first

Read `integration_tests/seeds/README.md` for the table reference, foreign keys, and the ID
convention. Do not skip this. It is what keeps contributions valid.

## 2. Ask what they want to add

If they have not said, offer: a product (easiest), a customer, a complete order, a supplier,
a review, a promotion, an employee.

## 3. Ask them to direct it: you do the writing

**You write the row. They decide what it is.** Do not ask whether they want to type it
themselves; ask what they want it to be, and meet them at whatever level of detail they offer:

> **What should it be?** As much or as little as you like:
> - **a fully-formed idea**: "a Left-Handed Mouse Mat, only works from one side, about £30"
> - **just a direction**: "something passive-aggressive", "something for Temporal Goods",
>   "something that shouldn't be legal to sell"
> - **nothing yet**: I'll pitch you three and you pick, veto, or mix them

If they give you a direction rather than a thing, pitch **three** options in one go, each a
single line, in the deadpan register of the existing catalogue. The range runs from *Noise Cancelling
Plant*, *Emotional Support Brick*, *Decaf Espresso (Regular Strength)*, *Calendar With No
Tuesdays*. Let them pick, mix, or reject all three and send you back for more.

If they hand you something fully formed, **take it exactly as given, however strange**. Do not
sand the edges off to make it more sensible, do not tidy the name, do not talk them down on
price. Your job is formatting and foreign keys, not editorial. If their product costs £4,000
and is called *Screaming Tuesday*, that is a good contribution.

Encourage the strange option over the safe one throughout. A conglomerate this incoherent has
no house style to protect.

## 4. Hard rules: non-negotiable

- Every customer and employee must be a **public-domain fictional character**. Never a real
  person's name, not theirs, not a colleague's, not anyone's.
- There are **no email, phone or address columns**. Never add one. If asked, explain why: this
  is a public repo and a realistic contact field invites people to paste in their own.
- Pick an unused ID in the **9000–9999** range by checking the existing file.
- Append to the **end** of the file. Never touch existing rows. Preserve the trailing newline.
- Quote any field containing a comma.
- Verify every foreign key you used exists in its parent CSV. Actually check, do not assume.

## 5. Hand it back, do not build

Tell them what you changed and which file. Then offer, without pressure:

> That is ready. You can open the PR as-is and a maintainer will build it. If you would rather see
> it work first, run `cd integration_tests && dbt seed && dbt build`, or say the word and I will run it.

If they ask you to build, run it and report the real result, including failures. Never claim it
builds unless you have actually run it.
