{{ config(materialized='incremental') }}

{%- set source_model = "v_stg_shipment_movements" -%}
{%- set src_pk = "HUB_SHIPMENT_HK" -%}
{%- set src_cdk = "SAT_SHIPMENT_MOVEMENT_BK" -%}
{%- set src_hashdiff = "SAT_SHIPMENT_MOVEMENT_HDF" -%}

{%- set yaml_metadata -%}
src_payload:
    - 'movement_type'
    - 'movement_datetime'
    - 'location_type'
    - 'location_code'
    - 'operator_name'
    - 'latitude'
    - 'longitude'
    - 'created_at'
    - 'created_by'
{%- endset -%}
{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set src_payload = metadata_dict['src_payload'] %}

{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DTS" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.ma_sat(
    src_pk=src_pk,
    src_cdk=src_cdk,
    src_hashdiff=src_hashdiff,
    src_payload=src_payload,
    src_eff=src_eff,
    src_ldts=src_ldts,
    src_source=src_source,
    source_model=source_model)
}}