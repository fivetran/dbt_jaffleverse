# The Jaffleverse Holdings dataset

Eleven CSVs that stand in for the raw tables a data warehouse would sync from Jaffleverse
Holdings, a company that began as a toastie shop and became, through a series of decisions
nobody has fully reconstructed, a conglomerate.

**This is where the seed-data adventure route happens.** Add a product, a customer, an order,
whatever you like. The only hard rules are the three below.

---

## The three rules

1. **Use an ID between 9000 and 9999.** Every table reserves that range for community
   contributions, so no two contributors end up with the same ID.
2. **Append to the end of the file.** Never edit or reorder existing rows.
3. **Leave a trailing newline.** Your last line should end with a line break, or the next
   contributor's row will land on top of yours.

### The naming rule: no real people, no personal data

Every person in this dataset is a **public-domain fictional character**. If you add a customer or an employee, 
add a fictional character too. Dickens, Austen, Shakespeare, Brontë, Verne, Doyle, Greek myth and folklore are all fair game.

**Do not use a real person's name**, including your own, a colleague's, or a friend's. And there
are deliberately **no email, phone or address columns** in this dataset. Do not add any. This is
a public repo and none of it should look even slightly like real personal data.

Keep it weird, keep it kind. This is a public repo, so anything you would not want read aloud to
a room of strangers does not belong here.

---

## How the tables fit together

Everything is one hop from `jaffle_order`. There are no bridge tables and no many-to-many
relationships. If you can read a CSV, you can read this schema.

```
jaffle_division ──< jaffle_product_category ──< jaffle_product >── jaffle_supplier
                                                      │
jaffle_customer ──┐                                   │
jaffle_employee ──┼──< jaffle_order ──< jaffle_order_item
jaffle_promotion ─┘         │  │
                            │  └──< jaffle_payment
                            └─────< jaffle_review
```

---

## Table reference

Foreign keys are marked `→`. Columns marked **required** must be populated; everything else can
be left empty.

### `jaffle_division`: the business units
Grain: one row per division. Baseline IDs `1`–`5`.

| Column | Notes |
|---|---|
| `division_id` | **required**, unique |
| `division_name` | **required** |
| `headquarters_city`, `country` | ISO-2 country code |
| `founded_at` | `YYYY-MM-DD` |
| `is_active` | `true` / `false` |

### `jaffle_product_category`: what kind of thing it is
Grain: one row per category. Baseline IDs `101`–`503`.

| Column | Notes |
|---|---|
| `category_id` | **required**, unique |
| `division_id` | **required** → `jaffle_division` |
| `category_name` | **required** |
| `is_active` | `true` / `false` |

### `jaffle_product`: the catalogue
Grain: one row per product. Baseline IDs `1001`–`1060`.

| Column | Notes |
|---|---|
| `product_id` | **required**, unique |
| `category_id` | **required** → `jaffle_product_category` |
| `supplier_id` | **required** → `jaffle_supplier` |
| `product_name` | **required** |
| `description` | quote it if it contains a comma |
| `list_price`, `unit_cost` | decimals. `list_price` below `unit_cost` is allowed and funny |
| `is_active` | `true` / `false` |
| `launched_at`, `discontinued_at` | `YYYY-MM-DD`, `discontinued_at` may be empty |

### `jaffle_supplier`: who makes it
Grain: one row per supplier. Baseline IDs `1`–`10`.

| Column | Notes |
|---|---|
| `supplier_id` | **required**, unique |
| `supplier_name` | **required** |
| `country` | ISO-2 |
| `lead_time_days` | integer. Ours range from 1 to 400 |
| `reliability_score` | 0.0–1.0 |
| `is_preferred` | `true` / `false` |

### `jaffle_customer`: who buys it
Grain: one row per customer. Baseline IDs `2000`–`2079`.

| Column | Notes |
|---|---|
| `customer_id` | **required**, unique |
| `first_name`, `last_name` | **required**, must be a fictional character; see the naming rule |
| `country` | ISO-2 |
| `signup_date` | `YYYY-MM-DD` |
| `customer_segment` | one of `consumer`, `small_business`, `enterprise`, `reseller` |
| `marketing_opt_in` | `true` / `false` |

There is deliberately **no email column**, and no phone or address column either. Please do not
add one.

### `jaffle_employee`: who sold it
Grain: one row per employee. Baseline IDs `500`–`524`.

| Column | Notes |
|---|---|
| `employee_id` | **required**, unique |
| `division_id` | **required** → `jaffle_division` |
| `first_name`, `last_name` | **required**, must be a fictional character; see the naming rule |
| `role` | **required**, the more absurd the better |
| `hired_at`, `terminated_at` | `YYYY-MM-DD`, `terminated_at` may be empty |
| `manager_employee_id` | → `jaffle_employee`, may be empty |

### `jaffle_promotion`: the discount codes
Grain: one row per promotion. Baseline IDs `301`–`315`.

| Column | Notes |
|---|---|
| `promotion_id` | **required**, unique |
| `promotion_code` | **required**, uppercase by convention |
| `description` | |
| `discount_type` | `percentage` or `fixed` |
| `discount_value` | percent (e.g. `10.0`) or currency amount |
| `starts_at`, `ends_at` | `YYYY-MM-DD` |

### `jaffle_order`: the order header
Grain: one row per order. Baseline IDs `7001`–`7350`.

| Column | Notes |
|---|---|
| `order_id` | **required**, unique |
| `customer_id` | **required** → `jaffle_customer` |
| `employee_id` | **required** → `jaffle_employee` |
| `promotion_id` | → `jaffle_promotion`, may be empty |
| `ordered_at` | **required**, `YYYY-MM-DD HH:MM:SS` |
| `order_status` | one of `completed`, `shipped`, `pending`, `cancelled`, `returned` |
| `channel` | one of `web`, `retail`, `phone`, `marketplace`, `carrier_pigeon` |
| `shipping_country` | ISO-2 |

### `jaffle_order_item`: the line items
Grain: one row per product per order. Baseline IDs `60001`–`60836`.

| Column | Notes |
|---|---|
| `order_item_id` | **required**, unique |
| `order_id` | **required** → `jaffle_order` |
| `product_id` | **required** → `jaffle_product` |
| `quantity` | integer |
| `unit_price` | decimal, usually the product's `list_price` |
| `discount_amount` | decimal, `0.0` if none |

### `jaffle_payment`: the money
Grain: one row per payment. Baseline IDs `40001`–`40329`.

| Column | Notes |
|---|---|
| `payment_id` | **required**, unique |
| `order_id` | **required** → `jaffle_order` |
| `payment_method` | one of `card`, `bank_transfer`, `cash`, `voucher`, `barter` |
| `amount` | decimal |
| `paid_at` | `YYYY-MM-DD HH:MM:SS` |
| `status` | `succeeded` or `refunded` |

### `jaffle_review`: what people thought
Grain: one row per review. Baseline IDs `30001`–`30074`.

| Column | Notes |
|---|---|
| `review_id` | **required**, unique |
| `product_id` | **required** → `jaffle_product` |
| `customer_id` | **required** → `jaffle_customer` |
| `order_id` | → `jaffle_order` |
| `rating` | integer 1–5 |
| `review_text` | quote it if it contains a comma |
| `submitted_at` | `YYYY-MM-DD HH:MM:SS` |
