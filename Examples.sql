-- Example 1: Query for mining all data FROM summer 2020  ANDwinter 2020/2021
SELECT
	*
FROM t_petr_jíša_project_sql_final
WHERE 
	season in (0, 2)
	AND date > '2020-05-31'
ORDER BY date;

-- Example 2: Query for mining only the epidemiological data, WHERE performed tests are accessible
-- Adding the ratio of positive tests, confirmed on million  ANDdeaths on milion
SELECT
	date,
	country,
	confirmed,
	deaths,
	tests_performed,
	round(confirmed/tests_performed * 100, 1) as 'tests_positivity_%',
	round(confirmed*1000000/population, 1) as confirmed_on_million,
	round(deaths*1000000/population, 1) as deaths_on_million
FROM t_petr_jíša_project_sql_final
WHERE tests_performed is not null
ORDER BY date;

-- Example 3: Query for mining the "dense" data with minimum occurence of the NULL cells
SELECT
	*
FROM t_petr_jíša_project_sql_final
WHERE 
	1 = 1 
	AND gini_coeficient IS NOT NULL
	AND unit_GDP IS NOT NULL 
	AND avg_temperature IS NOT NULL 
	AND tests_performed IS NOT NULL
	AND date >= '2020-04-01'
ORDER BY date;

-- THE FOLLOWING PART GIVES EXAMPLE OF HOW THE TABLE CAN BE USED FOR FINDING OF THE PROBLEMATIC DATA
-- THESE PROBLEMATIC DATA COME FROM THE DATABASE, NOT FROM A WRONG PROJECT SOLUTION
-- ONCE THE PROBLEM IS FOUND, IT ALSO CAN BE SOLVED... 

-- Example 4 (WHERE the problem was found): Query for mining the maximum daily percentage of positive tests for countries where Christianity religion dominates over the other religions
-- This table also shows that in many CASEs, there is a problem with compatibility of the data regarding confirmed  ANDperformed tests
-- For 14 countries, there is maximum of the ratio between positive tests  ANDperformed tests over 100 %
-- Even the values between 90 - 100 % which are present for 4 countries give a warning signal 
SELECT
	country,
	`Christianity (%)`,
	round(max(confirmed*100/tests_performed), 1) as 'max_%_ratio_of_positive_tests'
FROM t_petr_jíša_project_sql_final
WHERE 
	1 = 1
	 AND `Christianity (%)` > `Islam (%)`
	 AND `Christianity (%)` > `Buddhism (%)`
	 AND `Christianity (%)` > `Folk Religions (%)` 
	 AND `Christianity (%)` > `Hinduism (%)`
	 AND `Christianity (%)` > `Judaism (%)` 
	 AND `Christianity (%)` > `Buddhism (%)`
	 AND `Christianity (%)` > `Unaffiliated religions (%)`
	 AND tests_performed IS NOT NULL
	GROUP BY country, `Christianity (%)` 
	ORDER BY max(confirmed*100/tests_performed) DESC;


-- Example 5: Query to find the countries, WHERE maximum percentage of positive tests exceeds 100 %
-- It shows all problematic countries WHERE the relation between positive  ANDperformed tests may be problematic
-- The amount of such countries is 19
-- The data for these countries should be explored more in detail
SELECT
	country,
	round(max(confirmed*100/tests_performed), 1) as 'max_%_ratio_of_positive_tests'
FROM t_petr_jíša_project_sql_final
WHERE tests_performed is not null
GROUP BY country
having max(confirmed*100/tests_performed) > 100
ORDER BY max(confirmed*100/tests_performed) DESC;

-- Example 6: What is the amount of data records for each country, WHERE the ratio between confirmed  ANDperformed tests is above 100 % ??
-- After this query execution, we can see 82 amount of records in Peru (really problematic)  AND17 in Mexico (still not good)
-- Amount of these CASEs for the other countries is up to 5 (only exceptions)
-- Now we can decide what to do with data FROM these countries, where there are big problems, where there are only exceptions, etc.
SELECT
	country,
	count(confirmed*100/tests_performed) as Positivity_overmatches_tests_in_x_days
FROM t_petr_jíša_project_sql_final
WHERE 
	tests_performed IS NOT NULL
	AND confirmed/tests_performed > 1
GROUP BY country
ORDER BY Positivity_overmatches_tests_in_x_days DESC;