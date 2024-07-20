#!/bin/bash

BASE_DIR=$(dirname "$0")
DATA_DIR="$BASE_DIR/data"
RESULTS_DIR="$BASE_DIR/results"

generate_events() {
    python "$BASE_DIR/generate_data.py"
}

run_single_file_benchmark() {
    single_start_time=$(date +%s)
    duckdb <<SQL
    PRAGMA enable_profiling;
    PRAGMA profiling_output='$RESULTS_DIR/single_file_profile.json';

    CREATE TABLE event AS
    SELECT * FROM read_csv_auto('$DATA_DIR/single_file/event.csv');

    -- Convert to Parquet
    COPY event TO '$RESULTS_DIR/single_event.parquet' (FORMAT PARQUET);
SQL
    single_end_time=$(date +%s)
    echo "Single file conversion duration: $(($single_end_time - $single_start_time)) seconds"
}

run_multiple_files_benchmark() {
    multiple_start_time=$(date +%s)
    duckdb <<SQL
    PRAGMA enable_profiling;
    PRAGMA profiling_output='$RESULTS_DIR/multiple_files_profile.json';

    CREATE TABLE event AS
    SELECT * FROM read_csv_auto('$DATA_DIR/multiple_files/event_*.csv');

    -- Convert to Parquet
    COPY event TO '$RESULTS_DIR/multiple_event.parquet' (FORMAT PARQUET);
SQL
    multiple_end_time=$(date +%s)
    echo "Multiple files conversion duration: $(($multiple_end_time - $multiple_start_time)) seconds"
}

duration() {
    total_end_time=$(date +%s)
    echo "Total script duration: $(($total_end_time - $start_time)) seconds"
}

start_time=$(date +%s)

generate_events
run_multiple_files_benchmark
run_single_file_benchmark
duration