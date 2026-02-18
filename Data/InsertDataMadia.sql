-- Sample data for NFL database
-- Insert all conferencedivision data (8 rows)
-- Insert team data for AFC North (4 rows) steelers, browns, ravens, bengals
--Insert team data for the other 28 teams (Texans, Bills, Dolphins, Patriots, Titans, Jaguars, Chargers, Broncos, Chiefs, Raiders, Cowboys, Giants, Eagles, Washington, Bears, Lions, Packers, Vikings, Falcons, Panthers, Saints, Buccaneers)


GO

use MIST353_NFL_RDB_Madia;

insert into ConferenceDivision (Conference, Division)
values
('AFC', 'North'),
('AFC', 'South'),
('AFC', 'East'),
('AFC', 'West'),
('NFC', 'North'),
('NFC', 'South'),
('NFC', 'East'),
('NFC', 'West');

GO
select * from ConferenceDivision;

GO
insert into Team (TeamName, TeamCityState, TeamColors, ConferenceDivisionID)
values
('Pittsburgh Steelers', 'Pittsburgh, PA', 'Black and Gold', 1),
('Cleveland Browns', 'Cleveland, OH', 'Brown and Orange', 1),
('Baltimore Ravens', 'Baltimore, MD', 'Purple and Black', 1),
('Cincinnati Bengals', 'Cincinnati, OH', 'Black and Orange', 1),
('Houston Texans', 'Houston, TX', 'Deep Steel Blue and Battle Red', 2),
('Tennessee Titans', 'Nashville, TN', 'Navy, Titan Blue, and Red', 2),
('Jacksonville Jaguars', 'Jacksonville, FL', 'Black, Teal, and Gold', 2),
('Indianapolis Colts', 'Indianapolis, IN', 'Royal Blue and White', 2),
('Buffalo Bills', 'Buffalo, NY', 'Royal Blue and Red', 3),
('Miami Dolphins', 'Miami, FL', 'Aqua and Orange', 3),
('New England Patriots', 'Foxborough, MA', 'Navy, Red, and Silver', 3),
('New York Jets', 'East Rutherford, NJ', 'Green and White', 3),
('Los Angeles Chargers', 'Los Angeles, CA', 'Powder Blue and Gold', 4),
('Denver Broncos', 'Denver, CO', 'Orange and Navy', 4),
('Kansas City Chiefs', 'Kansas City, MO', 'Red, Gold, and White', 4),
('Las Vegas Raiders', 'Las Vegas, NV', 'Silver and Black', 4),
('Dallas Cowboys', 'Arlington, TX', 'Navy, Silver, and White', 7),
('New York Giants', 'East Rutherford, NJ', 'Blue, Red, and White', 7),
('Philadelphia Eagles', 'Philadelphia, PA', 'Midnight Green and Silver', 7),
('Washington Commanders', 'Landover, MD', 'Burgundy and Gold', 7),
('Chicago Bears', 'Chicago, IL', 'Navy Blue and Orange', 5),
('Detroit Lions', 'Detroit, MI', 'Honolulu Blue and Silver', 5),
('Green Bay Packers', 'Green Bay, WI', 'Green and Gold', 5),
('Minnesota Vikings', 'Minneapolis, MN', 'Purple and Gold', 5),
('Atlanta Falcons', 'Atlanta, GA', 'Red and Black', 6),
('Carolina Panthers', 'Charlotte, NC', 'Black, Blue, and Silver', 6),
('New Orleans Saints', 'New Orleans, LA', 'Black and Gold', 6),
('Tampa Bay Buccaneers', 'Tampa, FL', 'Red, Pewter, and Black', 6),
('Seattle Seahawks', 'Seattle, WA', 'Navy, Action Green, and Grey', 8),
('San Francisco 49ers', 'Santa Clara, CA', 'Red and Gold', 8),
('Los Angeles Rams', 'Los Angeles, CA', 'Royal Blue and Gold', 8),
('Arizona Cardinals', 'Glendale, AZ', 'Cardinal Red, Black, and White', 8);
GO