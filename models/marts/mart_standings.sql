{{ config(materialized='table') }}

SELECT
    league_id,
    league_name,
    season,
    rank,
    team_id,
    team_name,
    points,
    goal_diff,
    games_played,
    wins,
    draws,
    losses,
    goals_for,
    goals_against,
    ROUND(wins::FLOAT / NULLIF(games_played, 0) * 100, 1) AS win_pct
FROM {{ ref('stg_standings') }}
ORDER BY league_id, rank