from get_db_connection import get_db_connection
import pymssql

def get_all_changes_by_admin(nfl_admin_id: int):
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.execute("exec procGetAllChangesMadeBySpecifiedAdmin %s", (nfl_admin_id,))
    rows = cursor.fetchall()
    conn.close()

    results = [
        {
            "ChangeDateTime": str(row["ChangeDateTime"]),
            "ChangeType": row["ChangeType"],
            "ChangeDescription": row["ChangeDescription"],
            "GameRound": row["GameRound"],
            "GameDate": str(row["GameDate"]),
            "GameStartTime": str(row["GameStartTime"]),
            "HomeTeam": row["HomeTeam"],
            "AwayTeam": row["AwayTeam"],
            "StadiumName": row["StadiumName"]
        }
        for row in rows
    ]

    return {"data": results}