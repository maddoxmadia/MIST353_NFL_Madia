import streamlit as st
from get_teams_by_conference_division_ui import get_teams_by_conference_division_ui
from get_teams_in_same_conference_division_ui import get_teams_in_same_conference_division_as_specified_team_ui
from validate_user_ui import validate_user_ui
from get_teams_for_specified_fan_ui import get_teams_for_specified_fan_ui
from schedule_game_ui import schedule_game_ui

# Initialize session state
if "app_user_id" not in st.session_state:
    st.session_state.app_user_id = ""
if "app_user_fullname" not in st.session_state:
    st.session_state.app_user_fullname = ""
if "app_user_role" not in st.session_state:
    st.session_state.app_user_role = ""

st.title("NFL Playoffs App")
st.write("Welcome to the NFL Playoffs App! Use the sidebar to navigate through different features and explore information about NFL teams, players, and playoff matchups.")

with st.sidebar:
    st.title("NFL Playoff Functionalities")
    api_endpoint = st.selectbox(
        "Select a functionality:",
        ["Get Teams by Conference and Division",
        "Get Teams in Same Conference and Division as Specified Team",
        "Validate User",
        "Get Teams for Specified Fan",
        "Schedule Game"]
    )

if api_endpoint == "Get Teams by Conference and Division":
    get_teams_by_conference_division_ui()
elif api_endpoint == "Get Teams in Same Conference and Division as Specified Team":
    get_teams_in_same_conference_division_as_specified_team_ui()
elif api_endpoint == "Validate User":
    validate_user_ui()
elif api_endpoint == "Get Teams for Specified Fan":
    get_teams_for_specified_fan_ui()
elif api_endpoint == "Schedule Game":
    schedule_game_ui()

