USE ROLE ACCOUNTADMIN;
USE DATABASE FOOTBALL_DB;
USE SCHEMA RAW;
USE WAREHOUSE COMPUTE_WH;

-- Recrée le stage (si déjà existant, on le supprime d'abord)
DROP STAGE IF EXISTS GCS_STAGE;

CREATE STAGE GCS_STAGE
    URL = 'gcs://football-analytics-raw/'
    STORAGE_INTEGRATION = gcs_football_integration
    FILE_FORMAT = (TYPE = 'JSON' STRIP_OUTER_ARRAY = FALSE);

-- Vérifie
LIST @GCS_STAGE;