{{ config(materialized='view') }}

WITH source AS (
    SELECT raw_data FROM {{ source('raw', 'raw_standings') }}
),
flattened_league AS (
    SELECT f.value AS league_data
    FROM source, LATERAL FLATTEN(INPUT => raw_data:response) f
),
flattened_standings AS (
    SELECT
        league_data:league:id::INTEGER     AS league_id,
        league_data:league:name::STRING    AS league_name,
        league_data:league:season::INTEGER AS season,
        s.value                            AS team_standing
    FROM flattened_league,
    LATERAL FLATTEN(INPUT => league_data:league:standings[0]) s
)
SELECT
    league_id, league_name, season,
    team_standing:rank::INTEGER              AS rank,
    team_standing:team:id::INTEGER           AS team_id,
    team_standing:team:name::STRING          AS team_name,
    team_standing:points::INTEGER            AS points,
    team_standing:goalsDiff::INTEGER         AS goal_diff,
    team_standing:all:played::INTEGER        AS games_played,
    team_standing:all:win::INTEGER           AS wins,
    team_standing:all:draw::INTEGER          AS draws,
    team_standing:all:lose::INTEGER          AS losses,
    team_standing:all:goals:for::INTEGER     AS goals_for,
    team_standing:all:goals:against::INTEGER AS goals_against
FROM flattened_standings