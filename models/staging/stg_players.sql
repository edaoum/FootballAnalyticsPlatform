{{ config(materialized='view') }}

WITH source AS (
    SELECT raw_data FROM {{ source('raw', 'raw_players') }}
),
flattened AS (
    SELECT f.value AS player_data
    FROM source, LATERAL FLATTEN(INPUT => raw_data:response) f
)
SELECT
    player_data:player:id::INTEGER               AS player_id,
    player_data:player:name::STRING              AS player_name,
    player_data:player:nationality::STRING       AS nationality,
    player_data:statistics[0]:team:id::INTEGER   AS team_id,
    player_data:statistics[0]:team:name::STRING  AS team_name,
    player_data:statistics[0]:league:id::INTEGER AS league_id,
    player_data:statistics[0]:goals:total::INTEGER   AS goals,
    player_data:statistics[0]:goals:assists::INTEGER AS assists,
    player_data:statistics[0]:games:appearences::INTEGER AS appearances,
    player_data:statistics[0]:shots:total::INTEGER   AS shots_total,
    player_data:statistics[0]:shots:on::INTEGER      AS shots_on_target
FROM flattened
WHERE player_data:player:id IS NOT NULL
  AND player_data:statistics[0]:goals:total IS NOT NULL