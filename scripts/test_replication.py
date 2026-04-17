#!/usr/bin/env python3
import psycopg2
import time
import sys
import uuid

MASTER_CONFIG = {
    'host': 'localhost',
    'port': 5435,
    'database': 'user_service_db',
    'user': 'postgres',
    'password': 'postgres'
}

REPLICA_CONFIG = {
    'host': 'localhost',
    'port': 5445,
    'database': 'user_service_db',
    'user': 'postgres',
    'password': 'postgres'
}

def check_replication(master_conn):
    with master_conn.cursor() as cur:
        cur.execute("SELECT state FROM pg_stat_replication;")
        result = cur.fetchone()
        if result and result[0] == 'streaming':
            print("Replication: OK")
            return True
        print("Replication: FAIL")
        return False

def insert_test_data(master_conn):
    test_id = int(time.time() * 1000) % 100000
    external_id = str(uuid.uuid4())
    
    with master_conn.cursor() as cur:
        cur.execute("""
            INSERT INTO users (user_external_id, email, first_name, last_name, status)
            VALUES (%s, %s, %s, %s, %s)
            RETURNING user_id;
        """, (external_id, f'test_{test_id}@example.com', 'Test', 'User', 'active'))
        user_id = cur.fetchone()[0]
        master_conn.commit()
        print(f"Inserted: user_id={user_id}")
        return user_id

def verify_on_replica(replica_conn, user_id, timeout=30):
    start = time.time()
    while time.time() - start < timeout:
        with replica_conn.cursor() as cur:
            cur.execute("SELECT user_id FROM users WHERE user_id = %s", (user_id,))
            if cur.fetchone():
                print("Verified on replica: OK")
                return True
        time.sleep(1)
    print("Verified on replica: FAIL")
    return False

def main():
    try:
        master_conn = psycopg2.connect(**MASTER_CONFIG)
        replica_conn = psycopg2.connect(**REPLICA_CONFIG)
        
        if not check_replication(master_conn):
            sys.exit(1)
        
        user_id = insert_test_data(master_conn)
        success = verify_on_replica(replica_conn, user_id)
        
        master_conn.close()
        replica_conn.close()
        
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
