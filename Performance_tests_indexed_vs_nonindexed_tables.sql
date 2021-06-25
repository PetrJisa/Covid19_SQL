-- TEST I
create table t_Petr_Jisa_project_SQL_final_test_I as
select
	cbd.*,
	ctd.tests_performed,
	tm.season,
	tm.weekend_flag,
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
from 
	t_covid19_basic_differences_data cbd
	left join
	t_keys k
	on cbd.country = k.lookup_table_country
	left join
	t_economy_data eco
	on eco.country = k.economies_country
	left join
	t_weather_data w
	on w.city = k.weather_city and w.date = cbd.date
	left join
	t_life_expectancy_data le
	on le.country = k.life_expectancy_country
	left join
	t_time_data tm
	on cbd.date = tm.date
	left join
	t_religion_data rel
	on rel.country = k.religion_country
	left join t_country_data cnt
	on cnt.country = k.countries_country
	left join t_covid19_tests_data ctd
	on ctd.country = k.covid19_tests_country and ctd.date = cbd.date
	WHERE cbd.date BETWEEN '2020-08-01' AND '2020-08-07';

-- Test II	
create table t_Petr_Jisa_project_SQL_final_test_II as
select
	cbd.*,
	ctd.tests_performed,
	tm.season,
	tm.weekend_flag,
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
from 
	t_covid19_basic_differences_data cbd
	left join
	t_keys k
	on cbd.country = k.lookup_table_country
	left join
	t_economy_data eco
	on eco.country = k.economies_country
	left join
	t_weather_data w
	on w.city = k.weather_city and w.date = cbd.date
	left join
	t_life_expectancy_data le
	on le.country = k.life_expectancy_country
	left join
	t_time_data tm
	on cbd.date = tm.date
	left join
	t_religion_data rel
	on rel.country = k.religion_country
	left join t_country_data cnt
	on cnt.country = k.countries_country
	left join t_covid19_tests_data ctd
	on ctd.country = k.covid19_tests_country and ctd.date = cbd.date
	WHERE cbd.date BETWEEN '2020-08-01' AND '2020-08-14';
	

-- TEST III
create table t_Petr_Jisa_project_SQL_final_test_III as
select
	cbd.*,
	ctd.tests_performed,
	tm.season,
	tm.weekend_flag,
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
from 
	t_covid19_basic_differences_data cbd
	left join
	t_keys k
	on cbd.country = k.lookup_table_country
	left join
	t_economy_data eco
	on eco.country = k.economies_country
	left join
	t_weather_data w
	on w.city = k.weather_city and w.date = cbd.date
	left join
	t_life_expectancy_data le
	on le.country = k.life_expectancy_country
	left join
	t_time_data tm
	on cbd.date = tm.date
	left join
	t_religion_data rel
	on rel.country = k.religion_country
	left join t_country_data cnt
	on cnt.country = k.countries_country
	left join t_covid19_tests_data ctd
	on ctd.country = k.covid19_tests_country and ctd.date = cbd.date
	WHERE cbd.date BETWEEN '2020-08-01' AND '2020-08-21';