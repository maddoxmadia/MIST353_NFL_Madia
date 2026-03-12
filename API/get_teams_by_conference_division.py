from get_db_connection import get_db_connection
def get_teams_by_conference_division(
        conference: str = None,
        division: str = None
        ):
    # with operator get_db_connecion as conn
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute( "{call procGetTeamsByConferenceDivision(?, ?)}", conference, division)
    rows = cursor.fetchall()
    conn.close()
    
    #convert pyodbc.row objects to dicts
    results = [
        {
            "TeamName": row.TeamName,
            "Conference": row.Conference,
            "Division": row.Division,
            "TeamColor": row.TeamColor
        }
        for row in rows
    ]

    return {"data": results}