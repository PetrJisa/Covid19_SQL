-- Example 1: Query for mining all data from summer 2020 and winter 2020/2021
SELECT
	*
from t_petr_jíša_project_sql_final
where 
	season in (0, 2)
	and date > '2020-05-31'
order by date;

-- Example 2: Query for mining only the epidemiological data, where performed tests are accessible
-- Adding the ratio of positive tests, confirmed on million and deaths on milion
SELECT
	date,
	country,
	confirmed,
	deaths,
	tests_performed,
	round(confirmed/tests_performed * 100, 1) as 'tests_positivity_%',
	round(confirmed*1000000/population, 1) as confirmed_on_million,
	round(deaths*1000000/population, 1) as deaths_on_million
from t_petr_jíša_project_sql_final
where tests_performed is not null
order by date;

-- Example 3: Query for mining the "dense" data with minimum occurence of the NULL cells
SELECT
	*
from t_petr_jíša_project_sql_final
where 
	1 = 1 
	and gini_coeficient is not null
	and unit_GDP is not null 
	and avg_temperature is not null 
	and tests_performed is not null
	and date >= '2020-04-01'
order by date;

-- THE FOLLOWING PART GIVES EXAMPLE OF HOW THE TABLE CAN BE USED FOR FINDING OF THE PROBLEMATIC DATA
-- THESE PROBLEMATIC DATA COME FROM THE DATABASE, NOT FROM A WRONG PROJECT SOLUTION
-- ONCE THE PROBLEM IS FOUND, IT ALSO CAN BE SOLVED... 

-- Example 4 (where the problem was found): Query for mining the maximum daily percentage of positive tests for countries where Christianity religion dominates over the other religions
-- This table also shows that in many cases, there is a problem with compatibility of the data regarding confirmed and performed tests
-- For 14 countries, there is maximum of the ratio between positive tests and performed tests over 100 %
-- Even the values between 90 - 100 % which are present for 4 countries give a warning signal 
SELECT
	country,
	`Christianity (%)`,
	round(max(confirmed*100/tests_performed), 1) as 'max_%_ratio_of_positive_tests'
from t_petr_jíša_project_sql_final
where 
	1 = 1
	and `Christianity (%)` > `Islam (%)`
	and `Christianity (%)` > `Buddhism (%)`
	and `Christianity (%)` > `Folk Religions (%)` 
	and `Christianity (%)` > `Hinduism (%)`
	and `Christianity (%)` > `Judaism (%)` 
	and `Christianity (%)` > `Buddhism (%)`
	and `Christianity (%)` > `Unaffiliated religions (%)`
	and tests_performed is not null
	group by country, `Christianity (%)` 
	order by max(confirmed*100/tests_performed) desc;


-- Example 5: Query to find the countries, where maximum percentage of positive tests exceeds 100 %
-- It shows all problematic countries where the relation between positive and performed tests may be problematic
-- The amount of such countries is 19
-- The data for these countries should be explored more in detail
SELECT
	country,
	round(max(confirmed*100/tests_performed), 1) as 'max_%_ratio_of_positive_tests'
from t_petr_jíša_project_sql_final
where tests_performed is not null
group by country
having max(confirmed*100/tests_performed) > 100
order by max(confirmed*100/tests_performed) desc;

-- Example 6: What is the amount of data records for each country, where the ratio between confirmed and performed tests is above 100 % ??
-- After this query execution, we can see 82 amount of records in Peru (really problematic) and 17 in Mexico (still not good)
-- Amount of these cases for the other countries is up to 5 (only exceptions)
-- Now we can decide what to do with data from these countries, where there are big problems, where there are only exceptions, etc.
select
	country,
	count(confirmed*100/tests_performed) as Positivity_overmatches_tests_in_x_days
from t_petr_jíša_project_sql_final
where 
	tests_performed is not null
	and confirmed/tests_performed > 1
group by country
order by Positivity_overmatches_tests_in_x_days desc;