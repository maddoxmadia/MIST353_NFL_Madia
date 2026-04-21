from get_db_connection import get_db_connection
import pymssql

def get_teams_by_fan_id(
        fan_id: int
):
    #with get_db_connection() as conn:
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)
    #cursor.callproc("procGetTeamsByFanID", (fan_id,))
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