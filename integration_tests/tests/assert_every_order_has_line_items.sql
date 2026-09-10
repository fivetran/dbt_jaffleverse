-- An order with no line items means the header and the basket got out of sync
-- somewhere upstream. Returns any offending order; an empty result passes.

with orders as (

    select * from {{ ref('jaffleverse__orders') }}

)

select
    order_id,
    order_status,
    order_item_count

from orders
where order_item_count = 0
