{%- set yaml_metadata -%}
source_model:
  external_orders: 'order_status_history'
derived_columns:
    RECORD_SOURCE: 'changed_by'
    LOAD_DTS: '!{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'
    EFFECTIVE_FROM: 'changed_at'
    SAT_ORDER_STATUS_HISTORY_BK: 'history_id'
hashed_columns:
    HUB_ORDER_HK: 'order_external_id'

    SAT_ORDER_STATUS_HDF:
        is_hashdiff: true
        columns:
            - 'old_status'
            - 'new_status'
            - 'change_reason'
            - 'session_id'
            - 'ip_address'
            - 'notes'
            - 'changed_by'
            - 'changed_at'
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