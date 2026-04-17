{%- set yaml_metadata -%}
source_model:
  external_users: 'user_addresses'
derived_columns:
    RECORD_SOURCE: 'created_by'
    LOAD_DTS: 'effective_from'
    EFFECTIVE_FROM: 'created_at'
    HUB_USER_ADDRESSES_BK: 'address_external_id'
hashed_columns:
    HUB_USER_ADDRESSES_HK: 'address_external_id'
    HUB_USER_HK: 'user_external_id'

    LINK_USER_USER_ADDRESSES_HK:
        - 'address_external_id'
        - 'user_external_id'

    SAT_USER_ADDRESS_GEO_HDF:
        is_hashdiff: true
        columns:
            - 'country'
            - 'region'
            - 'city'
            - 'street_address'
            - 'postal_code'
            - 'apartment'

    SAT_LINK_USER_USER_ADDRESSES_HDF:
        is_hashdiff: true
        columns:
            - 'address_type'
            - 'is_default'
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