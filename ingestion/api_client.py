import requests, json, os
from datetime import datetime
from dotenv import load_dotenv
load_dotenv()

BASE_URL = "https://v3.football.api-sports.io"
HEADERS = {
    "x-apisports-key": os.getenv("RAPIDAPI_KEY")
}

def get_fixtures(league_id: int, season: int) -> dict:
    """Récupère les matchs d'une ligue et d'une saison."""
    resp = requests.get(
        f"{BASE_URL}/fixtures",
        headers=HEADERS,
        params={"league": league_id, "season": season}
    )
    resp.raise_for_status()
    return resp.json()

def get_standings(league_id: int, season: int) -> dict:
    """Récupère le classement d'une ligue."""
    resp = requests.get(
        f"{BASE_URL}/standings",
        headers=HEADERS,
        params={"league": league_id, "season": season}
    )
    resp.raise_for_status()
    return resp.json()

def get_top_scorers(league_id: int, season: int) -> dict:
    resp = requests.get(
        f"{BASE_URL}/players/topscorers",
        headers=HEADERS,
        params={"league": league_id, "season": season}
    )
    resp.raise_for_status()
    return resp.json()