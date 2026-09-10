with source as (

    select * from {{ source('jaffleverse', 'jaffle_order_item') }}

),

renamed as (

    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        cast(unit_price as {{ dbt.type_numeric() }}) as unit_price,
        cast(discount_amount as {{ dbt.type_numeric() }}) as discount_amount,
        cast(quantity * unit_price - discount_amount as {{ dbt.type_numeric() }}) as line_item_amount

    from source

)

select * from renamed
