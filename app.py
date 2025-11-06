
from flask import Flask, jsonify, request
from flask_cors import CORS
import requests
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

WGER_API_KEY = os.getenv("WGER_API_KEY", "971778c2c3491524fe2197da513a8cff993d067f")
WGER_BASE_URL = "https://wger.de/api/v2/exercise/"

@app.route("/exercises", methods=["GET"])
def get_exercises():
    # Get optional query params: language and limit
    language = request.args.get("language", "2")
    limit = request.args.get("limit", "10")
    url = f"{WGER_BASE_URL}?language={language}&limit={limit}"

    headers = {
        "Authorization": f"Token {WGER_API_KEY}"
    }

    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return jsonify(response.json())
    else:
        return jsonify({"error": "Failed to fetch exercises"}), 500

if __name__ == "__main__":
    app.run(debug=True, port=5000)
