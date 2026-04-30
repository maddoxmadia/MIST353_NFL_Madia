-- To create dropdown lists for the NFLAdmin to select Teams and Stadiums to schedule games.

create or alter procedure procGetAllTeams
as
begin
    select TeamID, TeamName
    from Team
end
-- execute procGetAllTeams;

go

create or alter procedure procGetAllStadiums
as
begin
    select StadiumID, StadiumName
    from Stadium
end
-- execute procGetAllStadiums;

go

-- To get all changes made by a specified (logged in NFLAdmin).

create or alter procedure procGetAllChangesMadeBySpecifiedAdmin
(
    @NFLAdminID INT
)
as
begin
    select ACT.ChangeDateTime, ACT.ChangeType, ACT.ChangeDescription, 
    G.GameRound, G.GameDate, G.GameStartTime,
    HT.TeamName as HomeTeam, AT.TeamName as AwayTeam, S.StadiumName
    from AdminChangesTracker ACT inner join Game G
        on ACT.GameID = G.GameID
        inner join Team HT
        on G.HomeTeamID = HT.TeamID
        inner join Team AT
        on G.AwayTeamID = AT.TeamID
        inner join Stadium S
        on G.StadiumID = S.StadiumID
    where ACT.NFLAdminID = @NFLAdminID
    order by ACT.ChangeDateTime desc;
end

-- execute procGetAllChangesMadeBySpecifiedAdmin @NFLAdminID = 5; -- Bill Belichick
go

-- Disabling and enabling triggers on the Game table. When and Why?

-- disable trigger trgTrackChangesOnSchedulingGame on Game;
-- disable trigger all on Game;

-- enable trigger trgTrackChangesOnSchedulingGame on Game;
-- enable trigger all on Game;

go

-- Adding TeamLogo column to Team table and creating stored procedure to get teams with logos for a specified fan

alter table Team
add TeamLogo VARBINARY(MAX);

go

create or alter procedure procGetTeamsWithLogosForSpecifiedFan
(
    @NFLFanID INT
)
AS
BEGIN
    select T.TeamName, CD.Conference, CD.Division, T.TeamColors, FT.PrimaryTeam, T.TeamLogo
    from FanTeam FT inner join Team T
        on FT.TeamID = T.TeamID
        inner join ConferenceDivision CD
        on T.ConferenceDivisionID = CD.ConferenceDivisionID
    where FT.NFLFanID = @NFLFanID;
end;
-- execute procGetTeamsWithLogosForSpecifiedFan @NFLFanID = 1;

go