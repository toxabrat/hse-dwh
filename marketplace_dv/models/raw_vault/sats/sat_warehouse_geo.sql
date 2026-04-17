{{ config(materialized='incremental') }}

{%- set source_model = "v_stg_warehouses" -%}
{%- set src_pk = "HUB_WAREHOUSE_HK" -%}
{%- set src_hashdiff = "SAT_WAREHOUSE_GEO_HDF" -%}

{%- set yaml_metadata -%}
src_payload:
    - 'country'
    - 'region'
    - 'city'
    - 'street_address'
    - 'postal_code'
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