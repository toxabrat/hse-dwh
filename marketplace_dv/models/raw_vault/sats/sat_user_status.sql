{{ config(materialized='incremental') }}

{%- set source_model = "v_stg_user_status" -%}
{%- set src_pk = "HUB_USER_HK" -%}
{%- set src_cdk = "SAT_USER_STATUS_BK" -%}
{%- set src_hashdiff = "SAT_USER_STATUS_HDF" -%}

{%- set yaml_metadata -%}
src_payload:
    - 'old_status'
    - 'new_status'
    - 'change_reason'
    - 'changed_by'
    - 'session_id'
    - 'changed_at'
    - 'ip_address'
    - 'user_agent'
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