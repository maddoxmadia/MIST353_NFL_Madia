--3 queries
--1 each for ConferenceDivision, Team, and 1 join query
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
    @ConferenceName NVARCHAR(50) = null,
    @DivisionName NVARCHAR(50) = null
)
AS
begin
    select TeamName, TeamColors, Conference, Division
    from Team T inner join ConferenceDivision C
        on T.ConferenceDivisionID = C.ConferenceDivisionID
    where Conference = IsNull(@ConferenceName, Conference)
        and Division = IsNull(@DivisionName, Division)
end
/*
execute procGetTeamsByConferenceDivision
    @ConferenceName = 'AFC',
    @DivisionName = 'North';
*/
GO

create OR alter procedure procGetTeamsInSameConferenceDivisionAsSpecifiedTeam
(
    @TeamName NVARCHAR(50)
)
AS
BEGIN
    select OtherTeam.TeamName, CD.Conference, CD.Division
    from Team MyTeam inner join Team OtherTeam
        on MyTeam.ConferenceDivisionID = OtherTeam.ConferenceDivisionID
        inner join ConferenceDivision CD
        on MyTeam.ConferenceDivisionID = CD.ConferenceDivisionID
    where MyTeam.TeamName = @TeamName and
        OtherTeam.TeamName != @TeamName;
END
-- execute procGetTeamsInSameConferenceDivisionAsSpecifiedTeam @TeamName = 'Baltimore Ravens';
GO

create or alter procedure procValidateUser
(
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(200)
)
AS
BEGIN
    select AppUserID, Firstname + ' ' + Lastname as Fullname, UserRole
    from AppUser
    where Email = @Email and
        PasswordHash = Convert(VARBINARY(200), @PasswordHash, 1);
END
-- execute procValidateUser @Email = 'tom.brady@example.com', @PasswordHash = '0x01';
-- select * from AppUser;
GO

-- create or alter procedure procGetTeamsForSpecifiedFan
-- (
--     @NFLFanID INT
-- )
-- AS
-- BEGIN
--     select T.TeamName, CD.Conference, CD.Division, T.TeamColors
--     from NFLFan F
--         inner join Team T
--         on F.NFLFanID = T.TeamID
--         inner join ConferenceDivision CD
--         on T.ConferenceDivisionID = CD.ConferenceDivisionID
--     where F.NFLFanID = @NFLFanID;
-- end;
-- execute procGetTeamsForSpecifiedFan @NFLFanID = 1;
-- execute procGetTeamsForSpecifiedFan @NFLFanID = 2;
GO

create or alter procedure procGetTeamsByFanID
(
    @FanID INT
)
AS
BEGIN
    select T.TeamName, CD.Conference, CD.Division, T.TeamColors, FT.PrimaryTeam
    from FanTeam FT inner join Team T
        on FT.TeamID = T.TeamID
        inner join ConferenceDivision CD
        on T.ConferenceDivisionID = CD.ConferenceDivisionID
    where FT.NFLFanID = @FanID;
END
-- execute procGetTeamsByFanID @FanID = 1;
-- execute procGetTeamsByFanID @FanID = 2;
-- execute procGetTeamsByFanID @FanID = 3;
GO