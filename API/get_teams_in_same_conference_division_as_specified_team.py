from get_db_connection import get_db_connection
import pymssql

def get_teams_in_same_conference_division_as_specified_team(
        team_name: str
):
    #with get_db_connection() as conn:
    conn = get_db_connection() 
    cursor = conn.cursor()
    #cursor.execute("call procGetTeamsInSameConferenceDivisionAsSpecifiedTeam = ?", (team_name,))
    cursor.callproc("procGetTeamsInSameConferenceDivisionAsSpecifiedTeam", (team_name,))
    rows = cursor.fetchall()
    conn.close()

    #convert pyodbc.Row objects to dicts
    results = [
        {
            "TeamName": row["TeamName"],
            "Conference": row["Conference"],
            "Division": row["Division"]
        }
        for row in rows
    ]

    return {"data": results}