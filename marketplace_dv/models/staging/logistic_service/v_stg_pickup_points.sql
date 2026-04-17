{%- set yaml_metadata -%}
source_model:
  external_logistics: 'pickup_points'
derived_columns:
    RECORD_SOURCE: 'created_by'
    LOAD_DTS: 'effective_from'
    EFFECTIVE_FROM: 'created_at'
    HUB_PICKUP_POINT_BK: 'pickup_point_code'
hashed_columns:
    HUB_PICKUP_POINT_HK: 'pickup_point_code'

    SAT_PICKUP_POINT_PROPERTIES_HDF:
        is_hashdiff: true
        columns:
            - 'is_active'
            - 'max_capacity_packages'
            - 'operating_hours'

    SAT_PICKUP_POINT_GEO_HDF:
        is_hashdiff: true
        columns:
            - 'country'
            - 'region'
            - 'city'
            - 'street_address'
            - 'postal_code'

    SAT_PICKUP_POINT_DESCRIPTION_HDF:
        is_hashdiff: true
        columns:
            - 'pickup_point_name'
            - 'pickup_point_type'
            - 'partner_name'
            - 'contact_phone'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set dc = metadata_dict['derived_columns'] %}
{% set hc = metadata_dict['hashed_columns'] %}

with staging as (
    {{ automate_dv.stage(
        include_source_columns=true,
        source_model=metadata_dict['source_model'],
        derived_columns=dc,
        hashed_columns=hc
    )}}
)

select * from staging