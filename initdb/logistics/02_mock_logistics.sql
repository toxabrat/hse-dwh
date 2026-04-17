SET search_path TO logistics_service_db;
do $$
    declare
        tab record;
        csv_path varchar;
    begin
        for tab in
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'logistics_service_db'
              AND table_type = 'BASE TABLE'
        loop
            csv_path := '/data/logistics_service/logistics_service_' || tab.table_name || '.csv';
            execute format('copy %I from %L with (format csv, header true)', tab.table_name, csv_path);
        end loop;
    end;
$$;
