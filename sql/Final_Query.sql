USE TrafficDB_Work;


-- Explore Dim_Location
SELECT TOP 10 *
FROM dbo.Dim_Location;

-- Explore Dim_Weather
SELECT TOP 10 *
FROM dbo.Dim_Weather;

-- Explore Dim_Time
SELECT TOP 10 *
FROM dbo.Dim_Time;

-- Explore Dim_Road_Features
SELECT TOP 10 *
FROM dbo.Dim_Road_Features;

-- Explore Fact_Accidents
SELECT TOP 10 *
FROM dbo.Fact_Accidents;
GO

SELECT COUNT(*) AS Total_Accidents
FROM dbo.Fact_Accidents;

SELECT
    Severity,
    COUNT(*) AS Accident_Count,
    SUM(COUNT(*)) OVER() AS Total_Accidents
FROM dbo.Fact_Accidents
GROUP BY Severity
ORDER BY Severity;


/* =========================================================
   TIME ANALYSIS
   ========================================================= */



/* #1. How has the number of recorded accidents changed over the years? */

SELECT
    T.Year,
    COUNT(*) AS Accident_Count
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Time T
    ON F.Time_ID = T.Time_ID
GROUP BY T.Year
ORDER BY T.Year;


/* #2. Which months have the highest number of recorded accidents? */

SELECT
    T.Month,
    COUNT(*) AS Accident_Count
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Time T
    ON F.Time_ID = T.Time_ID
GROUP BY T.Month
ORDER BY Accident_Count DESC;


/* #3. Which days of the week have the most recorded accidents? */

SELECT
    T.Day_of_Week,
    COUNT(*) AS Accident_Count
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Time T
    ON F.Time_ID = T.Time_ID
GROUP BY T.Day_of_Week
ORDER BY Accident_Count DESC;


/* #4. At what hours do most accidents occur? */

SELECT
    T.Hour,
    COUNT(*) AS Accident_Count
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Time T
    ON F.Time_ID = T.Time_ID
GROUP BY T.Hour
ORDER BY Accident_Count DESC;


/* =========================================================
   LOCATION ANALYSIS
   ========================================================= */


/* #5. Which states have the highest number of recorded accidents? */

SELECT TOP 10
    L.State,
    COUNT(*) AS Accident_Count
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Location L
    ON F.Location_ID = L.Location_ID
GROUP BY L.State
ORDER BY Accident_Count DESC;


/* #6. Which cities have the highest number of recorded accidents? */

SELECT TOP 10
    L.City,
    L.State,
    COUNT(*) AS Accident_Count
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Location L
    ON F.Location_ID = L.Location_ID
GROUP BY L.City, L.State
ORDER BY Accident_Count DESC;


/* #7. Where are the geographic hotspots of recorded accidents? */

SELECT TOP 20
    L.State,
    L.City,
    L.Start_Lat,
    L.Start_Lng,
    COUNT(*) AS Accident_Count
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Location L
    ON F.Location_ID = L.Location_ID
GROUP BY
    L.State,
    L.City,
    L.Start_Lat,
    L.Start_Lng
ORDER BY Accident_Count DESC;


/* =========================================================
   WEATHER ANALYSIS
   ========================================================= */


/* #8. Which weather conditions are most commonly associated with recorded accidents? */

SELECT TOP 10
    W.Weather_Condition,
    COUNT(*) AS Accident_Count
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Weather W
    ON F.Weather_ID = W.Weather_ID
GROUP BY W.Weather_Condition
ORDER BY Accident_Count DESC;


/* =========================================================
   SEVERITY & ROAD ANALYSIS
   ========================================================= */


/* #9. How does accident severity vary between daytime and nighttime? */

SELECT
    T.Sunrise_Sunset AS Time_Period,
    F.Severity,
    COUNT(*) AS Accident_Count
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Time T
    ON F.Time_ID = T.Time_ID
GROUP BY
    T.Sunrise_Sunset,
    F.Severity
ORDER BY
    T.Sunrise_Sunset,
    F.Severity;


/* #10. Which road features are associated with a higher proportion of severe accidents? */

SELECT
    R.Road_Feature_ID,
    COUNT(*) AS Total_Accidents,
    SUM(CASE WHEN F.Severity IN (3,4) THEN 1 ELSE 0 END) AS Severe_Accidents,
    SUM(CASE WHEN F.Severity IN (3,4) THEN 1 ELSE 0 END) * 100.0
        / COUNT(*) AS Severe_Percentage
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Road_Features R
    ON F.Road_Feature_ID = R.Road_Feature_ID
GROUP BY R.Road_Feature_ID
HAVING COUNT(*) >= 100
ORDER BY Severe_Percentage DESC;

/* =========================================================
   ADDITIONAL IMPORTANT ANALYSIS
   ========================================================= */


/* #11. What is the overall distribution of accident severity? */

SELECT
    Severity,
    COUNT(*) AS Accident_Count,
    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER()
        AS DECIMAL(10,2)
    ) AS Percentage
FROM dbo.Fact_Accidents
GROUP BY Severity
ORDER BY Severity;


/* #12. What is the average accident distance by severity? */

SELECT
    Severity,
    COUNT(*) AS Accident_Count,
    CAST(AVG([Distance(mi)]) AS DECIMAL(10,2)) AS Avg_Distance
FROM dbo.Fact_Accidents
GROUP BY Severity
ORDER BY Severity;


/* #13. Are accidents more common on weekdays or weekends? */

SELECT
    T.Day_Type,
    COUNT(*) AS Accident_Count,
    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER()
        AS DECIMAL(10,2)
    ) AS Percentage
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Time T
    ON F.Time_ID = T.Time_ID
GROUP BY T.Day_Type
ORDER BY Accident_Count DESC;


/* #14. Which states have the highest proportion of severe accidents? */

SELECT TOP 10
    L.State,
    COUNT(*) AS Total_Accidents,
    SUM(CASE WHEN F.Severity IN (3,4) THEN 1 ELSE 0 END) AS Severe_Accidents,
    SUM(CASE WHEN F.Severity IN (3,4) THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Severe_Percentage
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Location L
    ON F.Location_ID = L.Location_ID
GROUP BY L.State
HAVING COUNT(*) >= 500
ORDER BY Severe_Percentage DESC;


/* #15. Which weather conditions have the highest accident severity? */

SELECT TOP 10
    W.Weather_Condition,
    COUNT(*) AS Accident_Count,
    COUNT(CASE WHEN F.Severity >= 3 THEN 1 END) AS Severe_Accidents
FROM dbo.Fact_Accidents F
JOIN dbo.Dim_Weather W
    ON F.Weather_ID = W.Weather_ID
GROUP BY W.Weather_Condition
HAVING COUNT(*) >= 100
ORDER BY Severe_Accidents DESC;