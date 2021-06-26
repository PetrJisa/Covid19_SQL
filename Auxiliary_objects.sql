-- Tabulka ekonomických ukazatelů t_economy_data

CREATE TABLE t_economy_data as
SELECT
	e19.country,
	CASE 
		WHEN e19.GDP IS NOT NULL THEN round(e19.GDP/e19.population, 1)
		WHEN e18.GDP IS NOT NULL THEN round(e18.GDP/e18.population, 1)
		ELSE NULL
	END as unit_GDP,
	CASE
		WHEN e19.GDP IS NOT NULL THEN 2019
		WHEN e18.GDP IS NOT NULL THEN 2018
		ELSE NULL
	END as unit_GDP_year,
	CASE 
		WHEN e15_19.avg_gini IS NOT NULL THEN e15_19.avg_gini
		WHEN e10_14.avg_gini IS NOT NULL THEN e10_14.avg_gini
		ELSE NULL
	END as gini_coeficient,
	CASE
		WHEN e15_19.avg_gini IS NOT NULL THEN '2015-2019'
		WHEN e10_14.avg_gini IS NOT NULL THEN '2010-2014'
		ELSE NULL
	END as gini_calc_period,
	e19.mortaliy_under5
FROM
	(SELECT
		country,
		GDP,
		population,
		mortaliy_under5
	FROM economies
	WHERE year = '2019') as e19
LEFT JOIN
	(SELECT
		country,
		GDP,
		population
	FROM economies
	WHERE year = '2018') as e18
ON e19.country = e18.country
LEFT JOIN
(SELECT
		country,
		round(avg(gini), 1) avg_gini
	FROM economies
	WHERE year between 2015 and 2019
	GROUP BY country) as e15_19
ON e19.country = e15_19.country
LEFT JOIN
	(SELECT
		country,
		round(avg(gini), 1) avg_gini
	FROM economies
	WHERE year between 2010 and 2014
	GROUP BY country) as e10_14
ON e19.country = e10_14.country;

-- Tabulka náboženství t_religion_data

CREATE TABLE t_religion_data
SELECT
	DISTINCT base.country,
	round(chr.population/rs.population * 100, 2) as 'Christianity (%)',
	round(isl.population/rs.population * 100, 2) as 'Islam (%)',
	round(unaf.population/rs.population * 100, 2) as 'Unaffiliated religions (%)',
	round(hin.population/rs.population * 100, 2) as 'Hinduism (%)',
	round(bud.population/rs.population * 100, 2) as 'Buddhism (%)',
	round(bud.population/rs.population * 100, 2) as 'Folk religions (%)',
	round(bud.population/rs.population * 100, 2) as 'Other religions (%)',
	round(bud.population/rs.population * 100, 2) as 'Judaism (%)'
FROM
	(SELECT
		DISTINCT country
	FROM religions WHERE year = 2020 AND country != 'All countries') base
LEFT JOIN
	(SELECT
		DISTINCT country,
		population
	FROM religions
	WHERE year = 2020 AND country != 'All countries' AND religion = 'Christianity') chr
ON base.country = chr.country
LEFT JOIN
	(SELECT
		DISTINCT country,
		population
	FROM religions
	WHERE year = 2020 AND country != 'All countries' AND religion = 'Islam') isl
ON base.country = isl.country
LEFT JOIN
	(SELECT
		DISTINCT country,
		population
	FROM religions
	WHERE year = 2020 AND country != 'All countries' AND religion = 'Unaffiliated religions') unaf
ON base.country = unaf.country
LEFT JOIN
	(SELECT
		DISTINCT country,
		population
	FROM religions
	WHERE year = 2020 AND country != 'All countries' AND religion = 'Hinduism') hin
ON base.country = hin.country
LEFT JOIN
	(SELECT
		DISTINCT country,
		population
	FROM religions
	WHERE year = 2020 AND country != 'All countries' AND religion = 'Buddhism') bud
ON base.country = bud.country
LEFT JOIN
	(SELECT
		DISTINCT country,
		population
	FROM religions
	WHERE year = 2020 AND country != 'All countries' AND religion = 'Folk religions') folk
ON base.country = folk.country
LEFT JOIN
	(SELECT
		DISTINCT country,
		population
	FROM religions
	WHERE year = 2020 AND country != 'All countries' AND religion = 'Other religions') other
ON base.country = other.country
LEFT JOIN
	(SELECT
		DISTINCT country,
		population
	FROM religions
	WHERE year = 2020 AND country != 'All countries' AND religion = 'Judaism') juda
ON base.country = juda.country
LEFT JOIN
	(SELECT
		DISTINCT country,
		sum(population) population
	FROM religions
	WHERE year = 2020 and country != 'All countries'
	GROUP BY country
	HAVING sum(population) > 0) rs
ON base.country = rs.country;

-- Tabulka časových ukazatelů t_time_data

CREATE TABLE t_time_data as
SELECT
	c.date,
	CASE
		WHEN c.date > '2021-03-22' THEN 1
		ELSE s.seasons
	END as season,
	CASE
		WHEN weekday(c.date) in (5,6) THEN 1
		ELSE 0
	END as weekend_flag
FROM
	(SELECT
		DISTINCT date
	FROM covid19_basic_differences) c
LEFT JOIN
	(SELECT 
		date,
		seasons
	FROM seasons) s
ON c.date = s.date;

-- Tabulka se změnou očekávané doby dožití t_life_expectancy_data

CREATE TABLE t_life_expectancy_data as
SELECT
	past.country,
	round(past.life_expectancy, 1) as life_expectancy_1965,
	round(present.life_expectancy, 1) as life_expectancy_2015,
	round(present.life_expectancy - past.life_expectancy, 1) as life_expectancy_difference
FROM
	(SELECT
		country,
		life_expectancy
	FROM life_expectancy
	WHERE year = 2015) as present
LEFT JOIN
	(SELECT
		country,
		life_expectancy
	FROM life_expectancy
	WHERE year = 1965) as past
ON present.country = past.country;

-- Tabulka s údaji o počasí t_weather_data

CREATE TABLE t_weather_data as
SELECT
	date,
	city,
	round(avg(LEFT(temp,POSITION (' ' IN temp) - 1)),1) AS avg_temp,
	max(cast(LEFT(wind,POSITION (' ' IN wind) - 1) as int)) AS max_wind,
	sum(
		CASE 
			WHEN LEFT(rain,POSITION (' ' IN rain) - 1) != 0 THEN 3
			ELSE 0
		END) as rainy_hours
FROM weather
WHERE (time between '06:00' AND '21:00') AND city IS NOT NULL
GROUP BY date, city;

-- Tabulka provedených testů t_covid19_tests_data

CREATE TABLE t_covid19_tests_data as
SELECT 
	date, 
	country, 
	max (tests_performed) as tests_performed 
FROM covid19_tests
GROUP BY country, date;

-- Upravená tabulka covid19_basic_differences t_covid19_basic_differences

CREATE TABLE t_covid19_basic_differences_data
SELECT
	*
FROM covid19_basic_differences
WHERE country NOT IN ('Diamond Princess', 'Kosovo', 'Ms Zaandam', 'Namibia', 'Taiwan*', 'West Bank and Gaza');

-- Tabulka vybraných ukazatelů jednotlivých zemí t_country_data

CREATE TABLE t_country_data as
SELECT
	DISTINCT country,
	population,
	population_density,
	median_age_2018
FROM countries where country != 'Moje_zeme';

-- Tabulka optimalizovaných klíčů t_keys

CREATE TABLE t_keys as
SELECT
	lt.country lookup_table_country,
	CASE
		WHEN lt.country = 'Namibia' THEN 'Namibia'
		ELSE cntr.country
	END as countries_country,
	cntr.capital_city as countries_capital_city,
	CASE
		WHEN cntr.country = 'Austria' THEN 'Vienna'
		WHEN cntr.country = 'Belgium' THEN 'Brussels'
		WHEN cntr.country = 'Czech Republic' THEN 'Prague'
		WHEN cntr.country = 'Finland' THEN 'Helsinki'
		WHEN cntr.country = 'Greece' THEN 'Athens'
		WHEN cntr.country = 'Italy' THEN 'Rome'
		WHEN cntr.country = 'Luxembourg' THEN 'Luxembourg'
		WHEN cntr.country = 'Poland' THEN 'Warsaw'
		WHEN cntr.country = 'Portugal' THEN 'Lisboa'
		WHEN cntr.country = 'Romania' THEN 'Bucharest'
		WHEN cntr.country = 'Ukraine' THEN 'Kiev'
		ELSE w.city
	END as weather_city,
	CASE
		WHEN cntr.country = 'Bahamas' THEN 'Bahamas, The'
		WHEN cntr.country = 'Brunei' THEN 'Brunei Darussalar'
		WHEN cntr.country = 'Fiji Islands' THEN 'Fiji'
		WHEN cntr.country = 'Cape Verde' THEN 'Cabo Verde'
		WHEN cntr.country = 'Libyan Arab Jamahiriya' THEN 'Libya'
		WHEN cntr.country = 'Micronesia, Federated States of' THEN 'Micronesia, Fed. Sts.'
		ELSE cntr.country
	END as economies_country,
	CASE
		WHEN cntr.country = 'Fiji Islands' THEN 'Fiji'
		WHEN cntr.country = 'Libyan Arab Jamahiriya' THEN 'Libya'
		WHEN cntr.country = 'Holy See (Vatican City State)' THEN 'Vatican City'
		WHEN cntr.country = 'Saint Lucia' THEN 'St. Lucia'
		WHEN cntr.country = 'Saint Kitts and Nevis' THEN 'St. Kitts and Nevis'
		WHEN cntr.country = 'Saint Vincent and the Grenadine' THEN 'St. Vincent and the Grenadines'
		ELSE cntr.country
	END as religion_country,
	CASE
		WHEN cntr.country = 'Bahamas' THEN 'Bahamas, The'
		WHEN cntr.country = 'Brunei' THEN 'Brunei Darussalar'
		WHEN cntr.country = 'Fiji Islands' THEN 'Fiji'
		WHEN cntr.country = 'Cape Verde' THEN 'Cabo Verde'
		WHEN cntr.country = 'Libyan Arab Jamahiriya' THEN 'Libya'
		WHEN cntr.country = 'Micronesia, Federated States of' THEN 'Micronesia, Fed. Sts.'
		WHEN cntr.country = 'Timor-Leste' THEN 'Timor'
		WHEN cntr.country = 'Holy See (Vatican City State)' THEN 'Vatican'
		ELSE le.country
	END as life_expectancy_country,
	CASE
		WHEN cntr.country = 'Bahamas' THEN 'Bahamas, The'
		WHEN cntr.country = 'Brunei' THEN 'Brunei Darussalar'
		WHEN cntr.country = 'Fiji Islands' THEN 'Fiji'
		WHEN cntr.country = 'Cape Verde' THEN 'Cabo Verde'
		WHEN cntr.country = 'Libyan Arab Jamahiriya' THEN 'Libya'
		WHEN cntr.country = 'Micronesia, Federated States of' THEN 'Micronesia, Fed. Sts.'
		WHEN cntr.country = 'Holy See (Vatican City State)' THEN 'Vatican City'
		WHEN cntr.country = 'Saint Lucia' THEN 'St. Lucia'
		WHEN cntr.country = 'Saint Kitts and Nevis' THEN 'St. Kitts and Nevis'
		WHEN cntr.country = 'Saint Vincent and the Grenadine' THEN 'St. Vincent and the Grenadines'
		WHEN cntr.country = 'Timor-Leste' THEN 'Timor'
		ELSE ct.country
	END as covid19_tests_country
FROM
	(
	SELECT
		country,
		iso3
	FROM
		lookup_table
	WHERE
		province IS NULL) lt
LEFT JOIN (
	SELECT
		country,
		capital_city,
		iso3
	FROM
		countries
	WHERE
		country != 'Northern Ireland') cntr 
	ON lt.iso3 = cntr.iso3
LEFT JOIN (
	SELECT
		city
	FROM
		weather
	WHERE
		date = '2020-08-01'
		and time = '06:00') w 
	ON cntr.capital_city = w.city
	AND cntr.capital_city IS NOT NULL
LEFT JOIN (
	SELECT
		DISTINCT country
	FROM
		economies) e
	ON e.country = cntr.country
LEFT JOIN (
	SELECT
		DISTINCT country
	FROM
		religions) r
	ON r.country = cntr.country
LEFT JOIN (
	SELECT
		DISTINCT country
	FROM
		life_expectancy) le
	ON cntr.country = le.country
LEFT JOIN (
	SELECT
		DISTINCT country
	FROM
		covid19_tests ct) ct
	ON cntr.country = ct.country;

-- Vytvoření indexů v tabulkách t_covid19_basic_differences_data, t_weather_data a t_covid19_tests_data

CREATE INDEX c_date
ON t_covid19_basic_differences_data (date);

CREATE INDEX c_country
ON t_covid19_basic_differences_data (country);

CREATE INDEX w_date
ON t_weather_data (date);

CREATE INDEX ct_date
ON t_covid19_tests_data (date);

CREATE INDEX ct_country
ON t_covid19_tests_data (country);