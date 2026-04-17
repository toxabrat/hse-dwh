{{ config(materialized='incremental') }}

{%- set source_model = "v_stg_products" -%}
{%- set src_pk = "HUB_PRODUCT_HK" -%}
{%- set src_nk = "HUB_PRODUCT_BK" -%}
{%- set src_ldts = "LOAD_DTS" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.hub(
    src_pk=src_pk,
    src_nk=src_nk,
    src_ldts=src_ldts,
    src_source=src_source,
    source_model=source_model
) }}