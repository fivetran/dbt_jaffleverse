with source as (

    select * from {{ source('jaffleverse', 'jaffle_product') }}

),

renamed as (

    select
        product_id,
        category_id,
        supplier_id,
        product_name,
        description as product_description,
        cast(list_price as {{ dbt.type_numeric() }}) as list_price,
        cast(unit_cost as {{ dbt.type_numeric() }}) as unit_cost,
        is_active as is_active_product,
        cast(launched_at as date) as launched_date,
        cast(discontinued_at as date) as discontinued_date

    from source

)

select * from renamed
