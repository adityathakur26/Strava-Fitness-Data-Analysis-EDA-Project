create database strava_fitness;
show databases;
use strava_fitness;
show tables ;

-- -------------------------------------------------------------------- Data Cleaning ---------------------------------------------------------------------------------------
select count(*) from daily_activity;
DESCRIBE daily_activity;
DESCRIBE sleep_day;
DESCRIBE body_metrics;
alter table sleep_day modify SleepDay datetime;

SELECT *
FROM daily_activity
WHERE Id IS NULL
   OR ActivityDate IS NULL
   OR TotalSteps IS NULL
   OR Calories IS NULL;

DELETE FROM daily_activity
WHERE Id IS NULL OR ActivityDate IS NULL;

set sql_safe_updates = 0;
SELECT
SUM(Id IS NULL) AS null_id,
SUM(ActivityDate IS NULL) AS null_date,
SUM(TotalSteps IS NULL) AS null_steps,
SUM(Calories IS NULL) AS null_calories
FROM daily_activity;

-- sleep 
SELECT *
FROM sleep_day
WHERE Id IS NULL
   OR SleepDay IS NULL
   OR TotalMinutesAsleep IS NULL;

SELECT
SUM(Id IS NULL) AS null_id,
SUM(SleepDay IS NULL) AS null_date,
SUM(TotalMinutesAsleep IS NULL) AS null_sleep
FROM sleep_day;

DELETE FROM sleep_day
WHERE SleepDay IS NULL;	

-- body_metrics
SELECT *
FROM body_metrics
WHERE Id IS NULL
   OR Date IS NULL
   OR WeightKg IS NULL
   OR BMI IS NULL;

SELECT
SUM(Id IS NULL) AS null_id,
SUM(Date IS NULL) AS null_date,
SUM(WeightKg IS NULL) AS null_weight,
SUM(BMI IS NULL) AS null_bmi
FROM body_metrics;

DELETE FROM body_metrics
WHERE WeightKg IS NULL;

ALTER TABLE daily_activity
MODIFY Id BIGINT,
MODIFY ActivityDate DATE,
MODIFY TotalSteps INT,
MODIFY TotalDistance FLOAT,
MODIFY Calories INT;

ALTER TABLE sleep_day
MODIFY Id BIGINT,
MODIFY SleepDay DATETIME,
MODIFY TotalSleepRecords INT,
MODIFY TotalMinutesAsleep INT,
MODIFY TotalTimeInBed INT;

ALTER TABLE body_metrics
MODIFY Id BIGINT,
MODIFY Date DATE,
MODIFY WeightKg FLOAT,
MODIFY BMI FLOAT,
MODIFY IsManualReport BOOLEAN;

SELECT *
FROM sleep_day
WHERE SleepDay = '';

UPDATE sleep_day
SET SleepDay = NULL
WHERE SleepDay = '';

UPDATE sleep_day
SET SleepDay = STR_TO_DATE(SleepDay,'%m/%d/%Y %r')
WHERE SleepDay LIKE '%/%';

ALTER TABLE sleep_day
MODIFY SleepDay DATETIME;

UPDATE body_metrics
SET IsManualReport = 1
WHERE IsManualReport = 'True';
UPDATE body_metrics
SET IsManualReport = 0
WHERE IsManualReport = 'False';


ALTER TABLE body_metrics
MODIFY IsManualReport BOOLEAN;

SELECT *
FROM sleep_day
WHERE TotalSleepRecords = ''
   OR TotalMinutesAsleep = ''
   OR TotalTimeInBed = '';
   
UPDATE sleep_day
SET
TotalSleepRecords = NULLIF(TotalSleepRecords,''),
TotalMinutesAsleep = NULLIF(TotalMinutesAsleep,''),
TotalTimeInBed = NULLIF(TotalTimeInBed,'');

UPDATE sleep_day
SET SleepDay = STR_TO_DATE(SleepDay,'%m/%d/%Y %r')
WHERE SleepDay IS NOT NULL;

describe sleep_day;
SHOW CREATE TABLE sleep_day;
alter table sleep_day drop column sleepday;
SELECT ActivityDate, SleepDay
FROM sleep_day
LIMIT 10;

ALTER TABLE sleep_day
MODIFY ActivityDate DATE;

ALTER TABLE sleep_day
MODIFY Id BIGINT,
MODIFY SleepDay DATETIME,
MODIFY TotalSleepRecords INT,
MODIFY TotalMinutesAsleep INT,
MODIFY TotalTimeInBed INT;

describe daily_activity;
SELECT *
FROM daily_activity
WHERE ActivityDate IS NULL
   OR TotalSteps IS NULL
   OR Calories IS NULL;
   
UPDATE daily_activity
SET TotalSteps = NULLIF(TotalSteps,''),
Calories = NULLIF(Calories,'');

SELECT
SUM(ActivityDate IS NULL) AS null_dates,
SUM(TotalSteps IS NULL) AS null_steps,
SUM(Calories IS NULL) AS null_calories
FROM daily_activity;

select sum(date is null), sum(weightkg is null), sum(bmi is null)
from body_metrics; 

select count(*) from body_metrics;

ALTER TABLE body_metrics
MODIFY Id BIGINT,
MODIFY Date DATE,
MODIFY WeightKg FLOAT,
MODIFY BMI FLOAT,
MODIFY IsManualReport BOOLEAN;

DELETE FROM body_metrics
WHERE date IS NULL;

UPDATE body_metrics
SET
Date = NULLIF(Date,''),
WeightKg = NULLIF(WeightKg,''),
BMI = NULLIF(BMI,'');

SELECT *
FROM body_metrics
WHERE Date is null
   OR WeightKg is null
   OR BMI is null;
   
--  ---------------------------------------------------------------- Creating user Table and creating relationships ----------------------------------------------------
CREATE TABLE users (
user_id BIGINT PRIMARY KEY
);

INSERT INTO users (user_id)
SELECT DISTINCT Id FROM daily_activity
UNION
SELECT DISTINCT Id FROM sleep_day
UNION
SELECT DISTINCT Id FROM body_metrics;

ALTER TABLE daily_activity
CHANGE Id user_id BIGINT;
ALTER TABLE sleep_day
CHANGE Id user_id BIGINT;
ALTER TABLE body_metrics
CHANGE Id user_id BIGINT;

ALTER TABLE daily_activity
DROP PRIMARY KEY;
ALTER TABLE daily_activity
ADD PRIMARY KEY (user_id, ActivityDate);
ALTER TABLE sleep_day
ADD PRIMARY KEY (user_id, ActivityDate);

SELECT user_id, Date, COUNT(*)
FROM body_metrics
GROUP BY user_id, Date
HAVING COUNT(*) > 1;
DELETE bm1
FROM body_metrics bm1
JOIN body_metrics bm2
ON bm1.user_id = bm2.user_id
AND bm1.Date = bm2.Date
AND bm1.LogId > bm2.LogId;
ALTER TABLE body_metrics
ADD PRIMARY KEY (user_id, Date);

SELECT user_id, Date, COUNT(*)
FROM body_metrics
GROUP BY user_id, Date
HAVING COUNT(*) > 1;

SELECT *
FROM body_metrics
WHERE user_id = 1503960366
AND Date = '2016-05-03';

DELETE bm1
FROM body_metrics bm1
JOIN body_metrics bm2
ON bm1.user_id = bm2.user_id
AND bm1.Date = bm2.Date
AND bm1.LogId > bm2.LogId;

ALTER TABLE body_metrics
ADD PRIMARY KEY (LogId);
SELECT LogId, COUNT(*)
FROM body_metrics
GROUP BY LogId
HAVING COUNT(*) > 1;

describe body_metrics;
describe daily_activity;
describe sleep_day;
describe users;

alter table body_metrics modify activitydate date;

ALTER TABLE body_metrics
ADD metric_id INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE body_metrics
MODIFY metric_id INT AUTO_INCREMENT;

ALTER TABLE body_metrics
ADD CONSTRAINT fk_metrics_user
FOREIGN KEY (user_id)
REFERENCES users(user_id);

ALTER TABLE daily_activity
ADD CONSTRAINT fk_activity_user
FOREIGN KEY (user_id)
REFERENCES users(user_id);

ALTER TABLE sleep_day
ADD CONSTRAINT fk_sleep_user
FOREIGN KEY (user_id)
REFERENCES users(user_id);

-- ----------------------------------------------------------------------------- Queries ---------------------------------------------------------------------------
-- most active users
select count(*) as total_users from users;

-- users with highest calorie burn
select user_id, avg(totalsteps) as avg_daily_steps 
from daily_activity group by user_id order by avg_daily_steps desc;

-- user with the best sleep duration
SELECT user_id,
       AVG(TotalMinutesAsleep) AS avg_sleep
FROM sleep_day
GROUP BY user_id;

-- checks active user sleeps more
SELECT d.user_id,
       AVG(d.TotalSteps) AS avg_steps,
       AVG(s.TotalMinutesAsleep) AS avg_sleep
FROM daily_activity d
JOIN sleep_day s
ON d.user_id = s.user_id
AND d.ActivityDate = s.ActivityDate
GROUP BY d.user_id;

-- most active days in dataset
SELECT user_id,
       ActivityDate,
       TotalSteps
FROM daily_activity
ORDER BY TotalSteps DESC
LIMIT 5;

-- average bmi per user
SELECT user_id,
       AVG(BMI) AS avg_bmi
FROM body_metrics
GROUP BY user_id;

-- average weight tren 
SELECT user_id,
       AVG(WeightKg) AS avg_weight
FROM body_metrics
GROUP BY user_id;

-- bmi category of all users
SELECT user_id,
       AVG(BMI) AS avg_bmi,
       CASE
           WHEN AVG(BMI) < 18.5 THEN 'Underweight'
           WHEN AVG(BMI) BETWEEN 18.5 AND 24.9 THEN 'Normal'
           WHEN AVG(BMI) BETWEEN 25 AND 29.9 THEN 'Overweight'
           ELSE 'Obese'
       END AS bmi_category
FROM body_metrics
GROUP BY user_id;

-- User with Best Sleep Quality
SELECT user_id,
       AVG(TotalMinutesAsleep / TotalTimeInBed) AS sleep_efficiency
FROM sleep_day
GROUP BY user_id
ORDER BY sleep_efficiency DESC;

-- Overall trend of all users
SELECT 
AVG(TotalSteps) AS avg_steps,
AVG(Calories) AS avg_calories
FROM daily_activity;