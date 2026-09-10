with source as (

    select * from {{ source('jaffleverse', 'jaffle_order') }}

),

renamed as (

    select
        order_id,
        customer_id,
        employee_id,
        promotion_id,
        cast(ordered_at as {{ dbt.type_timestamp() }}) as ordered_at,
        cast(ordered_at as date) as ordered_date,
        order_status,
        channel as order_channel,
        shipping_country as shipping_country_code,
        case when order_status in ('completed', 'shipped') then true else false end as is_fulfilled_order

    from source

)

select * from renamed
