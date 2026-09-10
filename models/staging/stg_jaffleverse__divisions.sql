with source as (

    select * from {{ source('jaffleverse', 'jaffle_division') }}

),

renamed as (

    select
        division_id,
        division_name,
        headquarters_city,
        country as country_code,
        cast(founded_at as date) as founded_date,
        is_active as is_active_division

    from source

)

select * from renamed
