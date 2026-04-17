{{ config(materialized='incremental') }}

{%- set source_model = "v_stg_order_items" -%}
{%- set src_pk = "LINK_ORDER_PRODUCT_HK" -%}
{%- set src_hashdiff = "SAT_LINK_ORDER_ITEM_PRODUCT_HDF" -%}

{%- set yaml_metadata -%}
src_payload:
    - 'HUB_ORDER_HK'
    - 'HUB_PRODUCT_HK'
    - 'quantity'
    - 'unit_price'
    - 'total_price'
    - 'product_name_snapshot'
    - 'product_category_snapshot'
    - 'product_brand_snapshot'
{%- endset -%}
{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set src_payload = metadata_dict['src_payload'] %}

{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DTS" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(
    src_pk=src_pk,
    src_hashdiff=src_hashdiff,
    src_payload=src_payload,
    src_eff=src_eff,
    src_ldts=src_ldts,
    src_source=src_source,
    source_model=source_model)
}}