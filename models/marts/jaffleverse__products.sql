with products as (

    select * from {{ ref('stg_jaffleverse__products') }}

),

categories as (

    select * from {{ ref('stg_jaffleverse__product_categories') }}

),

divisions as (

    select * from {{ ref('stg_jaffleverse__divisions') }}

),

suppliers as (

    select * from {{ ref('stg_jaffleverse__suppliers') }}

),

order_items as (

    select * from {{ ref('int_jaffleverse__order_items_enriched') }}

),

{% if var('jaffleverse_using_reviews', True) %}
reviews as (

    select * from {{ ref('stg_jaffleverse__reviews') }}

),

review_totals as (

    select
        product_id,
        count(*) as review_count,
        avg(cast(rating as {{ dbt.type_float() }})) as average_rating

    from reviews
    group by 1

),
{% endif %}

sales_totals as (

    select
        product_id,
        count(distinct order_id) as order_count,
        sum(quantity) as units_sold,
        sum(line_item_amount) as total_net_revenue,
        sum(line_item_margin) as total_margin

    from order_items
    group by 1

),

final as (

    select
        products.product_id,
        products.product_name,
        products.product_description,
        products.category_id,
        categories.category_name,
        divisions.division_id,
        divisions.division_name,
        products.supplier_id,
        suppliers.supplier_name,
        suppliers.lead_time_days,
        products.list_price,
        products.unit_cost,
        products.list_price - products.unit_cost as unit_margin,
        products.is_active_product,
        products.launched_date,
        products.discontinued_date,
        coalesce(sales_totals.order_count, 0) as order_count,
        coalesce(sales_totals.units_sold, 0) as units_sold,
        coalesce(sales_totals.total_net_revenue, 0) as total_net_revenue,
        coalesce(sales_totals.total_margin, 0) as total_margin
        {%- if var('jaffleverse_using_reviews', True) %},
        coalesce(review_totals.review_count, 0) as review_count,
        review_totals.average_rating
        {%- endif %}

    from products
    left join categories
        on products.category_id = categories.category_id
    left join divisions
        on categories.division_id = divisions.division_id
    left join suppliers
        on products.supplier_id = suppliers.supplier_id
    left join sales_totals
        on products.product_id = sales_totals.product_id
    {%- if var('jaffleverse_using_reviews', True) %}
    left join review_totals
        on products.product_id = review_totals.product_id
    {%- endif %}

)

select * from final
