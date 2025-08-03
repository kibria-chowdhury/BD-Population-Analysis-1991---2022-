# 🇧🇩 Bangladesh District-Level Population Analysis

This project explores population trends, growth, and statistics of districts in Bangladesh using a dataset bd_city.csv. It includes SQL queries for analytical insights and future projections using historical data from 1991 to 2022.

## Correlation Between Area(km2) and Population_2022
<img src="Images/Correlation Between Area(km2) and Population_2022.png" width="500"/>

## Growth Rate Comparison
<img src="Images/Growth Rate Comparison.png" width="500"/>

## Predicted Population in 2030
<img src="Images/Predicted Population in 2030.png" width="500"/>



## Dataset

- bd_city.csv — Contains demographic and geographic data on all districts in Bangladesh.
- Columns include:
  - name, division, area_km2
  - Population_1991, Population_2001, Population_2011, Population_2022
  - established

## 🧠 Key Questions Answered

1. **Population Density in 2022**  
2. **District with Highest Density**
3. **Districts Established After 1984**
4. **Count of Districts Established Before 1984**
5. **Average Population Growth for Older Districts**
6. **Comparison: New vs. Old District Growth**
7. **Predicted 2030 Population (Linear Regression)**
8. **Growth Rate from 2011 to 2022**
9. **Estimated Population in 2035 (CAGR Method)**
10. **Correlation Between Area and Population**

## Tools Used

- PostgreSQL
- Common Table Expressions (CTEs)
- Aggregate functions (SUM, AVG, MAX, CORR)
- Linear regression & CAGR projections

## File Structure

- bd_city_population_analysis.sql — Main SQL script answering all questions
- bd_city.csv — Sample dataset (not included here)
- README.md — This file

## How to Run

1. Import bd_city.csv into a PostgreSQL-compatible SQL database.
2. Run queries from the .sql file in your SQL environment.
3. Analyze the output per question.

## Insights

- Older districts tend to show more stable growth.
- Dhaka remains the most densely populated district.
- Strong correlation observed between population and area in some regions.
- 2035 projections help visualize demographic pressure.

## Author

Built by Golam Kibria Chowdhury 
Data Analysis Portfolio • 2025  
