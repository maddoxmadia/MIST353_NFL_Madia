import streamlit as st
from fetch_data import fetch_data

def get_teams_for_specified_fan_ui():
    st.header("Fan's Favorite Teams")

    input_parameters = {}
    fan_id = st.text_input("Fan ID", value=str(st.session_state.app_user_id), disabled=True)
    input_parameters["nfl_fan_id"] = int(fan_id) if fan_id else None

    df = fetch_data("get_teams_for_specified_fan/", input_parameters)

    if df is not None and not df.empty:
        display_name_and_userrole = f"{st.session_state.app_user_fullname} ({st.session_state.app_user_role})"
        st.success(f"Teams associated with {display_name_and_userrole}:")
        st.dataframe(df, use_container_width=True, hide_index=True)
    else:
        st.info("No teams found for the specified fan.")