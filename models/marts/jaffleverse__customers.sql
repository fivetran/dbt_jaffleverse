with customers as (

    select * from {{ ref('stg_jaffleverse__customers') }}

),

orders as (

    select * from {{ ref('jaffleverse__orders') }}

),

order_totals as (

    select
        customer_id,
        count(*) as order_count,
        sum(case when is_fulfilled_order then 1 else 0 end) as fulfilled_order_count,
        min(ordered_date) as first_order_date,
        max(ordered_date) as most_recent_order_date,
        sum(net_item_amount) as lifetime_net_amount,
        sum(total_item_margin) as lifetime_margin,
        sum(total_paid_amount) as lifetime_paid_amount

    from orders
    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.full_name,
        customers.country_code,
        customers.signup_date,
        customers.customer_segment,
        {{ jaffleverse_segment_rank('customers.customer_segment') }} as customer_segment_rank,
        customers.is_marketing_opted_in,
        coalesce(order_totals.order_count, 0) as order_count,
        coalesce(order_totals.fulfilled_order_count, 0) as fulfilled_order_count,
        order_totals.first_order_date,
        order_totals.most_recent_order_date,
        {{ dbt.datediff('order_totals.most_recent_order_date', 'cast(' ~ dbt.current_timestamp() ~ ' as date)', 'day') }} as days_since_last_order,
        coalesce(order_totals.lifetime_net_amount, 0) as lifetime_net_amount,
        coalesce(order_totals.lifetime_margin, 0) as lifetime_margin,
        coalesce(order_totals.lifetime_paid_amount, 0) as lifetime_paid_amount,
        case
            when coalesce(order_totals.order_count, 0) = 0 then 0
            else order_totals.lifetime_net_amount / order_totals.order_count
        end as average_order_value

    from customers
    left join order_totals
        on customers.customer_id = order_totals.customer_id

)

select * from final
