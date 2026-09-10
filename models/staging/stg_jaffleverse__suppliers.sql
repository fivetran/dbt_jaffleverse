with source as (

    select * from {{ source('jaffleverse', 'jaffle_supplier') }}

),

renamed as (

    select
        supplier_id,
        supplier_name,
        country as country_code,
        lead_time_days,
        cast(reliability_score as {{ dbt.type_float() }}) as reliability_score,
        is_preferred as is_preferred_supplier

    from source

)

select * from renamed
