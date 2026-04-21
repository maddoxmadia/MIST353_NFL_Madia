from get_db_connection import get_db_connection
import pymssql

def get_teams_for_specified_fan(
    fan_id: int
):
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.execute("exec procGetTeamsByFanID %s", (fan_id,))
    rows = cursor.fetchall()
    conn.close()
    results = [
        {
            "TeamName": row["TeamName"],
            "Conference": row["Conference"],
            "Division": row["Division"],
            "TeamColors": row["TeamColors"]
        }
        for row in rows
    ]
    return {"data": results}