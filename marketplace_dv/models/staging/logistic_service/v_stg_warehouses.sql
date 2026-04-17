{%- set yaml_metadata -%}
source_model:
  external_logistics: 'warehouses'
derived_columns:
    RECORD_SOURCE: 'created_by'
    LOAD_DTS: 'effective_from'
    EFFECTIVE_FROM: 'created_at'
    HUB_WAREHOUSE_BK: 'warehouse_code'
hashed_columns:
    HUB_WAREHOUSE_HK: 'warehouse_code'

    SAT_WAREHOUSE_PROPERTIES_HDF:
        is_hashdiff: true
        columns:
            - 'is_active'
            - 'max_capacity_cubic_meters'
            - 'operating_hours'

    SAT_WAREHOUSE_GEO_HDF:
        is_hashdiff: true
        columns:
            - 'country'
            - 'region'
            - 'city'
            - 'street_address'
            - 'postal_code'

    SAT_WAREHOUSE_DESCRIPTION_HDF:
        is_hashdiff: true
        columns:
            - 'warehouse_name'
            - 'warehouse_type'
            - 'manager_name'
            - 'contact_phone'
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