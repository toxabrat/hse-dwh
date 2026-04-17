{{
    config(
        materialized='incremental',
        unique_key=['shipment_date', 'warehouse_id'],
        incremental_strategy='delete+insert',
        tags=['presentation', 'mart_warehouse']
    )
}}

with shipments as (
    select
        shipment_external_id,
        order_external_id,
        origin_warehouse_code,
        dispatched_date,
        estimated_delivery_date,
        actual_delivery_date
    from {{ source('raw_data', 'shipments') }}
    where is_current is true
),

shipments_per_order as (
    select
        order_external_id,
        count(*)::numeric as shipment_cnt
    from shipments
    where dispatched_date is not null
    group by order_external_id
),

order_totals as (
    select
        order_external_id,
        sum(quantity)::numeric as total_order_qty
    from {{ source('raw_data', 'order_items') }}
    group by order_external_id
),

orders as (
    select
        order_external_id,
        user_external_id,
        order_date
    from {{ source('raw_data', 'orders') }}
    where is_current is true
),

warehouses as (
    select
        warehouse_code,
        warehouse_id,
        warehouse_name
    from {{ source('raw_data', 'warehouses') }}
    where is_current is true
)

select
    TO_TIMESTAMP(s.dispatched_date / 1000000)::date as shipment_date,
    w.warehouse_id,
    w.warehouse_name::text,
    count(distinct s.order_external_id)::int as order_count,
    sum(ot.total_order_qty / nullif(spo.shipment_cnt, 0))::numeric as total_shipment_qty,
    avg(
        extract(epoch from (
            TO_TIMESTAMP(s.dispatched_date / 1000000) - TO_TIMESTAMP(o.order_date / 1000000)
        )) / 60.0
    )::numeric as avg_processing_time_min,
    count(
        distinct case
            when
                s.actual_delivery_date is not null
                and s.actual_delivery_date > s.estimated_delivery_date
                then s.order_external_id
        end
    )::int as delayed_orders_count,
    count(distinct o.user_external_id)::int as unique_customers_count
from shipments s
inner join orders o on s.order_external_id = o.order_external_id
inner join order_totals ot on s.order_external_id = ot.order_external_id
inner join shipments_per_order spo on s.order_external_id = spo.order_external_id
inner join warehouses w on s.origin_warehouse_code = w.warehouse_code
where s.dispatched_date is not null

{% if is_incremental() %}
    and TO_TIMESTAMP(s.dispatched_date / 1000000)::date = '{{ get_mart_target_date() }}'::date
{% endif %}

group by
    TO_TIMESTAMP(s.dispatched_date / 1000000)::date,
    w.warehouse_id,
    w.warehouse_name
order by shipment_date desc, w.warehouse_id
