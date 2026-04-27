{{ config(materialized='table') }}

WITH players AS (
    SELECT * FROM {{ ref('stg_players') }}
),
league_names AS (
    SELECT DISTINCT league_id, league_name
    FROM {{ ref('stg_standings') }}
)

SELECT
    p.player_id,
    p.player_name,
    p.nationality,
    p.team_name,
    l.league_name,
    p.league_id,
    p.goals,
    p.assists,
    p.appearances,
    p.shots_total,
    p.shots_on_target,
    ROUND(p.goals::FLOAT / NULLIF(p.appearances, 0), 2)      AS goals_per_game,
    ROUND(p.assists::FLOAT / NULLIF(p.appearances, 0), 2)    AS assists_per_game,
    ROUND(p.goals::FLOAT / NULLIF(p.shots_on_target, 0), 2) AS conversion_rate,
    RANK() OVER (PARTITION BY p.league_id ORDER BY p.goals DESC) AS league_rank
FROM players p
LEFT JOIN league_names l ON p.league_id = l.league_id
WHERE p.appearances > 0
ORDER BY p.goals DESC