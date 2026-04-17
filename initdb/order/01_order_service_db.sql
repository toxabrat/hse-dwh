CREATE SCHEMA IF NOT EXISTS order_service_db;

CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replicator_pass';
SELECT pg_create_physical_replication_slot('replica_slot');
CREATE PUBLICATION order_service_publication FOR ALL TABLES;

CREATE TABLE order_service_db.products (
    product_id SERIAL PRIMARY KEY,
    product_sku VARCHAR NOT NULL UNIQUE,
    product_name VARCHAR,
    category VARCHAR,
    brand VARCHAR,
    price DECIMAL(10, 2),
    currency VARCHAR,
    weight_grams INTEGER,
    dimensions_length_cm DECIMAL(10, 2),
    dimensions_width_cm DECIMAL(10, 2),
    dimensions_height_cm DECIMAL(10, 2),
    is_active BOOLEAN,
    effective_from TIMESTAMP,
    effective_to TIMESTAMP,
    is_current BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR,
    updated_by VARCHAR
);

CREATE TABLE order_service_db.orders (
    order_id SERIAL PRIMARY KEY,
    order_external_id UUID NOT NULL UNIQUE,
    user_external_id UUID NOT NULL,
    order_number VARCHAR NOT NULL UNIQUE,
    order_date TIMESTAMP,
    status VARCHAR,
    subtotal DECIMAL(10, 2),
    tax_amount DECIMAL(10, 2),
    shipping_cost DECIMAL(10, 2),
    discount_amount DECIMAL(10, 2),
    total_amount DECIMAL(10, 2),
    currency VARCHAR,
    delivery_address_external_id UUID NOT NULL,
    delivery_type VARCHAR,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    payment_method VARCHAR,
    payment_status VARCHAR,
    effective_from TIMESTAMP,
    effective_to TIMESTAMP,
    is_current BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR,
    updated_by VARCHAR
);

CREATE TABLE order_service_db.order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_external_id UUID NOT NULL,
    product_sku VARCHAR NOT NULL,
    quantity INTEGER,
    unit_price DECIMAL(10, 2),
    total_price DECIMAL(10, 2),
    product_name_snapshot VARCHAR,
    product_category_snapshot VARCHAR,
    product_brand_snapshot VARCHAR,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR,
    updated_by VARCHAR
    
--     CONSTRAINT fk_order_items_orders
--         FOREIGN KEY (order_external_id) REFERENCES
-- order_service_db.orders(order_external_id),
--     CONSTRAINT fk_order_items_products
--         FOREIGN KEY (product_sku) REFERENCES
-- order_service_db.products(product_sku)
);

CREATE TABLE order_service_db.order_status_history (
    history_id SERIAL PRIMARY KEY,
    order_external_id UUID NOT NULL,
    old_status VARCHAR,
    new_status VARCHAR,
    change_reason VARCHAR,
    changed_at TIMESTAMP,
    changed_by VARCHAR,
    session_id VARCHAR,
    ip_address INET,
    notes TEXT
    
--     CONSTRAINT fk_order_status_history_orders
--         FOREIGN KEY (order_external_id) REFERENCES
-- order_service_db.orders(order_external_id)
);
