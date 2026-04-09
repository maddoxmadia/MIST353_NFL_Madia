import streamlit as st
from fetch_data import fetch_data

def get_teams_for_specified_fan_ui():
    
    st.header("Get Teams for Specified Fan")
    
    nfl_fan_id = st.text_input("Enter NFL Fan ID")
    
    if st.button("Fetch Teams"):
        if not nfl_fan_id.strip():
            st.error("NFL Fan ID is required.")
        else:
            input_params = {}
            input_params["nfl_fan_id"] = nfl_fan_id.strip()
            
            #define fetch_data function and call it with input_params
            df = fetch_data("get_teams_for_specified_fan/", input_params)
            
            if df is not None and not df.empty:
                st.subheader(f"Teams for Fan ID {nfl_fan_id}:")
                st.dataframe(df, use_container_width=True, hide_index=True)
            else:
                st.info(f"No teams found for Fan ID {nfl_fan_id}. Please check the ID and try again.")