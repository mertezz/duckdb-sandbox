-- Sample queries
-- duckdb
select count(*) cnt, min(event_time) min_time from read_parquet('/Users/matej/development/personal/duckdb-sandbox/results/single_event.parquet')