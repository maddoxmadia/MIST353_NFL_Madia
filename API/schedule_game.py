from get_db_connection import get_db_connection
from datetime import date, time
import pymssql

def schedule_game(
    home_team_id: int,
    away_team_id: int,
    game_round: str,
    game_date: date,
    game_time: time,
    stadium_id: int,
    nfl_admin_id: int
):
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)
    try:
        cursor.execute("exec procScheduleGame %s, %s, %s, %s, %s, %s, %s",
                       (game_round, home_team_id, away_team_id, game_date, game_time, stadium_id, nfl_admin_id))
        conn.commit()
        return {"status_message": "Game scheduled successfully!"}
    except Exception as e:
        conn.rollback()
        if "UNIQUE KEY constraint" in str(e):
            return {"status_message": "Game already scheduled for the specific date and time."}
        else:
            return {"status_message": f"Error scheduling game: {e}"}
    finally:
        cursor.close()
        conn.close()