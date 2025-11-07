from flask import Flask, jsonify, request
from flask_cors import CORS
import requests
import os
import html

app = Flask(__name__)
CORS(app)

WGER_API_KEY = os.getenv("WGER_API_KEY", "971778c2c3491524fe2197da513a8cff993d067f")
WGER_BASE_URL = "https://wger.de/api/v2/exerciseinfo/"

@app.route("/exercises", methods=["GET"])
def get_exercises():
    language = request.args.get("language", "2")  # 2 = English
    limit = request.args.get("limit", "15")
    url = f"{WGER_BASE_URL}?language={language}&limit={limit}"

    headers = {"Authorization": f"Token {WGER_API_KEY}"}
    response = requests.get(url, headers=headers)

    if response.status_code != 200:
        print(f"⚠️ WGER API error {response.status_code}: {response.text}")
        return jsonify({"error": "Failed to fetch exercises"}), 500

    results = response.json().get("results", [])
    clean = []

    for ex in results:
        # Try to find English translation
        name, desc = None, None
        for t in ex.get("translations", []):
            if t.get("language") == 2:  # English
                name = t.get("name")
                desc = html.unescape(t.get("description") or "")
                break

        # Fallback: use first translation or basic fields
        if not name:
            fallback = ex.get("translations", [])
            if fallback:
                name = fallback[0].get("name", "Unnamed")
                desc = html.unescape(fallback[0].get("description", ""))
            else:
                name = ex.get("name", "Unnamed")
                desc = html.unescape(ex.get("description", ""))

        category = ex.get("category", {}).get("name", "Unknown")

        clean.append({
            "id": ex.get("id"),
            "name": name.strip() if name else "Unnamed",
            "category": category,
            "description": desc.strip() or "No description available"
        })

    return jsonify(clean)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
