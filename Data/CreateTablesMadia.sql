-- To drop: DROP database NFL_RDB_Madia

if(OBJECT_ID('FanTeam') IS NOT NULL)
    drop table FanTeam;
if(OBJECT_ID('NFLFan') IS NOT NULL)
    drop table NFLFan;
if(OBJECT_ID('NFLAdmin') IS NOT NULL)
    drop table NFLAdmin;
if(OBJECT_ID('Team') IS NOT NULL)
    drop table Team;
if(OBJECT_ID('ConferenceDivision') IS NOT NULL)
    drop table ConferenceDivision;
if(OBJECT_ID('AppUser') IS NOT NULL)
    drop table AppUser;


-- Create table for the first iteration
GO

create TABLE ConferenceDivision (
    ConferenceDivisionID INT identity(1,1)
constraint PK_ConferenceDivision PRIMARY KEY,
    Conference NVARCHAR(50) NOT NULL
constraint CK_ConferenceNames CHECK (Conference IN ('AFC', 'NFC')),
    Division NVARCHAR(50) NOT NULL
constraint CK_DivisionNames CHECK (Division IN ('East', 'North', 'West', 'South'))
);
GO

create TABLE Team (
    TeamID INT identity(1,1)
constraint PK_Team PRIMARY KEY,
    TeamName NVARCHAR(50) NOT NULL,
    TeamCityState NVARCHAR(50) NOT NULL,
    TeamColors NVARCHAR(50) NOT NULL,
    ConferenceDivisionID INT NOT NULL
constraint FK_Team_ConferenceDivision FOREIGN KEY REFERENCES ConferenceDivision(ConferenceDivisionID)
);
GO


-- Create tables for second iteration
create table AppUser(
    AppUserID INT identity(1,1)
        constraint PK_AppUser PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL
        constraint UK_AppUserEmail UNIQUE,
    PasswordHash VARBINARY(200) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    UserRole NVARCHAR(50) NOT NULL
        constraint CK_AppUserRole CHECK (UserRole IN (N'NFLAdmin', N'NFLUser'))
);

go

create table NFLFAN(
    NFLFanID INT 
        constraint PK_NFLFan PRIMARY KEY
        constraint FK_NFLFan_AppUser FOREIGN KEY REFERENCES AppUser(AppUserID)
);


create table NFLAdmin(
    NFLAdminID INT 
        constraint PK_NFLAdmin PRIMARY KEY
        constraint FK_NFLAdmin_AppUser FOREIGN KEY REFERENCES AppUser(AppUserID)
);
GO


create table FanTeam(
    FanTeamID INT IDENTITY(1,1)
        constraint PK_FanTeam PRIMARY KEY,
    NFLFanID INT NOT NULL
        constraint FK_FanTeam_NFLFan FOREIGN KEY REFERENCES NFLFAN(NFLFanID),
    TeamID INT NOT NULL
        constraint FK_FanTeam_Team FOREIGN KEY REFERENCES Team(TeamID),
    PrimaryTeam BIT NOT NULL
);
