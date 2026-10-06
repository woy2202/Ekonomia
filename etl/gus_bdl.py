from pathlib import Path

import os
import time


import pandas as pd
import requests
from dotenv import load_dotenv

from db import get_engine

load_dotenv()

BASE_URL = "https://bdl.stat.gov.pl/api/v1"

# variable_id: short name (fill in after searching)
VARIABLES_FILE = Path(__file__).parent.parent / "dbt" / "seeds" / "gus_variables.csv"


def load_variables():
    df = pd.read_csv(VARIABLES_FILE)
    return dict(zip(df["variable_id"], df["indicator"]))

API_KEY = os.getenv("GUS_API_KEY")
HEADERS = {"X-ClientId": API_KEY} if API_KEY else {}


def fetch_variable(var_id, var_name):
    url = f"{BASE_URL}/data/by-variable/{var_id}"
    params = {"unit-level": 2, "format": "json", "page-size": 100}
    rows = []

    while url:
        response = requests.get(url, params=params, headers=HEADERS, timeout=30)
        response.raise_for_status()
        data = response.json()

        for unit in data["results"]:
            for value in unit["values"]:
                rows.append({
                    "variable_id": var_id,
                    "variable_name": var_name,
                    "unit_id": unit["id"],
                    "unit_name": unit["name"],
                    "year": int(value["year"]),
                    "value": value["val"],
                    "attr_id": value["attrId"],
                })

        url = data.get("links", {}).get("next")
        params = None  # the "next" link already contains all parameters
        time.sleep(0.5)  # be polite to the API

    return rows


def main():
    all_rows = []
    for var_id, var_name in load_variables().items():
        print(f"Fetching {var_id} ({var_name})")
        all_rows.extend(fetch_variable(var_id, var_name))

    df = pd.DataFrame(all_rows)
    df["loaded_at"] = pd.Timestamp.now()

    df.to_sql("gus_bdl", get_engine(), schema="raw", if_exists="replace", index=False)
    print(f"Saved {len(df)} rows to raw.gus_bdl")


if __name__ == "__main__":
    main()