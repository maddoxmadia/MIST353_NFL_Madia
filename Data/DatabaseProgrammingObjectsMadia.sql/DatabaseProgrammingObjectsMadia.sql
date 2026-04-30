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

GO

create or alter procedure procScheduleGame
(
    @GameRound NVARCHAR(50),
    @HomeTeamID INT,
    @AwayTeamID INT,
    @GameDate DATE,
    @GameStartTime TIME,
    @StadiumID INT,
    @NFLAdminID INT --the logged-in admin who is scheduling the game
)
AS
BEGIN
    -- Store the NFL Admin ID in context so that the trigger can access it
    declare @context VARBINARY(128) = cast(@NFLAdminID as VARBINARY(128));
    SET context_info @context;

    insert into Game (HomeTeamID, AwayTeamID, GameRound, GameDate, GameStartTime, StadiumID)
values (@HomeTeamID, @AwayTeamID, @GameRound, @GameDate, @GameStartTime, @StadiumID);

END
/*
GameRound: 'Wild Card', HomeTeamID: 22, AwayTeamID: 30, GameDate: '2026-01-10', GameStartTime: '16:30', StadiumID: 22,
NFLAdminID for scheduling: 5 (Bill Belichick)

execute procScheduleGame
    @HomeTeamID = 22,
    @AwayTeamID = 30,
    @GameRound = 'Wild Card',
    @GameDate = '2026-01-10',
    @GameStartTime = '16:30',
    @StadiumID = 22,
    @NFLAdminID = 5;

    delete from Game where GameID = 12;
    select * from Game order by GameID desc;
    select * from AdminChangesTracker order by AdminChangesTrackerID desc;
*/
GO

-- trigger to track changes made by NFL Admin to the Game table
--1, triggering event is after insert, update, or delete on Game table
--2, action: inserting a record into AdminChangesTracker with NFLAdminID, GameID, ChangeType, ChangeDescription


create or alter trigger trgTrackChangesOnSchedulingGame
on Game
after insert
as
BEGIN
    declare @NFLAdminID INT;
    declare @GameID INT;
    declare @ChangeType NVARCHAR(50);
    declare @ChangeDescription NVARCHAR(500);
    declare @GameRound NVARCHAR(50);
    declare @GameDate DATE;
    declare @GameStartTime TIME;
    declare @HomeTeamID INT;
    declare @AwayTeamID INT;
    declare @HomeTeamName NVARCHAR(50);
    declare @AwayTeamName NVARCHAR(50);
    declare @StadiumID INT;
    declare @StadiumName NVARCHAR(100);

    -- get the NFLAdminID from context
    set @NFLAdminID = convert(int, convert(binary(4), context_info()));

    -- get the GameID of the newly inserted game
    select @GameID = GameID, @GameRound = GameRound, @GameDate = GameDate, @GameStartTime = GameStartTime,
        @HomeTeamID = HomeTeamID, @AwayTeamID = AwayTeamID, @StadiumID = StadiumID
    from inserted;

    select @HomeTeamName = TeamName from Team where TeamID = @HomeTeamID;
    select @AwayTeamName = TeamName from Team where TeamID = @AwayTeamID;
    select @StadiumName = StadiumName from Stadium where StadiumID = @StadiumID;

    set @ChangeType = 'Insert';
    set @ChangeDescription = 'Scheduled a new game with GameID ' + cast(@GameID as NVARCHAR(50))
        + ': ' + @HomeTeamName + ' vs ' + @AwayTeamName + ' on ' + cast(@GameDate as NVARCHAR(50))
        + ' at ' + cast(@GameStartTime as NVARCHAR(50)) + ' in stadium ' + @StadiumName
        + '. Game round: ' + @GameRound;

    insert into AdminChangesTracker (NFLAdminID, GameID, ChangeType, ChangeDescription)
    values (@NFLAdminID, @GameID, @ChangeType, @ChangeDescription);
END

GO

create or alter procedure procEnterScores
(
    @GameID INT,
    @HomeTeamScore INT,
    @AwayTeamScore INT,
    @NFLAdminID INT
)
AS
BEGIN
    declare @WinningTeamID INT;
    declare @HomeTeamID INT;
    declare @AwayTeamID INT;

    select @HomeTeamID = HomeTeamID, @AwayTeamID = AwayTeamID
    from Game where GameID = @GameID;

    if @HomeTeamScore > @AwayTeamScore
        set @WinningTeamID = @HomeTeamID;
    else
        set @WinningTeamID = @AwayTeamID;

    -- Store the NFL Admin ID in context so that the trigger can access it
    declare @context VARBINARY(128) = cast(@NFLAdminID as VARBINARY(128));
    SET context_info @context;

    update Game
    set HomeTeamScore = @HomeTeamScore,
        AwayTeamScore = @AwayTeamScore,
        WinningTeamID = @WinningTeamID
    where GameID = @GameID;
END
GO

create or alter trigger trgTrackChangesOnEnteringScores
on Game
after update
as
BEGIN
    declare @NFLAdminID INT;
    declare @GameID INT;
    declare @ChangeType NVARCHAR(50);
    declare @ChangeDescription NVARCHAR(500);
    declare @HomeTeamID INT;
    declare @AwayTeamID INT;
    declare @HomeTeamName NVARCHAR(50);
    declare @AwayTeamName NVARCHAR(50);
    declare @HomeTeamScore INT;
    declare @AwayTeamScore INT;
    declare @WinningTeamID INT;
    declare @WinningTeamName NVARCHAR(50);

    -- get the NFLAdminID from context
    set @NFLAdminID = convert(int, convert(binary(4), context_info()));

    -- get details from the updated game
    select @GameID = GameID, @HomeTeamID = HomeTeamID, @AwayTeamID = AwayTeamID,
        @HomeTeamScore = HomeTeamScore, @AwayTeamScore = AwayTeamScore,
        @WinningTeamID = WinningTeamID
    from inserted;

    select @HomeTeamName = TeamName from Team where TeamID = @HomeTeamID;
    select @AwayTeamName = TeamName from Team where TeamID = @AwayTeamID;
    select @WinningTeamName = TeamName from Team where TeamID = @WinningTeamID;

    set @ChangeType = 'Update';
    set @ChangeDescription = 'Scores updated by ' +
        (select Firstname + ' ' + Lastname from AppUser where AppUserID = @NFLAdminID) +
        ' for GameID=' + cast(@GameID as NVARCHAR(50)) +
        ': Home=' + @HomeTeamName + ' (' + cast(@HomeTeamScore as NVARCHAR(10)) + ')' +
        ', Away=' + @AwayTeamName + ' (' + cast(@AwayTeamScore as NVARCHAR(10)) + ')' +
        ', WinningTeam=' + @WinningTeamName;

    insert into AdminChangesTracker (NFLAdminID, GameID, ChangeType, ChangeDescription)
    values (@NFLAdminID, @GameID, @ChangeType, @ChangeDescription);
END

GO
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