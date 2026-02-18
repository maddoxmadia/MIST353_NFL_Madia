-- Create a database for NFL App
use master;
GO

IF DB_ID('MIST353_NFL_RDB_Madia') IS NULL
    CREATE DATABASE MIST353_NFL_RDB_Madia;
GO

-- To drop: DROP database NFL_RDB_Madia

-- Create table for the first iteration

use MIST353_NFL_RDB_Madia;
GO

if(OBJECT_ID('Team') IS NOT NULL)
drop table Team;
if(OBJECT_ID('ConferenceDivision') IS NOT NULL)
drop table ConferenceDivision;
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
