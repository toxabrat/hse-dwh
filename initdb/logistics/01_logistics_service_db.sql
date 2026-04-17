CREATE SCHEMA IF NOT EXISTS logistics_service_db;

CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replicator_pass';
SELECT pg_create_physical_replication_slot('replica_slot');
CREATE PUBLICATION logistics_service_publication FOR ALL TABLES;

CREATE TABLE logistics_service_db.warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_code VARCHAR NOT NULL UNIQUE,
    warehouse_name VARCHAR,
    warehouse_type VARCHAR,
    country VARCHAR,
    region VARCHAR,
    city VARCHAR,
    street_address VARCHAR,
    postal_code VARCHAR,
    is_active BOOLEAN,
    max_capacity_cubic_meters DECIMAL(10, 2),
    operating_hours VARCHAR,
    contact_phone VARCHAR,
    manager_name VARCHAR,
    effective_from TIMESTAMP,
    effective_to TIMESTAMP,
    is_current BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR,
    updated_by VARCHAR
);

CREATE TABLE logistics_service_db.pickup_points (
    pickup_point_id SERIAL PRIMARY KEY,
    pickup_point_code VARCHAR NOT NULL UNIQUE,
    pickup_point_name VARCHAR,
    pickup_point_type VARCHAR,
    country VARCHAR,
    region VARCHAR,
    city VARCHAR,
    street_address VARCHAR,
    postal_code VARCHAR,
    is_active BOOLEAN,
    max_capacity_packages INTEGER,
    operating_hours VARCHAR,
    contact_phone VARCHAR,
    partner_name VARCHAR,
    effective_from TIMESTAMP,
    effective_to TIMESTAMP,
    is_current BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR,
    updated_by VARCHAR
);

CREATE TABLE logistics_service_db.shipments (
    shipment_id SERIAL PRIMARY KEY,
    shipment_external_id UUID NOT NULL UNIQUE,
    order_external_id UUID NOT NULL,
    tracking_number VARCHAR NOT NULL UNIQUE,
    status VARCHAR,
    weight_grams INTEGER,
    volume_cubic_cm INTEGER,
    package_count INTEGER,
    origin_warehouse_code VARCHAR NOT NULL,
    destination VARCHAR,
    destination_pickup_point_code VARCHAR, --NOT NULL,
    destination_address_external_id UUID, --NOT NULL,
    created_date TIMESTAMP,
    dispatched_date TIMESTAMP,
    estimated_delivery_date TIMESTAMP,
    actual_delivery_date TIMESTAMP,
    delivery_notes TEXT,
    recipient_name VARCHAR,
    delivery_signature VARCHAR,
    effective_from TIMESTAMP,
    effective_to TIMESTAMP,
    is_current BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR,
    updated_by VARCHAR

--     CONSTRAINT fk_shipments_warehouses
--         FOREIGN KEY (origin_warehouse_code) REFERENCES
-- logistics_service_db.warehouses(warehouse_code),
--     CONSTRAINT fk_shipments_pickup_points
--         FOREIGN KEY (destination_pickup_point_code) REFERENCES
-- logistics_service_db.pickup_points(pickup_point_code)
);

CREATE TABLE logistics_service_db.shipment_movements (
    movement_id SERIAL PRIMARY KEY,
    shipment_external_id UUID NOT NULL,
    movement_type VARCHAR,
    location_type VARCHAR,
    location_code VARCHAR,
    movement_datetime TIMESTAMP NOT NULL,
    operator_name VARCHAR,
    notes TEXT,
    latitude DECIMAL(10, 2),
    longitude DECIMAL(10, 2),
    created_at TIMESTAMP,
    created_by VARCHAR

--     CONSTRAINT fk_shipment_movements_shipments
--         FOREIGN KEY (shipment_external_id) REFERENCES
-- logistics_service_db.shipments(shipment_external_id)
);


CREATE TABLE logistics_service_db.shipment_status_history (
    history_id SERIAL PRIMARY KEY,
    shipment_external_id UUID NOT NULL,
    old_status VARCHAR,
    new_status VARCHAR,
    change_reason VARCHAR,
    changed_at TIMESTAMP,
    changed_by VARCHAR,
    location_type VARCHAR,
    location_code VARCHAR,
    notes TEXT,
    customer_notified BOOLEAN
    
--     CONSTRAINT fk_shipment_status_history_shipments
--         FOREIGN KEY (shipment_external_id) REFERENCES
-- logistics_service_db.shipments(shipment_external_id)
);
