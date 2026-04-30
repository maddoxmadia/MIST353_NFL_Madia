import streamlit as st
from fetch_data import post_data

def schedule_game_ui():
    st.header("Schedule a Game")

    home_team_id = st.number_input("Home Team ID", min_value=1, step=1)
    away_team_id = st.number_input("Away Team ID", min_value=1, step=1)
    game_round = st.selectbox("Game Round", ["Wild Card", "Divisional", "Conference", "Super Bowl"])
    game_date = st.date_input("Game Date")
    game_time = st.time_input("Game Start Time")
    stadium_id = st.number_input("Stadium ID", min_value=1, step=1)
    nfl_admin_id = st.number_input("NFL Admin ID", min_value=1, step=1)

    if st.button("Schedule Game"):
        input_params = {
            "home_team_id": int(home_team_id),
            "away_team_id": int(away_team_id),
            "game_round": game_round,
            "game_date": str(game_date),
            "game_time": str(game_time),
            "stadium_id": int(stadium_id),
            "nfl_admin_id": int(nfl_admin_id)
        }
        result = post_data("schedule_game/", input_params)
        st.success(result.get("status_message", "Done!"))