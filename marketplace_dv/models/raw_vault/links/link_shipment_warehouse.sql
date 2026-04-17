{{ config(materialized='incremental') }}

{%- set source_model = "v_stg_shipments" -%}
{%- set src_pk = "LINK_SHIPMENT_WAREHOUSE_HK" -%}
{%- set src_fk = ["HUB_WAREHOUSE_HK", "HUB_SHIPMENT_HK"] -%}
{%- set src_ldts = "LOAD_DTS" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.link(
    src_pk=src_pk,
    src_fk=src_fk,
    src_ldts=src_ldts,
    src_source=src_source,
    source_model=source_model)
}}