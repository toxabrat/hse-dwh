{%- set yaml_metadata -%}
source_model:
  external_orders: 'order_items'
derived_columns:
    RECORD_SOURCE: 'created_by'
    LOAD_DTS: '!{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'
    EFFECTIVE_FROM: 'created_at'
    SAT_ORDER_ITEM_ID_BK: 'order_item_id'
hashed_columns:
    HUB_ORDER_HK: 'order_external_id'
    HUB_PRODUCT_HK: 'product_sku'

    LINK_ORDER_PRODUCT_HK:
        - 'product_sku'
        - 'order_external_id'

    SAT_LINK_ORDER_ITEM_PRODUCT_HDF:
        is_hashdiff: true
        columns:
            - 'quantity'
            - 'unit_price'
            - 'total_price'
            - 'product_name_snapshot'
            - 'product_category_snapshot'
            - 'product_brand_snapshot'
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