# Football Analytics Platform

End-to-end data pipeline on football data (Ligue 1, Premier League, Champions League).

## Architecture

API-Football → GCS → Snowflake (RAW) → dbt Cloud (Staging + Marts) → Power BI

## Tech Stack

- **Ingestion** : Python + API-Football (api-sports.io) + Google Cloud Storage
- **Warehouse** : Snowflake (GCP europe-west4, Standard edition)
- **Transformation** : dbt Cloud
- **Visualization** : Power BI Desktop

## Project Structure

    football-analytics/
    ├── ingestion/                  # Python ingestion scripts
    │   ├── api_client.py           # API-Football client
    │   ├── gcs_uploader.py         # GCS upload helper
    │   └── run_ingestion.py        # Main ingestion script
    ├── snowflake/                  # Snowflake setup SQL
    │   ├── 01_setup.sql            # Database, schemas, warehouse
    │   ├── 02_stage.sql            # GCS external stage
    │   └── 03_raw_tables.sql       # Raw tables + COPY INTO
    ├── models/                     # dbt models
    │   ├── staging/                # Raw JSON cleaning and typing
    │   │   ├── _sources.yml
    │   │   ├── _staging.yml
    │   │   ├── stg_fixtures.sql
    │   │   ├── stg_standings.sql
    │   │   └── stg_players.sql
    │   └── marts/                  # Final analytical tables
    │       ├── mart_top_scorers.sql
    │       ├── mart_standings.sql
    │       └── mart_home_away_performance.sql
    ├── football_analytics.pbix     # Power BI dashboard
    ├── .env.example                # Environment variables template
    └── requirements.txt

## Data

- **League** : Ligue 1
- **Season** : 2024/2025
- **Volume** : ~307 fixtures, 20 top scorers, 1 standing

## Setup

Prerequisites :
- Python >= 3.11
- Snowflake account (trial OK)
- GCP account with a GCS bucket
- API-Football key (free plan : 100 req/day) → https://dashboard.api-football.com
- dbt Cloud account (free Developer plan) → https://cloud.getdbt.com
- Power BI Desktop (Windows)

Installation :

    git clone https://github.com/edaoum/football-analytics.git
    cd football-analytics
    pip install -r requirements.txt
    cp .env.example .env
    # Fill in .env with your credentials

## Snowflake Setup

Run the SQL files in order in a Snowflake worksheet :

    snowflake/01_setup.sql   # Create database, schemas, warehouse
    snowflake/02_stage.sql   # Create GCS external stage
    snowflake/03_raw_tables.sql  # Create raw tables and load data

## Ingestion

Fetches fixtures, standings and top scorers for 3 leagues and uploads to GCS :

    python3 ingestion/run_ingestion.py

Data is partitioned by date in GCS :

    gs://football-analytics-raw/
    ├── matches/YYYY/MM/DD/
    ├── standings/YYYY/MM/DD/
    └── players/YYYY/MM/DD/

## dbt Models

| Model | Type | Description |
|-------|------|-------------|
| stg_fixtures | View | Cleaned fixtures from raw JSON (FLATTEN) |
| stg_standings | View | League standings from raw JSON |
| stg_players | View | Top scorers stats from raw JSON |
| mart_top_scorers | Table | Top scorers with goals/game, conversion rate, league rank |
| mart_standings | Table | Final standings with win percentage |
| mart_home_away_performance | Table | Home vs away performance with home advantage % |

Run all models :

    dbt build

## Power BI Dashboard

Open football_analytics.pbix in Power BI Desktop.

3 pages :
- **Overview** : League standings with points, wins, draws, losses, goal diff
- **Top Scorers** : Top scorers ranked by goals with per-game metrics
- **Home vs Away** : Home vs away win % and home advantage by team

Connect to Snowflake using DirectQuery for live data.