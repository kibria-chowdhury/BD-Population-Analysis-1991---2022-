-- 1. Calculate the population density (population per square kilometer) for each district in 2022
SELECT
	name,
	Population_2022/area_km2 as "Population Density"
FROM bd_city;

-- 2. Which district has the highest population density?
SELECT name, Population_2022 / area_km2 AS population_density
FROM bd_city
ORDER BY population_density DESC
LIMIT 1;

-- alternative solution using subquery(2)

SELECT name, Population_2022 / area_km2 AS density
FROM bd_city
WHERE Population_2022 / area_km2 = (
  SELECT MAX(Population_2022 / area_km2)
  FROM bd_city
);

-- 3. Identify how many districts that were established after 1984
SELECT count(*)
FROM bd_city
WHERE established >= 1984;

-- 4. Identify how many districts were established before 1984
WITH dist_count AS (
  SELECT COUNT(*) AS total_districts
  FROM bd_city
),
after_1984 AS (
  SELECT COUNT(*) AS districts_after_1984
  FROM bd_city
  WHERE established >= 1984
)
SELECT
  dc.total_districts - a84.districts_after_1984 AS districts_before_1984
FROM dist_count dc
CROSS JOIN after_1984 a84;

-- 5. How does the population growth percentage of districts that were established before 1984?
SELECT CONCAT(ROUND(AVG((Population_2022 - Population_1991) * 100.0 / Population_1991), 2), '%') AS average_growth
FROM bd_city
WHERE established < 1984;


-- 6. Are newer districts (based on the "Established" column) growing faster or slower than older districts?
WITH P_growth AS (
SELECT *,
	(Population_2022 - Population_1991)* 100.0/Population_1991 AS "Pop Growth",
	CASE 
		WHEN established >= 1984 THEN 'New'
		ELSE 'Old'
	END AS "District Type"
FROM
	bd_city
)
SELECT
	"District Type",
	concat(round(AVG("Pop Growth"),2),'%') AS "Average Growth"
FROM
	P_growth
GROUP BY "District Type";

-- 7. Predict the population of each district in 2030 based on historical trends from 1991 to 2022. 

WITH pop_years AS (
    SELECT 
        name,
        unnest(ARRAY[1991, 2001, 2011, 2022])::INT AS year,
        unnest(ARRAY[Population_1991, Population_2001, Population_2011, Population_2022])::BIGINT AS population
    FROM bd_city
),
stats AS (
    SELECT
        name,
        COUNT(*) AS n,
        SUM(year) AS sum_x,
        SUM(population) AS sum_y,
        SUM(year::BIGINT * population) AS sum_xy,         -- Force BIGINT multiplication
        SUM((year::BIGINT) * (year::BIGINT)) AS sum_x2    -- Force BIGINT multiplication
    FROM pop_years
    GROUP BY name
),
regression AS (
    SELECT
        name,
        (n * sum_xy - sum_x * sum_y)::NUMERIC / NULLIF((n * sum_x2 - sum_x * sum_x), 0) AS slope,
        (sum_y::NUMERIC - ((n * sum_xy - sum_x * sum_y)::NUMERIC / NULLIF((n * sum_x2 - sum_x * sum_x), 0)) * sum_x)::NUMERIC / n AS intercept
    FROM stats
),
predicted_2030 AS (
    SELECT
        name,
        ROUND((slope * 2030 + intercept))::BIGINT AS Predicted_Population_2030
    FROM regression
)
SELECT 
    bd.name,
    bd.division,
    bd.Population_2022,
    p.Predicted_Population_2030
FROM bd_city bd
JOIN predicted_2030 p ON bd.name = p.name
ORDER BY division, name;

-- 8. What percentage of population growth is each district experiencing from 2011 to 2022?

SELECT
	name,
	Population_2011,
	Population_2022,
	concat(round(((Population_2022 - Population_2011) * 100.0/Population_2011),2),'%') AS P_growth_from_2011_to_2022
FROM
	bd_city
ORDER BY round(((Population_2022 - Population_2011) * 100.0/Population_2011),2) DESC;

-- 9. If the population of each district continues to grow at the same rate as between 2011 and 2022, what will be the population of Bangladesh in 2035?

WITH growth AS(
SELECT
	name,
	Population_2011,
	Population_2022,
	POWER((Population_2022::NUMERIC/ NULLIF(Population_2011,0)), 1.0/11) - 1 AS compound_annual_growth_rate
FROM
	bd_city
), pop_2035_per_dis AS(
SELECT
name,
Population_2022,
ROUND(Population_2022::NUMERIC * POWER(1 + compound_annual_growth_rate, 13)) AS Projected_Population_2035
FROM
	growth
)
SELECT
SUM(Projected_Population_2035) AS Population_2035
FROM pop_2035_per_dis

-- 10. Is there any correlation between a district's area and its population in 2022?

SELECT
CORR(area_km2,population_2022)
FROM bd_city;



