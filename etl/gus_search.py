import sys

import requests

BASE_URL = "https://bdl.stat.gov.pl/api/v1"


def get(path, params):
    params = {**params, "format": "json", "page-size": 100}
    response = requests.get(f"{BASE_URL}/{path}", params=params, timeout=30)
    response.raise_for_status()
    return response.json()["results"]


mode, query = sys.argv[1], sys.argv[2]

if mode == "subjects":
    for s in get("subjects/search", {"name": query}):
        print(s["id"], "|", s["name"], "| levels:", s.get("levels"))

elif mode == "variables":
    for v in get("variables", {"subject-id": query}):
        name = " | ".join(v[k] for k in ("n1", "n2", "n3", "n4", "n5") if v.get(k))
        print(v["id"], "|", v.get("measureUnitName"), "|", name)

elif mode == "children":
    for s in get("subjects", {"parent-id": query}):
        print(s["id"], "|", s["name"], "| levels:", s.get("levels"))       