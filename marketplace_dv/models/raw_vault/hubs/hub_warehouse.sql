{{ config(materialized='incremental') }}

{%- set source_model = "v_stg_warehouses" -%}
{%- set src_pk = "HUB_WAREHOUSE_HK" -%}
{%- set src_nk = "HUB_WAREHOUSE_BK" -%}
{%- set src_ldts = "LOAD_DTS" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.hub(
    src_pk=src_pk,
    src_nk=src_nk,
    src_ldts=src_ldts,
    src_source=src_source,
    source_model=source_model
) }}