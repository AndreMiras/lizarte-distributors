import folium
import requests

DISTRIBUTOR_URL = "https://www.lizarte.com/data/datos-distribuidores.json"


def fetch_distributor_csv():
    response = requests.get(DISTRIBUTOR_URL)
    return response.json()


data = fetch_distributor_csv()
m = folium.Map(location=[data[0]["lat"], data[0]["lng"]], zoom_start=6)

for entry in data:
    folium.Marker(
        location=[entry["lat"], entry["lng"]],
        popup=f"{entry['name']}<br>{entry['province']}<br>{entry['postal']}<br>{entry['phone']}",
    ).add_to(m)

m.save("index.html")
