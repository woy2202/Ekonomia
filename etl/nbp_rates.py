import os
from datetime import date, timedelta

import pandas as pd
import requests
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

load_dotenv()

START_DATE = date(2015, 1, 1)
CHUNK_DAYS = 90  # NBP API allows max 93 days per request


def fetch_period(start, end):
    url = f"https://api.nbp.pl/api/exchangerates/tables/A/{start}/{end}/?format=json"
    response = requests.get(url, timeout=30)
    if response.status_code == 404:  # no quotes in this period
        return []
    response.raise_for_status()

    rows = []
    for table in response.json():
        for rate in table["rates"]:
            rows.append({
                "effective_date": table["effectiveDate"],
                "table_no": table["no"],
                "currency": rate["currency"],
                "code": rate["code"],
                "mid": rate["mid"],
            })
    return rows


def get_engine():
    url = URL.create(
        "postgresql+psycopg2",
        username=os.environ["POSTGRES_USER"],
        password=os.environ["POSTGRES_PASSWORD"],
        host=os.environ["POSTGRES_HOST"],
        port=int(os.environ["POSTGRES_PORT"]),
        database=os.environ["POSTGRES_DB"],
    )
    return create_engine(url)


def main():
    all_rows = []
    start = START_DATE
    today = date.today()

    while start <= today:
        end = min(start + timedelta(days=CHUNK_DAYS - 1), today)
        print(f"Fetching {start} -> {end}")
        all_rows.extend(fetch_period(start, end))
        start = end + timedelta(days=1)

    df = pd.DataFrame(all_rows)
    df["loaded_at"] = pd.Timestamp.now()

    df.to_sql("nbp_rates", get_engine(), schema="raw", if_exists="replace", index=False)
    print(f"Saved {len(df)} rows to raw.nbp_rates")


if __name__ == "__main__":
    main()