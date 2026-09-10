with order_items as (

    select * from {{ ref('stg_jaffleverse__order_items') }}

),

products as (

    select * from {{ ref('stg_jaffleverse__products') }}

),

orders as (

    select * from {{ ref('stg_jaffleverse__orders') }}

),

joined as (

    select
        order_items.order_item_id,
        order_items.order_id,
        order_items.product_id,
        orders.customer_id,
        orders.ordered_at,
        orders.ordered_date,
        orders.order_status,
        orders.is_fulfilled_order,
        products.category_id,
        products.product_name,
        order_items.quantity,
        order_items.unit_price,
        order_items.discount_amount,
        order_items.line_item_amount,
        cast(order_items.quantity * products.unit_cost as {{ dbt.type_numeric() }}) as line_item_cost,
        order_items.line_item_amount
            - cast(order_items.quantity * products.unit_cost as {{ dbt.type_numeric() }}) as line_item_margin

    from order_items
    inner join orders
        on order_items.order_id = orders.order_id
    inner join products
        on order_items.product_id = products.product_id

)

select * from joined
