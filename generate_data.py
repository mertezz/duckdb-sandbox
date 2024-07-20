import duckdb
import os

single_file_dir = 'data/single_file'
multiple_files_dir = 'data/multiple_files'

os.makedirs(single_file_dir, exist_ok=True)
os.makedirs(multiple_files_dir, exist_ok=True)

con = duckdb.connect()

rows_single_file = 10_000_000
rows_multiple_files = 100_000

def generate_data(rows, path):
    query = f"""
    COPY (
        SELECT
            (RANDOM() * 100000000000000)::bigint AS user_id,
            (RANDOM()*100)::INTEGER AS event_id,
            NOW() - (RANDOM()::INTEGER % 86400 || ' seconds')::INTERVAL AS event_time,
            md5(random()::text) AS value1,
            md5(random()::text) AS value2,
            md5(random()::text) AS value3,
        FROM range({rows})
    ) TO '{path}' WITH (FORMAT CSV, HEADER TRUE);
    """
    con.execute(query)

# Generate single 10GB file
generate_data(rows_single_file, os.path.join(single_file_dir, 'event.csv'))

# Generate 10x 1GB files
for i in range(10):
    generate_data(rows_multiple_files, os.path.join(multiple_files_dir, f'event_{i}.csv'))

con.close()
