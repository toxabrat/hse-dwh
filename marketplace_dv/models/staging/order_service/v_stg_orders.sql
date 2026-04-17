{%- set yaml_metadata -%}
source_model:
  external_orders: 'orders'
derived_columns:
    RECORD_SOURCE: 'created_by'
    LOAD_DTS: 'effective_from'
    EFFECTIVE_FROM: 'created_at'
    HUB_ORDER_BK: 'order_external_id'
hashed_columns:
    HUB_ORDER_HK: 'order_external_id'
    HUB_USER_ADDRESS_HK: 'delivery_address_external_id'
    HUB_USER_HK: 'user_external_id'

    LINK_ORDER_USER_ADDRESS_HK:
        - 'order_external_id'
        - 'delivery_address_external_id'
    LINK_ORDER_USER_HK:
        - 'order_external_id'
        - 'user_external_id'

    SAT_ORDER_MONEY_HDF:
        is_hashdiff: true
        columns:
            - 'subtotal'
            - 'tax_amount'
            - 'shipping_cost'
            - 'discount_amount'
            - 'total_amount'
            - 'currency'

    SAT_TRACKING_HDF:
        is_hashdiff: true
        columns:
            - 'order_number'
            - 'delivery_type'
            - 'payment_method'
            - 'payment_status'

    SAT_DATEINFO_HDF:
        is_hashdiff: true
        columns:
            - 'order_date'
            - 'expected_delivery_date'
            - 'actual_delivery_date'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set source_model = metadata_dict['source_model'] %}
{% set dc = metadata_dict['derived_columns'] %}
{% set hc = metadata_dict['hashed_columns'] %}

with staging as (
    {{ automate_dv.stage(
        include_source_columns=true,
        source_model=source_model,
        derived_columns=dc,
        hashed_columns=hc
    )}}
)

select * from staging