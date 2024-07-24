CREATE TABLE cheese_production (
Year INTEGER,
Period TEXT,
Geo_Level TEXT,
State_ANSI INTEGER,
Commodity_ID INTEGER,
Domain TEXT,
Value INTEGER
);


CREATE TABLE honey_production (
Year INTEGER,
Geo_Level TEXT,
State_ANSI INTEGER,
Commodity_ID INTEGER,
Value INTEGER
);


CREATE TABLE milk_production (
Year INTEGER,
Period TEXT,
Geo_Level TEXT,
State_ANSI INTEGER,
Commodity_ID INTEGER,
Domain TEXT,
Value INTEGER
);


CREATE TABLE coffee_production (
Year INTEGER,
Period TEXT,
Geo_Level TEXT,
State_ANSI INTEGER,
Commodity_ID INTEGER,
Value INTEGER
);


CREATE TABLE egg_production (
Year INTEGER,
Period TEXT,
Geo_Level TEXT,
State_ANSI INTEGER,
Commodity_ID INTEGER,
Value INTEGER
);


CREATE TABLE state_lookup (
State TEXT,
State_ANSI INTEGER
);


CREATE TABLE yogurt_production (
Year INTEGER,
Period TEXT,
Geo_Level TEXT,
State_ANSI INTEGER,
Commodity_ID INTEGER,
Domain TEXT,
Value INTEGER
);

UPDATE cheese_production SET Value = REPLACE(value,',','');
UPDATE honey_production SET Value  = REPLACE(value,',','');
UPDATE milk_production SET Value = REPLACE(value,',','');
UPDATE coffee_production SET Value = REPLACE(value,',','');
UPDATE egg_production SET Value = REPLACE(value,',','');
UPDATE yogurt_production SET Value = REPLACE(value,',','');

P1. Find the total milk production for the year 2023.

SELECT "Year",
SUM(Value) AS TotalProduction
FROM milk_production mp 
WHERE "Year" = '2023';

P2. Show coffee production data for the year 2015. What is the total value?

SELECT "Year",
SUM (Value)
FROM coffee_production cp 
WHERE "Year" = '2015';

P3. Find the average honey production for the year 2022.

SELECT YEAR,
AVG (Value) 
FROM honey_production hp 
WHERE "Year" = '2022';

P4. Get the state names with their corresponding ANSI codes from the state_lookup table. What number is Iowa?

SELECT State,
State_ANSI
FROM state_lookup sl 
WHERE State = 'IOWA';

P5. Find the highest yogurt production value for the year 2022.

SELECT YEAR,
MAX(Value) 
FROM yogurt_production yp 
WHERE YEAR = '2022';

P6. Find states where both honey and milk were produced in 2022. Did State_ANSI "35" produce both honey and milk in 2022?

SELECT DISTINCT h.State_ANSI FROM honey_production h
JOIN milk_production m ON h.State_ANSI = m.State_ANSI
WHERE h.Year = 2022 AND m.Year = 2022;

P7. Find the total yogurt production for states that also produced cheese in 2022.

SELECT SUM(yp.Value)
FROM yogurt_production yp
WHERE yp.Year = 2022 AND yp.State_ANSI IN (
    SELECT DISTINCT cp.State_ANSI FROM cheese_production cp WHERE cp.Year = 2022
);

F1. Can you find out the total milk production for 2023? Your manager wants this information for the yearly report. What is the total milk production for 2023?

SELECT SUM(Value)
FROM milk_production
WHERE Year = 2023;

F2. Which states had cheese production greater than 100 million in April 2023? The Cheese Department wants to focus their marketing efforts there. How many states are there?

SELECT sl.State,
cp.State_ANSI,
SUM(cp.Value) AS TotalProduction,
cp."Year" ,
cp.Period 
FROM cheese_production cp INNER JOIN state_lookup sl ON cp.State_ANSI = sl.State_ANSI 
GROUP BY cp.State_ANSI 
HAVING cp."Year" = '2023' AND cp.Period = 'APR' AND SUM(cp.Value) > 100000000;

F3. Your manager wants to know how coffee production has changed over the years. What is the total value of coffee production for 2011?

SELECT "Year",
SUM (Value)
FROM coffee_production cp 
WHERE "Year" = '2011';

F4. Theres a meeting with the Honey Council next week. Find the average honey production for 2022 so youre prepared.

SELECT YEAR,
AVG (Value) AS AVG_Value
FROM honey_production hp 
WHERE YEAR = '2022';

F5. The State Relations team wants a list of all states names with their corresponding ANSI codes. Can you generate that list? What is the State_ANSI code for Florida?

SELECT *
FROM state_lookup sl;

F6. For a cross-commodity report, can you list all states with their cheese production values, even if they didnt produce any cheese in April of 2023? What is the total for NEW JERSEY?

SELECT sl.State, 
cp.Value
FROM state_lookup sl LEFT JOIN cheese_production cp ON sl.State_ANSI = cp.State_ANSI 
AND cp.Year = 2023 AND cp.Period = 'APR';

F7. Can you find the total yogurt production for states in the year 2022 which also have cheese production data from 2023? This will help the Dairy Division in their planning.

SELECT SUM(yp.Value)
FROM yogurt_production yp
WHERE yp.Year = '2022' AND yp.State_ANSI IN (
    SELECT DISTINCT cp.State_ANSI FROM cheese_production cp WHERE cp.Year = '2023'
);

F8. List all states from state_lookup that are missing from milk_production in 2023. How many states are there?

SELECT sl.State,
mp.YEAR
FROM state_lookup sl LEFT JOIN milk_production mp ON sl.State_ANSI = mp.State_ANSI AND mp."Year" ='2023'
WHERE mp."Year" IS NULL;

F9. List all states with their cheese production values, including states that didnt produce any cheese in April 2023. Did Delaware produce any cheese in April 2023?

SELECT sl.State,
cp.Value
FROM state_lookup sl
LEFT JOIN cheese_production cp ON sl.State_ANSI = cp.State_ANSI AND cp.Year = 2023 AND cp.Period = 'APR';

F10. Find the average coffee production for all years where the honey production exceeded 1 million.

SELECT AVG(cp.Value) 
FROM coffee_production cp 
WHERE cp.YEAR IN (SELECT hp."Year"
FROM honey_production hp 
GROUP BY hp."Year"
HAVING hp.Value > 1000000);