from get_db_connection import get_db_connection
import pymssql

def insert_logos():
    # conference = "AFC"
    # division = "North"
    # conn = get_db_connection()
    # cursor = conn.cursor(as_dict=True)
    # cursor.callproc("procGetTeamsByConferenceDivision", (conference, division))
    # teams = cursor.fetchall()

    teams = ['Baltimore Ravens', 'Cincinnati Bengals', 'Cleveland Browns', 'Pittsburgh Steelers', 'New England Patriots', 'Tampa Bay Buccaneers']
    conn = get_db_connection()
    cursor = conn.cursor()
    for team in teams:
        with open(f"TeamLogos/{team.replace(' ', '_')}.png", "rb") as image_file:
            logo_data = image_file.read()
        cursor.execute("UPDATE Team SET TeamLogo = %s WHERE TeamName = %s", (logo_data, team))
    conn.commit()
    cursor.close()
    conn.close()

if __name__ == "__main__":
    insert_logos()