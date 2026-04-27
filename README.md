# Football Analytics Platform

Pipeline de données end-to-end sur les données football (Ligue 1, Premier League, Champions League).

## Architecture

API-Football → GCS → Snowflake (RAW) → dbt (Staging + Marts) → Looker Studio

## Stack technique

- **Ingestion** : Python + API-Football + Google Cloud Storage
- **Warehouse** : Snowflake (GCP europe-west4)
- **Transformation** : dbt Cloud
- **Visualisation** : Looker Studio

## Structure du projet

    football-analytics/
    ├── ingestion/          # Scripts Python d'ingestion
    ├── snowflake/          # SQL de setup Snowflake
    └── dbt_football/       # Projet dbt
        ├── models/
        │   ├── staging/    # Nettoyage et typage du JSON brut
        │   └── marts/      # Tables analytiques finales
        └── tests/

## Données

- **Ligues** : Ligue 1, Premier League, Champions League
- **Saison** : 2023/2024
- **Volume** : ~900 fixtures, 60 joueurs, 3 classements

## Setup

Prérequis :
- Python >= 3.11
- Compte Snowflake (trial OK)
- Compte GCP
- Clé API-Football (plan gratuit : 100 req/jour)

Installation :

    git clone https://github.com/edaoum/football-analytics.git
    cd football-analytics
    pip install -r requirements.txt
    cp .env.example .env

Ingestion :

    python3 ingestion/run_ingestion.py

dbt :

    dbt run
    dbt test

## Modèles dbt

| Modèle | Type | Description |
|--------|------|-------------|
| stg_fixtures | View | Matchs nettoyés depuis JSON brut |
| stg_standings | View | Classements par ligue |
| stg_players | View | Stats joueurs (top scorers) |
| mart_top_scorers | Table | Top buteurs enrichis avec métriques |
| mart_standings | Table | Classements finaux avec win% |
| mart_home_away_performance | Table | Performance domicile vs extérieur |