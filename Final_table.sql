-- Vytvoření finální tabulky

CREATE TABLE t_Petr_Jíša_project_SQL_final as
SELECT
	cbd.*,
	ctd.tests_performed,
	tm.season,
	tm.weekEND_flag,
	eco.unit_GDP,
	eco.unit_GDP_year,
	eco.gini_coeficient,
	eco.gini_calc_period,
	eco.mortaliy_under5 as mortality_under5,
	cnt.population,
	cnt.population_density,
	cnt.median_age_2018,
	le.life_expectancy_difference as life_expectancy_diff_1965_2015,
	rel.`Christianity (%)`,
	rel.`Islam (%)`, 
	rel.`Buddhism (%)`,
	rel.`Folk Religions (%)`,
	rel.`Hinduism (%)`,
	rel.`Judaism (%)`,
	rel.`Unaffiliated religions (%)`,
	rel.`Other Religions (%)`,
	w.avg_temp as avg_temperature,
	w.max_wind,
	w.rainy_hours
FROM 
	t_covid19_basic_differences_data cbd
	LEFT JOIN
	t_keys k
	ON cbd.country = k.lookup_table_country
	LEFT JOIN
	t_economy_data eco
	ON eco.country = k.economies_country
	LEFT JOIN
	t_weather_data w
	ON w.city = k.weather_city and w.date = cbd.date
	LEFT JOIN
	t_life_expectancy_data le
	ON le.country = k.life_expectancy_country
	LEFT JOIN
	t_time_data tm
	ON cbd.date = tm.date
	LEFT JOIN
	t_religion_data rel
	ON rel.country = k.religion_country
	LEFT JOIN t_country_data cnt
	ON cnt.country = k.countries_country
	LEFT JOIN t_covid19_tests_data ctd
	ON ctd.country = k.covid19_tests_country and ctd.date = cbd.date;
	
