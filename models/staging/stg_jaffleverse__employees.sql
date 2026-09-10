with source as (

    select * from {{ source('jaffleverse', 'jaffle_employee') }}

),

renamed as (

    select
        employee_id,
        division_id,
        manager_employee_id,
        first_name,
        last_name,
        {{ dbt.concat(['first_name', "' '", 'last_name']) }} as full_name,
        role as job_title,
        cast(hired_at as date) as hired_date,
        cast(terminated_at as date) as terminated_date,
        case when terminated_at is null then true else false end as is_current_employee

    from source

)

select * from renamed
