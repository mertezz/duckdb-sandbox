# duckdb-sandbox

This repository benchmarks DuckDB's performance in converting CSV files to Parquet files. The benchmark includes two scenarios:
1. A single 10GB CSV file.
2. Ten 1GB CSV files.

## Repository Structure
- `data/` - Contains scripts for generating synthetic data and creating folder structure.
- `results/` - Directory to store the benchmark results.

## Usage

### Data Generation

```bash
cd data
python generate_data.py
```

### Running Benchmarks
```bash
./benchmark/run_benchmarks.sh
```