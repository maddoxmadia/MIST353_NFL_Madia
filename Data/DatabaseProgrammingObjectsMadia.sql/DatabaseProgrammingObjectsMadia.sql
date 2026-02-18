--3 queries
--1 each for ConferenceDivision, Team, and 1 join query

use MIST353_NFL_RDB_Madia;
GO

-- Query 1: Get all Conference/Division combinations
select ConferenceDivisionID, Conference, Division
from ConferenceDivision
order by Conference, Division;
GO

-- Query 2: Get all teams with their info
select TeamID, TeamName, TeamCityState, TeamColors, ConferenceDivisionID
from Team
order by TeamName;
GO

-- Query 3: Join query - Get teams with their conference and division
select t.TeamName, t.TeamCityState, t.TeamColors, cd.Conference, cd.Division
from Team as t
join ConferenceDivision as cd on t.ConferenceDivisionID = cd.ConferenceDivisionID
order by cd.Conference, cd.Division, t.TeamName;
GO