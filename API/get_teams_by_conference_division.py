from fastapi import FastAPI
from get_db_connection import get_db_connection

app = FastAPI()

@app.get("/get_teams_by_conference_division")
def get_teams_by_conference_division(
    conference: str = None,
    division: str = None
):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("{call procGetTeamsByConferenceDivision(?, ?)}",conference,division)
    rows = cursor.fetchall()
    conn.close()
    
    #convert pyodbc.row objects to dicts
    results = [
        {
            "TeamName": row.TeamName,
            "Conference": row.Conference,
            "Division": row.Division,
            "TeamColors": row.TeamColors
        }
        for row in rows
    ]
    return {"data": results}


@app.get("/get_teams_in_same_conference_division_as_specified_team")
def get_teams_in_same_conference_division_as_specified_team(
    team_name: str = None
):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("{call procGetTeamsInMyDivision(?)}",team_name)
    rows = cursor.fetchall()
    conn.close()
    
    #convert pyodbc.row objects to dicts
    results = [
        {
            "TeamName": row.TeamName,
            "Conference": row.Conference,
            "Division": row.Division
        }
        for row in rows
    ]
    return {"data": results}