-- Sample queries
-- duckdb - run the query in the interactive shell
select count(*) cnt, min(event_time) min_time from read_parquet('results/single_event.parquet')