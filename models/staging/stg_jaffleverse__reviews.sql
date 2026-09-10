{{ config(enabled=var('jaffleverse_using_reviews', True)) }}

with source as (

    select * from {{ source('jaffleverse', 'jaffle_review') }}

),

renamed as (

    select
        review_id,
        product_id,
        customer_id,
        order_id,
        rating,
        review_text,
        cast(submitted_at as {{ dbt.type_timestamp() }}) as submitted_at

    from source

)

select * from renamed
