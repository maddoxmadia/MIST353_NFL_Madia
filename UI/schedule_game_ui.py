import streamlit as st
import fetch_data
from API import schedule_game
from datetime import datetime


def schedule_game_ui():
    print("Schedule a Game")
    home_team_id = int(input("Enter Home Team ID: "))
    away_team_id = int(input("Enter Away Team ID: "))
    game_round = input("Enter Game Round (e.g., Regular Season, Playoffs): ")
    game_date = input("Enter Game Date (YYYY-MM-DD): ")
    game_time = input("Enter Game Time (HH:MM:SS): ")
    stadium_id = int(input("Enter Stadium ID: "))
    nfl_admin_id = int(input("Enter NFL Admin ID: "))

    # Convert data and time strings to appropriate formats
    game_date = datetime.strptime(game_date, "%Y-%m-%d").date()
    game_time = datetime.strptime(game_time, "%H:%M:%S").time()

    if st.button("Schedule Game"):
        result = fetch_data.schedule_game(
            home_team_id=home_team_id,
            away_team_id=away_team_id,
            game_round=game_round,
            game_date=game_date,
            game_time=game_time,
            stadium_id=stadium_id,
            nfl_admin_id=nfl_admin_id
        )
        # Call the API function to schedule the game
        schedule_game(
            home_team_id,
            away_team_id,
            game_round,
        game_date,
        game_time,
        stadium_id,
        nfl_admin_id
    )
    print("Game scheduled successfully!")