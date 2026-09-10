with orders as (

    select * from {{ ref('stg_jaffleverse__orders') }}

),

customers as (

    select * from {{ ref('stg_jaffleverse__customers') }}

),

employees as (

    select * from {{ ref('stg_jaffleverse__employees') }}

),

order_items as (

    select * from {{ ref('int_jaffleverse__order_items_enriched') }}

),

payments as (

    select * from {{ ref('stg_jaffleverse__payments') }}

),

{% if var('jaffleverse_using_promotions', True) %}
promotions as (

    select * from {{ ref('stg_jaffleverse__promotions') }}

),
{% endif %}

item_totals as (

    select
        order_id,
        count(*) as order_item_count,
        sum(quantity) as total_quantity,
        sum(line_item_amount) as net_item_amount,
        sum(discount_amount) as total_discount_amount,
        sum(line_item_cost) as total_item_cost,
        sum(line_item_margin) as total_item_margin

    from order_items
    group by 1

),

payment_totals as (

    select
        order_id,
        count(*) as payment_count,
        sum(payment_amount) as total_paid_amount,
        max(case when is_refunded_payment then 1 else 0 end) as refunded_flag

    from payments
    group by 1

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.employee_id,
        orders.promotion_id,
        orders.ordered_at,
        orders.ordered_date,
        orders.order_status,
        orders.order_channel,
        orders.shipping_country_code,
        orders.is_fulfilled_order,
        customers.full_name as customer_name,
        customers.customer_segment,
        employees.full_name as employee_name,
        employees.job_title as employee_job_title,
        {% if var('jaffleverse_using_promotions', True) -%}
        promotions.promotion_code,
        promotions.discount_type as promotion_discount_type,
        {%- endif %}
        coalesce(item_totals.order_item_count, 0) as order_item_count,
        coalesce(item_totals.total_quantity, 0) as total_quantity,
        coalesce(item_totals.net_item_amount, 0) as net_item_amount,
        coalesce(item_totals.total_discount_amount, 0) as total_discount_amount,
        coalesce(item_totals.total_item_cost, 0) as total_item_cost,
        coalesce(item_totals.total_item_margin, 0) as total_item_margin,
        coalesce(payment_totals.payment_count, 0) as payment_count,
        coalesce(payment_totals.total_paid_amount, 0) as total_paid_amount,
        case when coalesce(payment_totals.refunded_flag, 0) = 1 then true else false end as is_refunded_order,
        case when payment_totals.order_id is null then false else true end as has_payment

    from orders
    left join customers
        on orders.customer_id = customers.customer_id
    left join employees
        on orders.employee_id = employees.employee_id
    {% if var('jaffleverse_using_promotions', True) -%}
    left join promotions
        on orders.promotion_id = promotions.promotion_id
    {%- endif %}
    left join item_totals
        on orders.order_id = item_totals.order_id
    left join payment_totals
        on orders.order_id = payment_totals.order_id

)

select * from final
