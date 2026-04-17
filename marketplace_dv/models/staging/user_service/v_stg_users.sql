{%- set yaml_metadata -%}
source_model:
  external_users: 'users'
derived_columns:
    RECORD_SOURCE: 'created_by'
    LOAD_DTS: 'effective_from'
    EFFECTIVE_FROM: 'created_at'
    HUB_USER_BK: 'user_external_id'
hashed_columns:
    HUB_USER_HK: 'user_external_id'

    SAT_USER_PHYSICAL_HDF:
        is_hashdiff: true
        columns:
            - 'first_name'
            - 'last_name'
            - 'date_of_birth'

    SAT_USER_REG_INFO_HDF:
        is_hashdiff: true
        columns:
            - 'email'
            - 'phone'
            - 'registration_date'
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