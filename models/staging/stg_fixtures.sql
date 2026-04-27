{{ config(materialized='view') }}

WITH source AS (
    SELECT raw_data, loaded_at
    FROM {{ source('raw', 'raw_fixtures') }}
),

flattened AS (
    SELECT
        f.value AS fixture_data,
        loaded_at
    FROM source,
    LATERAL FLATTEN(INPUT => raw_data:response) f
)

SELECT
    fixture_data:fixture:id::INTEGER          AS fixture_id,
    fixture_data:fixture:date::TIMESTAMP_NTZ  AS match_date,
    fixture_data:fixture:status:short::STRING AS match_status,
    fixture_data:league:id::INTEGER           AS league_id,
    fixture_data:league:name::STRING          AS league_name,
    fixture_data:league:season::INTEGER       AS season,
    fixture_data:league:round::STRING         AS match_round,
    fixture_data:teams:home:id::INTEGER       AS home_team_id,
    fixture_data:teams:home:name::STRING      AS home_team_name,
    fixture_data:teams:away:id::INTEGER       AS away_team_id,
    fixture_data:teams:away:name::STRING      AS away_team_name,
    fixture_data:goals:home::INTEGER          AS home_goals,
    fixture_data:goals:away::INTEGER          AS away_goals,
    fixture_data:score:halftime:home::INTEGER AS ht_home_goals,
    fixture_data:score:halftime:away::INTEGER AS ht_away_goals,
    loaded_at
FROM flattened
WHERE fixture_data:fixture:status:short::STRING = 'FT'