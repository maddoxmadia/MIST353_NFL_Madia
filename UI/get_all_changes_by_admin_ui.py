import streamlit as st
from fetch_data import get_data

def get_all_changes_by_admin_ui():
    st.header("My Changes")

    if not st.session_state.app_user_id:
        st.warning("Please log in to view your changes.")
        return

    input_params = {"nfl_admin_id": st.session_state.app_user_id}
    df = get_data("get_all_changes_by_admin/", input_params)

    if df is not None and not df.empty:
        st.dataframe(df, use_container_width=True, hide_index=True)
    else:
        st.info("No changes found for your account.")