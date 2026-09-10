with source as (

    select * from {{ source('jaffleverse', 'jaffle_payment') }}

),

renamed as (

    select
        payment_id,
        order_id,
        payment_method,
        cast(amount as {{ dbt.type_numeric() }}) as payment_amount,
        cast(paid_at as {{ dbt.type_timestamp() }}) as paid_at,
        status as payment_status,
        case when status = 'refunded' then true else false end as is_refunded_payment

    from source

)

select * from renamed
