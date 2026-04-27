{{ config(materialized='table') }}

WITH fixtures AS (
    SELECT * FROM {{ ref('stg_fixtures') }}
    WHERE match_status = 'FT'
),
home AS (
    SELECT
        home_team_id AS team_id,
        home_team_name AS team_name,
        league_id, season,
        COUNT(*) AS games,
        SUM(CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS wins,
        SUM(home_goals) AS goals_for,
        SUM(away_goals) AS goals_against
    FROM fixtures GROUP BY 1,2,3,4
),
away AS (
    SELECT
        away_team_id AS team_id,
        away_team_name AS team_name,
        league_id, season,
        COUNT(*) AS games,
        SUM(CASE WHEN away_goals > home_goals THEN 1 ELSE 0 END) AS wins,
        SUM(away_goals) AS goals_for,
        SUM(home_goals) AS goals_against
    FROM fixtures GROUP BY 1,2,3,4
)
SELECT
    h.team_id, h.team_name, h.league_id, h.season,
    h.games AS home_games, h.wins AS home_wins,
    h.goals_for AS home_goals_for,
    a.games AS away_games, a.wins AS away_wins,
    a.goals_for AS away_goals_for,
    ROUND(h.wins::FLOAT / NULLIF(h.games,0) * 100, 1) AS home_win_pct,
    ROUND(a.wins::FLOAT / NULLIF(a.games,0) * 100, 1) AS away_win_pct,
    ROUND(h.wins::FLOAT / NULLIF(h.games,0) * 100, 1) -
    ROUND(a.wins::FLOAT / NULLIF(a.games,0) * 100, 1) AS home_advantage_pct
FROM home h
JOIN away a ON h.team_id = a.team_id AND h.league_id = a.league_id
ORDER BY home_advantage_pct DESC