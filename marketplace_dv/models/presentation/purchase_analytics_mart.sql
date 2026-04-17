{{
    config(
        materialized='table',
        tags=['presentation', 'mart_purchases']
    )
}}

with orders as (
    select
        order_external_id,
        TO_TIMESTAMP(order_date / 1000000)::date as purchase_date,
        user_external_id,
        total_amount
    from {{ source('raw_data', 'orders') }}
    where is_current is true
),

order_items as (
    select
        order_external_id,
        product_sku,
        quantity,
        total_price
    from {{ source('raw_data', 'order_items') }}
),

products as (
    select
        product_sku,
        product_id,
        product_name,
        category,
        brand
    from {{ source('raw_data', 'products') }}
    where is_current is true
),

agg as (
    select
        o.purchase_date,
        p.product_id,
        p.product_name,
        p.category,
        p.brand,
        sum(oi.quantity)::numeric as purchase_qty,
        sum(oi.total_price)::numeric as total_purchase_amount
    from orders o
    inner join order_items oi on o.order_external_id = oi.order_external_id
    inner join products p on oi.product_sku = p.product_sku
    group by
        o.purchase_date,
        p.product_id,
        p.product_name,
        p.category,
        p.brand
)

select
    purchase_date,
    product_id,
    product_name::text,
    category::text,
    abs(hashtext(coalesce(brand, 'Unknown')))::int as supplier_id,
    coalesce(brand, 'Unknown')::text as supplier_name,
    purchase_qty,
    total_purchase_amount,
    (total_purchase_amount / nullif(purchase_qty, 0))::numeric as avg_unit_price
from agg
order by purchase_date desc, product_id
