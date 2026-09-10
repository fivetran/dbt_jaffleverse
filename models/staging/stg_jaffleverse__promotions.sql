{{ config(enabled=var('jaffleverse_using_promotions', True)) }}

with source as (

    select * from {{ source('jaffleverse', 'jaffle_promotion') }}

),

renamed as (

    select
        promotion_id,
        promotion_code,
        description as promotion_description,
        discount_type,
        cast(discount_value as {{ dbt.type_numeric() }}) as discount_value,
        cast(starts_at as date) as starts_date,
        cast(ends_at as date) as ends_date

    from source

)

select * from renamed
