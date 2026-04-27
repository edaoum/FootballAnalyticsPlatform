# Football Analytics Platform

End-to-end data pipeline on football data (Ligue 1, Premier League, Champions League).

## Architecture

API-Football → GCS → Snowflake (RAW) → dbt (Staging + Marts) → Looker Studio

## Tech Stack

- **Ingestion** : Python + API-Football + Google Cloud Storage
- **Warehouse** : Snowflake (GCP europe-west4)
- **Transformation** : dbt Cloud
- **Visualization** : Looker Studio

## Project Structure

    football-analytics/
    ├── ingestion/          # Python ingestion scripts
    ├── snowflake/          # Snowflake setup SQL
    └── dbt_football/       # dbt project
        ├── models/
        │   ├── staging/    # Raw JSON cleaning and typing
        │   └── marts/      # Final analytical tables
        └── tests/

## Data

- **Leagues** : Ligue 1, Premier League, Champions League
- **Season** : 2023/2024
- **Volume** : ~900 fixtures, 60 players, 3 standings

## Setup

Prerequisites :
- Python >= 3.11
- Snowflake account (trial OK)
- GCP account
- API-Football key (free plan : 100 req/day)

Installation :

    git clone https://github.com/edaoum/football-analytics.git
    cd football-analytics
    pip install -r requirements.txt
    cp .env.example .env
    # Fill in .env with your credentials

Ingestion :

    python3 ingestion/run_ingestion.py

dbt :

    dbt run
    dbt test

## dbt Models

| Model | Type | Description |
|-------|------|-------------|
| stg_fixtures | View | Cleaned fixtures from raw JSON |
| stg_standings | View | League standings |
| stg_players | View | Player stats (top scorers) |
| mart_top_scorers | Table | Top scorers with computed metrics |
| mart_standings | Table | Final standings with win% |
| mart_home_away_performance | Table | Home vs away performance by team |