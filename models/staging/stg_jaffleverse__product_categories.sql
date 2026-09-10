with source as (

    select * from {{ source('jaffleverse', 'jaffle_product_category') }}

),

renamed as (

    select
        category_id,
        division_id,
        category_name,
        is_active as is_active_category

    from source

)

select * from renamed
