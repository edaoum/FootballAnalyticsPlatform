import sys, os
sys.path.insert(0, os.path.dirname(__file__))

from dotenv import load_dotenv
load_dotenv('/home/mouad_elkhoumri/football-analytics/.env')

from api_client import get_fixtures, get_standings, get_top_scorers
from gcs_uploader import upload_json_to_gcs
from datetime import datetime

LEAGUES = {
    "ligue1": 61,
    "premier_league": 39,
    "champions_league": 2
}
SEASON = 2023

def run():
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")

    for league_name, league_id in LEAGUES.items():
        print(f"\nIngesting {league_name}...")

        fixtures = get_fixtures(league_id, SEASON)
        print(f"  Fixtures : {fixtures['results']}")
        upload_json_to_gcs(fixtures, "matches", f"{league_name}_{ts}")

        standings = get_standings(league_id, SEASON)
        print(f"  Standings : {standings['results']}")
        upload_json_to_gcs(standings, "standings", f"{league_name}_{ts}")

        scorers = get_top_scorers(league_id, SEASON)
        print(f"  Top scorers : {scorers['results']}")
        upload_json_to_gcs(scorers, "players", f"{league_name}_{ts}")

        print(f"  ✓ {league_name} done")

if __name__ == "__main__":
    run()