CREATE SCHEMA IF NOT EXISTS user_service_db;

CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replicator_pass';
SELECT pg_create_physical_replication_slot('replica_slot');
CREATE PUBLICATION user_service_publication FOR ALL TABLES;

CREATE TABLE user_service_db.users (
    user_id SERIAL PRIMARY KEY,
    user_external_id UUID NOT NULL UNIQUE,
    email VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    phone VARCHAR,
    date_of_birth DATE,
    registration_date TIMESTAMP,
    status VARCHAR,
    effective_from TIMESTAMP,
    effective_to TIMESTAMP,
    is_current BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR,
    updated_by VARCHAR
);

CREATE TABLE user_service_db.user_status_history (
    history_id SERIAL PRIMARY KEY,
    user_external_id UUID NOT NULL,
    old_status VARCHAR,
    new_status VARCHAR,
    change_reason VARCHAR,
    changed_at TIMESTAMP,
    changed_by VARCHAR,
    session_id VARCHAR,
    ip_address INET,
    user_agent TEXT,
    CONSTRAINT fk_user_status_history_users 
        FOREIGN KEY (user_external_id) REFERENCES 
user_service_db.users(user_external_id)
);

CREATE TABLE user_service_db.user_addresses (
    address_id SERIAL PRIMARY KEY,
    address_external_id UUID NOT NULL UNIQUE,
    user_external_id UUID NOT NULL,
    address_type VARCHAR,
    country VARCHAR,
    region VARCHAR,
    city VARCHAR,
    street_address VARCHAR,
    postal_code VARCHAR,
    apartment VARCHAR,
    is_default BOOLEAN,
    effective_from TIMESTAMP,
    effective_to TIMESTAMP,
    is_current BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR,
    updated_by VARCHAR,
    CONSTRAINT fk_user_addresses_users 
        FOREIGN KEY (user_external_id) REFERENCES 
user_service_db.users(user_external_id)
);
