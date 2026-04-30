import streamlit as st
import requests
import pandas as pd
import os

FASTAPI_URL = os.getenv("FASTAPI_URL", "http://localhost:8000")

def get_data(endpoint: str, input_params: dict):
    response = requests.get(f"{FASTAPI_URL}/{endpoint}", params=input_params)
    if response.status_code == 200:
        payload = response.json()
        rows = payload.get("data", [])
        df = pd.DataFrame(rows)
        return df
    else:
        st.error(f"Error fetching data: {response.status_code}")
        return None

def post_data(endpoint: str, input_params: dict) -> dict:
    response = requests.post(f"{FASTAPI_URL}/{endpoint}", params=input_params)
    if response.status_code == 200:
        return response.json()
    else:
        st.error(f"Error posting data: {response.status_code}")
        return {"status_message": f"Error posting data: {response.status_code}"}