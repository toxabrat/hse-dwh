{%- set yaml_metadata -%}
source_model:
  external_logistics: 'shipments'
derived_columns:
    RECORD_SOURCE: 'created_by'
    LOAD_DTS: 'effective_from'
    EFFECTIVE_FROM: 'created_at'
    HUB_SHIPMENT_BK: 'shipment_external_id'
hashed_columns:
    HUB_SHIPMENT_HK: 'shipment_external_id'
    HUB_PICKUP_POINT_HK: 'destination_pickup_point_code'
    HUB_WAREHOUSE_HK: 'origin_warehouse_code'
    HUB_USER_ADDRESS_HK: 'destination_address_external_id'
    HUB_ORDER_HK: 'order_external_id'

    LINK_SHIPMENT_PICKUP_POINT_HK:
        - 'shipment_external_id'
        - 'destination_pickup_point_code'
    LINK_SHIPMENT_WAREHOUSE_HK:
        - 'shipment_external_id'
        - 'origin_warehouse_code'
    LINK_SHIPMENT_USER_ADDRESS_HK:
        - 'shipment_external_id'
        - 'destination_address_external_id'
    LINK_SHIPMENT_ORDER_HK:
        - 'shipment_external_id'
        - 'order_external_id'

    SAT_SHIPMENT_PHYSICAL_HDF:
        is_hashdiff: true
        columns:
            - 'weight_grams'
            - 'volume_cubic_cm'
            - 'package_count'

    SAT_SHIPMENT_SCHEDULE_HDF:
        is_hashdiff: true
        columns:
            - 'created_at'
            - 'dispatched_date'
            - 'estimated_delivery_date'
            - 'actual_delivery_date'

    SAT_SHIPMENT_DESCRIPTION_HDF:
        is_hashdiff: true
        columns:
            - 'tracking_number'
            - 'delivery_notes'
            - 'delivery_signature'
            - 'destination'
            - 'recipient_name'
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