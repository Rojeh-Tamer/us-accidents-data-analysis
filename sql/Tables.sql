USE TrafficDB_Work;
GO


-- Explore US_Accidents
SELECT TOP 10 *
FROM dbo.US_Accidents;

-- Location Dimension
CREATE TABLE dbo.Dim_Location (
    Location_ID INT IDENTITY(1,1) PRIMARY KEY,
    Street NVARCHAR(255),
    City NVARCHAR(100),
    County NVARCHAR(100),
    State NVARCHAR(50),
    Zipcode NVARCHAR(20),
    Timezone NVARCHAR(100),
    Start_Lat FLOAT,
    Start_Lng FLOAT
);

-- Weather Dimension
CREATE TABLE dbo.Dim_Weather (
    Weather_ID INT IDENTITY(1,1) PRIMARY KEY,
    Airport_Code NVARCHAR(20),
    [Temperature(F)] FLOAT,
    [Wind_Chill(F)] FLOAT,
    [Humidity(%)] INT,
    [Pressure(in)] FLOAT,
    [Visibility(mi)] FLOAT,
    Wind_Direction NVARCHAR(50),
    [Wind_Speed(mph)] FLOAT,
    [Precipitation(in)] FLOAT,
    Weather_Condition NVARCHAR(255)
);

-- Time Dimension
CREATE TABLE dbo.Dim_Time (
    Time_ID INT IDENTITY(1,1) PRIMARY KEY,
    Year INT,
    Month INT,
    Day INT,
    Day_of_Week NVARCHAR(20),
    Hour INT,
    Is_Weekend BIT,
    Day_Type NVARCHAR(20),
    Sunrise_Sunset NVARCHAR(20),
    Civil_Twilight NVARCHAR(20),
    Nautical_Twilight NVARCHAR(20),
    Astronomical_Twilight NVARCHAR(20)
);

-- Road Features Dimension
CREATE TABLE dbo.Dim_Road_Features (
    Road_Feature_ID INT IDENTITY(1,1) PRIMARY KEY,
    Amenity BIT,
    Bump BIT,
    Crossing BIT,
    Give_Way BIT,
    Junction BIT,
    No_Exit BIT,
    Railway BIT,
    Roundabout BIT,
    Station BIT,
    Stop BIT,
    Traffic_Calming BIT,
    Traffic_Signal BIT,
    Turning_Loop BIT
);

-- Fact Table
CREATE TABLE dbo.Fact_Accidents (
    Accident_ID NVARCHAR(50) PRIMARY KEY,
    Source NVARCHAR(50),
    Severity INT,
    [Distance(mi)] FLOAT,
    Location_ID INT,
    Weather_ID INT,
    Time_ID INT,
    Road_Feature_ID INT,

    FOREIGN KEY (Location_ID) REFERENCES dbo.Dim_Location(Location_ID),
    FOREIGN KEY (Weather_ID) REFERENCES dbo.Dim_Weather(Weather_ID),
    FOREIGN KEY (Time_ID) REFERENCES dbo.Dim_Time(Time_ID),
    FOREIGN KEY (Road_Feature_ID) REFERENCES dbo.Dim_Road_Features(Road_Feature_ID)
);
GO




USE TrafficDB_Work;
GO

INSERT INTO dbo.Dim_Location
(
    Street, City, County, State, Zipcode,
    Timezone, Start_Lat, Start_Lng
)
SELECT DISTINCT
    Street, City, County, State, Zipcode,
    Timezone, Start_Lat, Start_Lng
FROM dbo.US_Accidents;
GO


SELECT COUNT(*) AS Location_Count
FROM dbo.Dim_Location;



USE TrafficDB_Work;
GO

INSERT INTO dbo.Dim_Weather
(
    Airport_Code,
    [Temperature(F)],
    [Wind_Chill(F)],
    [Humidity(%)],
    [Pressure(in)],
    [Visibility(mi)],
    Wind_Direction,
    [Wind_Speed(mph)],
    [Precipitation(in)],
    Weather_Condition
)
SELECT DISTINCT
    Airport_Code,
    [Temperature(F)],
    [Wind_Chill(F)],
    [Humidity(%)],
    [Pressure(in)],
    [Visibility(mi)],
    Wind_Direction,
    [Wind_Speed(mph)],
    [Precipitation(in)],
    Weather_Condition
FROM dbo.US_Accidents;
GO


INSERT INTO dbo.Dim_Weather
(
    Airport_Code,
    [Temperature(F)],
    [Wind_Chill(F)],
    [Humidity(%)],
    [Pressure(in)],
    [Visibility(mi)],
    Wind_Direction,
    [Wind_Speed(mph)],
    [Precipitation(in)],
    Weather_Condition
)
SELECT DISTINCT
    Airport_Code,
    [Temperature(F)],
    [Wind_Chill(F)],
    [Humidity(%)],
    [Pressure(in)],
    [Visibility(mi)],
    Wind_Direction,
    [Wind_Speed(mph)],
    [Precipitation(in)],
    Weather_Condition
FROM dbo.US_Accidents;
GO



INSERT INTO dbo.Dim_Time
(
    Year,
    Month,
    Day,
    Day_of_Week,
    Hour,
    Is_Weekend,
    Day_Type,
    Sunrise_Sunset,
    Civil_Twilight,
    Nautical_Twilight,
    Astronomical_Twilight
)
SELECT DISTINCT
    Year,
    Month,
    Day,
    Day_of_Week,
    Hour,
    Is_Weekend,
    Day_Type,
    Sunrise_Sunset,
    Civil_Twilight,
    Nautical_Twilight,
    Astronomical_Twilight
FROM dbo.US_Accidents;
GO





INSERT INTO dbo.Dim_Road_Features
(
    Amenity,
    Bump,
    Crossing,
    Give_Way,
    Junction,
    No_Exit,
    Railway,
    Roundabout,
    Station,
    Stop,
    Traffic_Calming,
    Traffic_Signal,
    Turning_Loop
)
SELECT DISTINCT
    Amenity,
    Bump,
    Crossing,
    Give_Way,
    Junction,
    No_Exit,
    Railway,
    Roundabout,
    Station,
    Stop,
    Traffic_Calming,
    Traffic_Signal,
    Turning_Loop
FROM dbo.US_Accidents;
GO




INSERT INTO dbo.Fact_Accidents
(
    Accident_ID,
    Source,
    Severity,
    [Distance(mi)],
    Location_ID,
    Weather_ID,
    Time_ID,
    Road_Feature_ID
)
SELECT
    U.ID,
    U.Source,
    U.Severity,
    U.[Distance(mi)],
    L.Location_ID,
    W.Weather_ID,
    T.Time_ID,
    R.Road_Feature_ID
FROM dbo.US_Accidents U

CROSS APPLY
(
    SELECT TOP 1 Location_ID
    FROM dbo.Dim_Location L
    WHERE L.Street = U.Street
      AND L.City = U.City
      AND L.County = U.County
      AND L.State = U.State
      AND L.Zipcode = U.Zipcode
      AND L.Timezone = U.Timezone
      AND L.Start_Lat = U.Start_Lat
      AND L.Start_Lng = U.Start_Lng
    ORDER BY L.Location_ID
) L

CROSS APPLY
(
    SELECT TOP 1 Weather_ID
    FROM dbo.Dim_Weather W
    WHERE W.Airport_Code = U.Airport_Code
      AND W.[Temperature(F)] = U.[Temperature(F)]
      AND W.[Wind_Chill(F)] = U.[Wind_Chill(F)]
      AND W.[Humidity(%)] = U.[Humidity(%)]
      AND W.[Pressure(in)] = U.[Pressure(in)]
      AND W.[Visibility(mi)] = U.[Visibility(mi)]
      AND W.Wind_Direction = U.Wind_Direction
      AND W.[Wind_Speed(mph)] = U.[Wind_Speed(mph)]
      AND W.[Precipitation(in)] = U.[Precipitation(in)]
      AND W.Weather_Condition = U.Weather_Condition
    ORDER BY W.Weather_ID
) W

CROSS APPLY
(
    SELECT TOP 1 Time_ID
    FROM dbo.Dim_Time T
    WHERE T.Year = U.Year
      AND T.Month = U.Month
      AND T.Day = U.Day
      AND T.Day_of_Week = U.Day_of_Week
      AND T.Hour = U.Hour
      AND T.Is_Weekend = U.Is_Weekend
      AND T.Day_Type = U.Day_Type
      AND T.Sunrise_Sunset = U.Sunrise_Sunset
      AND T.Civil_Twilight = U.Civil_Twilight
      AND T.Nautical_Twilight = U.Nautical_Twilight
      AND T.Astronomical_Twilight = U.Astronomical_Twilight
    ORDER BY T.Time_ID
) T

CROSS APPLY
(
    SELECT TOP 1 Road_Feature_ID
    FROM dbo.Dim_Road_Features R
    WHERE R.Amenity = U.Amenity
      AND R.Bump = U.Bump
      AND R.Crossing = U.Crossing
      AND R.Give_Way = U.Give_Way
      AND R.Junction = U.Junction
      AND R.No_Exit = U.No_Exit
      AND R.Railway = U.Railway
      AND R.Roundabout = U.Roundabout
      AND R.Station = U.Station
      AND R.Stop = U.Stop
      AND R.Traffic_Calming = U.Traffic_Calming
      AND R.Traffic_Signal = U.Traffic_Signal
      AND R.Turning_Loop = U.Turning_Loop
    ORDER BY R.Road_Feature_ID
) R;
GO



SELECT COUNT(*) AS Fact_Rows
FROM dbo.Fact_Accidents;


USE TrafficDB_Work;
GO

SELECT 
    (SELECT COUNT(*) FROM dbo.Dim_Location) AS Locations,
    (SELECT COUNT(*) FROM dbo.Dim_Weather) AS Weather,
    (SELECT COUNT(*) FROM dbo.Dim_Time) AS Time_Rows,
    (SELECT COUNT(*) FROM dbo.Dim_Road_Features) AS Road_Features;

USE TrafficDB_Work;
GO

DELETE FROM dbo.Dim_Weather;
GO

INSERT INTO dbo.Dim_Weather
(
    Airport_Code,
    [Temperature(F)],
    [Wind_Chill(F)],
    [Humidity(%)],
    [Pressure(in)],
    [Visibility(mi)],
    Wind_Direction,
    [Wind_Speed(mph)],
    [Precipitation(in)],
    Weather_Condition
)
SELECT DISTINCT
    Airport_Code,
    [Temperature(F)],
    [Wind_Chill(F)],
    [Humidity(%)],
    [Pressure(in)],
    [Visibility(mi)],
    Wind_Direction,
    [Wind_Speed(mph)],
    [Precipitation(in)],
    Weather_Condition
FROM dbo.US_Accidents;
GO

SELECT COUNT(*) AS Weather_Rows
FROM dbo.Dim_Weather;


USE TrafficDB_Work;
GO

INSERT INTO dbo.Fact_Accidents
(
    Accident_ID,
    Source,
    Severity,
    [Distance(mi)],
    Location_ID,
    Weather_ID,
    Time_ID,
    Road_Feature_ID
)
SELECT
    U.ID,
    U.Source,
    U.Severity,
    U.[Distance(mi)],
    L.Location_ID,
    W.Weather_ID,
    T.Time_ID,
    R.Road_Feature_ID
FROM dbo.US_Accidents U
JOIN dbo.Dim_Location L
    ON L.Street = U.Street
    AND L.City = U.City
    AND L.County = U.County
    AND L.State = U.State
    AND L.Zipcode = U.Zipcode
    AND L.Timezone = U.Timezone
    AND L.Start_Lat = U.Start_Lat
    AND L.Start_Lng = U.Start_Lng
JOIN dbo.Dim_Weather W
    ON W.Airport_Code = U.Airport_Code
    AND W.[Temperature(F)] = U.[Temperature(F)]
    AND W.[Wind_Chill(F)] = U.[Wind_Chill(F)]
    AND W.[Humidity(%)] = U.[Humidity(%)]
    AND W.[Pressure(in)] = U.[Pressure(in)]
    AND W.[Visibility(mi)] = U.[Visibility(mi)]
    AND W.Wind_Direction = U.Wind_Direction
    AND W.[Wind_Speed(mph)] = U.[Wind_Speed(mph)]
    AND W.[Precipitation(in)] = U.[Precipitation(in)]
    AND W.Weather_Condition = U.Weather_Condition
JOIN dbo.Dim_Time T
    ON T.Year = U.Year
    AND T.Month = U.Month
    AND T.Day = U.Day
    AND T.Day_of_Week = U.Day_of_Week
    AND T.Hour = U.Hour
    AND T.Is_Weekend = U.Is_Weekend
    AND T.Day_Type = U.Day_Type
    AND T.Sunrise_Sunset = U.Sunrise_Sunset
    AND T.Civil_Twilight = U.Civil_Twilight
    AND T.Nautical_Twilight = U.Nautical_Twilight
    AND T.Astronomical_Twilight = U.Astronomical_Twilight
JOIN dbo.Dim_Road_Features R
    ON R.Amenity = U.Amenity
    AND R.Bump = U.Bump
    AND R.Crossing = U.Crossing
    AND R.Give_Way = U.Give_Way
    AND R.Junction = U.Junction
    AND R.No_Exit = U.No_Exit
    AND R.Railway = U.Railway
    AND R.Roundabout = U.Roundabout
    AND R.Station = U.Station
    AND R.Stop = U.Stop
    AND R.Traffic_Calming = U.Traffic_Calming
    AND R.Traffic_Signal = U.Traffic_Signal
    AND R.Turning_Loop = U.Turning_Loop;
GO


SELECT COUNT(*) AS Fact_Rows
FROM dbo.Fact_Accidents;




SELECT COUNT(*) AS Missing_Location
FROM dbo.US_Accidents U
LEFT JOIN dbo.Dim_Location L
    ON L.Street = U.Street
    AND L.City = U.City
    AND L.County = U.County
    AND L.State = U.State
    AND L.Zipcode = U.Zipcode
    AND L.Timezone = U.Timezone
    AND L.Start_Lat = U.Start_Lat
    AND L.Start_Lng = U.Start_Lng
WHERE L.Location_ID IS NULL;


SELECT COUNT(*) AS Missing_Weather
FROM dbo.US_Accidents U
LEFT JOIN dbo.Dim_Weather W
    ON W.Airport_Code = U.Airport_Code
    AND W.[Temperature(F)] = U.[Temperature(F)]
    AND W.[Wind_Chill(F)] = U.[Wind_Chill(F)]
    AND W.[Humidity(%)] = U.[Humidity(%)]
    AND W.[Pressure(in)] = U.[Pressure(in)]
    AND W.[Visibility(mi)] = U.[Visibility(mi)]
    AND W.Wind_Direction = U.Wind_Direction
    AND W.[Wind_Speed(mph)] = U.[Wind_Speed(mph)]
    AND W.[Precipitation(in)] = U.[Precipitation(in)]
    AND W.Weather_Condition = U.Weather_Condition
WHERE W.Weather_ID IS NULL;

SELECT COUNT(*) AS Missing_Time
FROM dbo.US_Accidents U
LEFT JOIN dbo.Dim_Time T
    ON T.Year = U.Year
    AND T.Month = U.Month
    AND T.Day = U.Day
    AND T.Day_of_Week = U.Day_of_Week
    AND T.Hour = U.Hour
    AND T.Is_Weekend = U.Is_Weekend
    AND T.Day_Type = U.Day_Type
    AND T.Sunrise_Sunset = U.Sunrise_Sunset
    AND T.Civil_Twilight = U.Civil_Twilight
    AND T.Nautical_Twilight = U.Nautical_Twilight
    AND T.Astronomical_Twilight = U.Astronomical_Twilight
WHERE T.Time_ID IS NULL;

SELECT COUNT(*) AS Missing_Road_Features
FROM dbo.US_Accidents U
LEFT JOIN dbo.Dim_Road_Features R
    ON R.Amenity = U.Amenity
    AND R.Bump = U.Bump
    AND R.Crossing = U.Crossing
    AND R.Give_Way = U.Give_Way
    AND R.Junction = U.Junction
    AND R.No_Exit = U.No_Exit
    AND R.Railway = U.Railway
    AND R.Roundabout = U.Roundabout
    AND R.Station = U.Station
    AND R.Stop = U.Stop
    AND R.Traffic_Calming = U.Traffic_Calming
    AND R.Traffic_Signal = U.Traffic_Signal
    AND R.Turning_Loop = U.Turning_Loop
WHERE R.Road_Feature_ID IS NULL;



SELECT TOP 20
    U.ID,
    U.Airport_Code,
    U.[Temperature(F)],
    U.[Wind_Chill(F)],
    U.[Humidity(%)],
    U.[Pressure(in)],
    U.[Visibility(mi)],
    U.Wind_Direction,
    U.[Wind_Speed(mph)],
    U.[Precipitation(in)],
    U.Weather_Condition
FROM dbo.US_Accidents U
LEFT JOIN dbo.Dim_Weather W
    ON W.Airport_Code = U.Airport_Code
    AND W.[Temperature(F)] = U.[Temperature(F)]
    AND W.[Wind_Chill(F)] = U.[Wind_Chill(F)]
    AND W.[Humidity(%)] = U.[Humidity(%)]
    AND W.[Pressure(in)] = U.[Pressure(in)]
    AND W.[Visibility(mi)] = U.[Visibility(mi)]
    AND W.Wind_Direction = U.Wind_Direction
    AND W.[Wind_Speed(mph)] = U.[Wind_Speed(mph)]
    AND W.[Precipitation(in)] = U.[Precipitation(in)]
    AND W.Weather_Condition = U.Weather_Condition
WHERE W.Weather_ID IS NULL;



EXEC sp_help 'dbo.Dim_Weather';.



USE TrafficDB_Work;
GO

DELETE FROM dbo.Fact_Accidents;
GO

SELECT COUNT(*) AS Missing_Weather
FROM dbo.US_Accidents U
LEFT JOIN dbo.Dim_Weather W
    ON W.Airport_Code = U.Airport_Code
    AND W.[Temperature(F)] = U.[Temperature(F)]
    AND W.[Wind_Chill(F)] = U.[Wind_Chill(F)]
    AND W.[Humidity(%)] = U.[Humidity(%)]
    AND W.[Pressure(in)] = U.[Pressure(in)]
    AND W.[Visibility(mi)] = U.[Visibility(mi)]
    AND W.Wind_Direction = U.Wind_Direction
    AND W.[Wind_Speed(mph)] = U.[Wind_Speed(mph)]
    AND W.Weather_Condition = U.Weather_Condition
WHERE W.Weather_ID IS NULL;

USE TrafficDB_Work;
GO

DELETE FROM dbo.Fact_Accidents;
GO

;WITH WeatherMatch AS
(
    SELECT
        U.ID,
        W.Weather_ID,
        ROW_NUMBER() OVER
        (
            PARTITION BY U.ID
            ORDER BY W.Weather_ID
        ) AS rn
    FROM dbo.US_Accidents U
    INNER JOIN dbo.Dim_Weather W
        ON W.Airport_Code = U.Airport_Code
        AND W.[Temperature(F)] = U.[Temperature(F)]
        AND W.[Wind_Chill(F)] = U.[Wind_Chill(F)]
        AND W.[Humidity(%)] = U.[Humidity(%)]
        AND W.[Pressure(in)] = U.[Pressure(in)]
        AND W.[Visibility(mi)] = U.[Visibility(mi)]
        AND W.Wind_Direction = U.Wind_Direction
        AND W.[Wind_Speed(mph)] = U.[Wind_Speed(mph)]
        AND W.Weather_Condition = U.Weather_Condition
),
FinalWeather AS
(
    SELECT ID, Weather_ID
    FROM WeatherMatch
    WHERE rn = 1
)

INSERT INTO dbo.Fact_Accidents
(
    Accident_ID,
    Source,
    Severity,
    [Distance(mi)],
    Location_ID,
    Weather_ID,
    Time_ID,
    Road_Feature_ID
)
SELECT
    U.ID,
    U.Source,
    U.Severity,
    U.[Distance(mi)],
    L.Location_ID,
    FW.Weather_ID,
    T.Time_ID,
    R.Road_Feature_ID
FROM dbo.US_Accidents U

INNER JOIN dbo.Dim_Location L
    ON L.Street = U.Street
    AND L.City = U.City
    AND L.County = U.County
    AND L.State = U.State
    AND L.Zipcode = U.Zipcode
    AND L.Timezone = U.Timezone
    AND L.Start_Lat = U.Start_Lat
    AND L.Start_Lng = U.Start_Lng

INNER JOIN FinalWeather FW
    ON FW.ID = U.ID

INNER JOIN dbo.Dim_Time T
    ON T.Year = U.Year
    AND T.Month = U.Month
    AND T.Day = U.Day
    AND T.Day_of_Week = U.Day_of_Week
    AND T.Hour = U.Hour
    AND T.Is_Weekend = U.Is_Weekend
    AND T.Day_Type = U.Day_Type
    AND T.Sunrise_Sunset = U.Sunrise_Sunset
    AND T.Civil_Twilight = U.Civil_Twilight
    AND T.Nautical_Twilight = U.Nautical_Twilight
    AND T.Astronomical_Twilight = U.Astronomical_Twilight

INNER JOIN dbo.Dim_Road_Features R
    ON R.Amenity = U.Amenity
    AND R.Bump = U.Bump
    AND R.Crossing = U.Crossing
    AND R.Give_Way = U.Give_Way
    AND R.Junction = U.Junction
    AND R.No_Exit = U.No_Exit
    AND R.Railway = U.Railway
    AND R.Roundabout = U.Roundabout
    AND R.Station = U.Station
    AND R.Stop = U.Stop
    AND R.Traffic_Calming = U.Traffic_Calming
    AND R.Traffic_Signal = U.Traffic_Signal
    AND R.Turning_Loop = U.Turning_Loop;
GO


SELECT
    (SELECT COUNT(*) FROM dbo.US_Accidents) AS Original_Rows,
    (SELECT COUNT(*) FROM dbo.Fact_Accidents) AS Fact_Rows;


    SELECT
    COUNT(*) AS Total_Accidents,
    COUNT(DISTINCT Accident_ID) AS Unique_Accidents,
    MIN(Severity) AS Min_Severity,
    MAX(Severity) AS Max_Severity,
    AVG(CAST(Severity AS FLOAT)) AS Avg_Severity
FROM dbo.Fact_Accidents;











SELECT
    fk.name AS Foreign_Key_Name,
    OBJECT_NAME(fk.parent_object_id) AS Child_Table,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS Child_Column,
    OBJECT_NAME(fk.referenced_object_id) AS Parent_Table,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS Parent_Column
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
WHERE fk.parent_object_id = OBJECT_ID('dbo.Fact_Accidents');