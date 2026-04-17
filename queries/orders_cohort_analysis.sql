with first_order as (
    select
        orders.user_external_id,
        date_trunc('month', min(orders.order_date)) as cohort_month
    from orders
    group by user_external_id
),

next_order as (
    select
        first_order.user_external_id,
        first_order.cohort_month,
        date_trunc('month', orders.order_date) as order_month,
        extract(month from age(orders.order_date, first_order.cohort_month)) as month_diff,
        orders.total_amount
    from first_order
    join orders
    on first_order.user_external_id = orders.user_external_id
),

no_in_halfyear as (
    select *
    from next_order
    where month_diff between 0 and 5
),

ch_sizes as (
    select
        first_order.cohort_month,
        count(*) as cohort_size
    from first_order
    group by cohort_month
),

half_year_rt as (
    select
        no_in_halfyear.cohort_month,
        sum(no_in_halfyear.total_amount) as total_cohort_revenue,
        count(distinct case when no_in_halfyear.month_diff = 0 then user_external_id end) as period_0_count,
        count(distinct case when no_in_halfyear.month_diff = 1 then user_external_id end) as period_1_count,
        count(distinct case when no_in_halfyear.month_diff = 2 then user_external_id end) as period_2_count,
        count(distinct case when no_in_halfyear.month_diff = 3 then user_external_id end) as period_3_count,
        count(distinct case when no_in_halfyear.month_diff = 4 then user_external_id end) as period_4_count,
        count(distinct case when no_in_halfyear.month_diff = 5 then user_external_id end) as period_5_count
    from no_in_halfyear
    group by cohort_month
)

select
    ch_sizes.cohort_month,
    ch_sizes.cohort_size,
    cast(coalesce(hrt.period_0_count, 0) as numeric) / nullif(cohort_size, 0) * 100 as period_0_pct,
    cast(coalesce(hrt.period_1_count, 0) as numeric) / nullif(cohort_size, 0) * 100 as period_1_pct,
    cast(coalesce(hrt.period_2_count, 0) as numeric) / nullif(cohort_size, 0) * 100 as period_2_pct,
    cast(coalesce(hrt.period_3_count, 0) as numeric) / nullif(cohort_size, 0) * 100 as period_3_pct,
    cast(coalesce(hrt.period_4_count, 0) as numeric) / nullif(cohort_size, 0) * 100 as period_4_pct,
    cast(coalesce(hrt.period_5_count, 0) as numeric) / nullif(cohort_size, 0) * 100 as period_5_pct,
    coalesce(hrt.total_cohort_revenue, 0) as total_cohort_revenue,
    coalesce(hrt.total_cohort_revenue, 0) / nullif(ch_sizes.cohort_size,0) as avg_revenue_per_customer
from ch_sizes
left join half_year_rt as hrt on ch_sizes.cohort_month = hrt.cohort_month
order by ch_sizes.cohort_month desc;