with source as (

    select * from {{ source('jaffleverse', 'jaffle_customer') }}

),

renamed as (

    select
        customer_id,
        first_name,
        last_name,
        {{ dbt.concat(['first_name', "' '", 'last_name']) }} as full_name,
        country as country_code,
        cast(signup_date as date) as signup_date,
        customer_segment,
        marketing_opt_in as is_marketing_opted_in

    from source

)

select * from renamed
