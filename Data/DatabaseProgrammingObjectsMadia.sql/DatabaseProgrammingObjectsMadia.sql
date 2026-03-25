--3 queries
--1 each for ConferenceDivision, Team, and 1 join query

--use MIST353_NFL_RDB_Madia;
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

/*User searches for teams using conference name (optional) and division names (optional) 
To show TeamName, ConferenceName, DivisionName*/

create or alter procedure procGetTeamsByConferenceDivision
(
    @ConferenceName nvarchar(50) = null,
    @DivisionName nvarchar(50) = null
)
AS
begin
select TeamName, TeamColors, Conference, Division
from Team as t
inner join ConferenceDivision as cd on t.ConferenceDivisionID = cd.ConferenceDivisionID
where (@ConferenceName is null or Conference = @ConferenceName)
and (@DivisionName is null or Division = @DivisionName);
end
GO

/*Find teams in my team's division (user optionally provides their team name)
Find all teams in my team's division
To show: TeamName, ConferenceName, DivisionName*/

--create or alter procedure procGetTeamsInMyDivision
-- (
--     @TeamName nvarchar(50) = null
-- )
-- AS
-- begin
-- select t.TeamName, cd.Conference, cd.Division
-- from Team as t
-- inner join ConferenceDivision as cd on t.ConferenceDivisionID = cd.ConferenceDivisionID
-- where cd.ConferenceDivisionID = (
--     select ConferenceDivisionID
--     from Team
--     where TeamName = @TeamName
-- )
-- or @TeamName is null;
-- end
-- GO


/*declare @myTeamName nvarchar(50) = 'Pittsburgh Steelers';

select OtherTeam.TeamName
from Team MyTeam INNER JOIN Team OtherTeam
on MyTeam.ConferenceDivisionID = OtherTeam.ConferenceDivisionID
where MyTeam.TeamName = @myTeamName AND*/

create or alter procedure procGetTeamsInMyDivision
(
    @TeamName nvarchar(50) = null
)
AS
begin
    select t.TeamName, cd.Conference, cd.Division
    from Team as t
    inner join ConferenceDivision as cd on t.ConferenceDivisionID = cd.ConferenceDivisionID
    where (@TeamName is null)
       or (t.ConferenceDivisionID in (
           select ConferenceDivisionID
           from Team
           where TeamName = @TeamName
       ))
    order by cd.Conference, cd.Division, t.TeamName;
end
GO