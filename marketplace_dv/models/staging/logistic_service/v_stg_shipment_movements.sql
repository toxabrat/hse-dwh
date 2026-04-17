{%- set yaml_metadata -%}
source_model:
  external_logistics: 'shipment_movements'
derived_columns:
    RECORD_SOURCE: 'created_by'
    LOAD_DTS: '!{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'
    EFFECTIVE_FROM: 'created_at'
    SAT_SHIPMENT_MOVEMENT_BK: 'movement_id'
hashed_columns:
    HUB_SHIPMENT_HK: 'shipment_external_id'

    SAT_SHIPMENT_MOVEMENT_HDF:
        is_hashdiff: true
        columns:
            - 'movement_id'
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