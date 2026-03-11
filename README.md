Smart Fitness Tracker Data Analysis (EDA Project)

📌 Project Overview
This project analyzes smart fitness tracker data (Strava/Fitbit-style) to understand user behavior patterns related to activity, sleep, calories, and BMI. The goal is to generate actionable insights that can help improve marketing strategies, user engagement, and product positioning.
The analysis focuses on daily-level data and follows industry-standard data cleaning, merging, and exploratory data analysis (EDA) practices.
_______________________________________
🎯 Business Objective
•	Understand how users engage with fitness tracking features
•	Identify behavior patterns across activity, sleep, and health metrics
•	Support data-driven marketing and personalization strategies
________________________________________
📂 Datasets Used
Only daily-level datasets were used to ensure consistency and business relevance.
Core Datasets
•	dailyActivity_merged.csv – Base dataset (steps, distance, calories, intensity)
•	dailyCalories_merged.csv – Daily calorie burn
•	dailySteps_merged.csv – Daily step counts
•	sleepDay_merged.csv – Sleep duration and sleep efficiency
•	weightLogInfo_merged.csv – Weight and BMI information (sparse)
Datasets Excluded
The following datasets were excluded due to excessive granularity (hourly/minute-level) or lack of relevance for marketing analysis: - hourly, minute, heartrate_seconds_merged.csv
________________________________________
Data Cleaning & Preparation
Common Steps
•	Converted date columns to proper datetime/date formats
•	Removed duplicate sleep records
•	Handled null values using business-aware strategies
Null Handling Strategy
•	Sleep data: Missing values retained (indicates non-usage of sleep tracking)
•	BMI/Weight data: Sparse columns removed; BMI used only where available
•	No artificial imputation was performed to avoid bias
________________________________________
Analytical DataFrames Created
Instead of merging all datasets into one table, three purpose-driven dataframes were created:
•	daily_activity
Purpose: Core activity and calorie analysis - Daily steps vs calories - Activity intensity patterns - User activity segmentation
•	sleep_day
Purpose: Lifestyle and engagement analysis - Sleep tracking behavior - Sleep vs activity consistency - User engagement insights
•	body_metrics
Purpose: Health outcome analysis - BMI vs activity level - BMI vs calorie expenditure
This modular approach reduces sparsity and improves interpretability.
________________________________________
📊 Key Business Questions Answered
1.	How does daily activity (steps and intensity) impact calories burned?
2.	Are users who track sleep more consistent in daily activity?
3.	Can users be segmented into behavioral groups based on activity, sleep, and BMI?
________________________________________
MySQL Query Set 
•	The cleaned fitness tracker datasets were imported into MySQL to perform structured data storage, normalization, and analytical querying. The CSV files that were previously cleaned and prepared using Python were loaded into MySQL tables using the MySQL Workbench Table Data Import Wizard.
•	Three datasets were imported:
1.	daily_activity.csv
2.	sleep_day.csv
3.	body_metrics.csv
•	A common user identifier (user_id) is used to link data across multiple tables such as daily activity, sleep records, and body metrics.
________________________________________
📊 PowerBI  
Power BI’s visualization capabilities, multiple dashboards were developed to analyze different aspects of user behavior.

The User Activity Dashboard focuses on physical activity patterns such as steps taken, calories burned, and active minutes. 
The Sleep Analysis Dashboard examines sleep duration, sleep efficiency, and variations in sleeping patterns. 
The Body Metrics Dashboard analyzes weight trends and BMI distribution to understand overall health indicators.
Finally, an Insights and Business Recommendations Dashboard summarizes key findings from the analysis and provides data-driven recommendations for improving user engagement and promoting healthier lifestyle habits. 

The use of Power BI enables stakeholders to quickly interpret complex datasets and supports informed decision-making through visual analytics.

Dashboard 1:
 
Dashboard 2:

Dashboard 3:

Dashboard 4:
________________________________________
🔍 Key Insights (Summary)
•	Higher steps and active minutes are strongly associated with higher calorie burn
•	Sleep duration alone does not show a strong linear relationship with activity levels
•	Users who track sleep tend to be more consistent in activity
•	BMI data is sparse but shows variation across activity segments
•	Users can be meaningfully segmented into sedentary, moderately active, and highly active groups
________________________________________
💡 Business Recommendations
•	Promote sleep tracking as part of a holistic fitness experience
•	Target sedentary users with motivational nudges and challenges
•	Offer performance-focused features to highly active users
•	Use behavior-based segmentation for personalized marketing campaigns
________________________________________
🛠 Tools & Technologies
•	Language: Python
•	Libraries: Pandas, Matplotlib, Seaborn
•	Environment: Jupyter Notebook / MySQL / PowerBI
________________________________________
Author: Aditya Thakur



