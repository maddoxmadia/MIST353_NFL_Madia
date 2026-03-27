import streamlit as st
from fetch_data import fetch_data

def get_teams_in_same_conference_division_ui():
    st.subheader("Get Teams in Same Conference and Division as Specified Team")

    team = st.text_input("Enter team name:")

if st.button("Fetch Teams"):
    if not team.strip():
        st.error("Please enter a team name.")
    else:
        input_params = {}
        input_params["team_name"] = team.strip()
        #define fetch_data and call it with input_params
        df = fetch_data("get_teams_in_same_conference_division_as_specified_team/", input_params)

        if df is not None and not df.empty:
            st.subheader("Teams in Same Conference and Division as {team_name}:")
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info("No teams found in the same conference and division as {team_name}. Please check the team name and try again.")