{%- set yaml_metadata -%}
source_model:
  external_orders: 'products'
derived_columns:
    RECORD_SOURCE: 'created_by'
    LOAD_DTS: 'effective_from'
    EFFECTIVE_FROM: 'created_at'
    HUB_PRODUCT_BK: 'product_sku'
hashed_columns:
    HUB_PRODUCT_HK: 'product_sku'

    SAT_PRODUCT_PHYSICAL_HDF:
        is_hashdiff: true
        columns:
            - 'weight_grams'
            - 'dimensions_height_cm'
            - 'dimensions_width_cm'
            - 'dimensions_length_cm'

    SAT_PRODUCT_DESCRIPTION_HDF:
        is_hashdiff: true
        columns:
            - 'product_name'
            - 'category'
            - 'brand'

    SAT_PRODUCT_STATUS_HDF:
        is_hashdiff: true
        columns:
            - 'price'
            - 'currency'
            - 'is_active'
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