{{ config(materialized='table') }}

SELECT
    p.player_id,
    p.player_name,
    p.nationality,
    p.team_name,
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
FROM {{ ref('stg_players') }} p
WHERE p.appearances > 0
ORDER BY p.goals DESC