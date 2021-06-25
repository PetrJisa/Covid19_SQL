-- Tabulka ekonomických ukazatelů t_economy_data

create table t_economy_data as
select
	e19.country,
	case 
		when e19.GDP is not null then round(e19.GDP/e19.population, 1)
		when e18.GDP is not null then round(e18.GDP/e18.population, 1)
		else null
	end as unit_GDP,
	case
		when e19.GDP is not null then 2019
		when e18.GDP is not null then 2018
		else null
	end as unit_GDP_year,
	case 
		when e15_19.avg_gini is not null then e15_19.avg_gini
		when e10_14.avg_gini is not null then e10_14.avg_gini
		else null
	end as gini_coeficient,
	case
		when e15_19.avg_gini is not null then '2015-2019'
		when e10_14.avg_gini is not null then '2010-2014'
		else null
	end as gini_calc_period,
	e19.mortaliy_under5
from
	(select
		country,
		GDP,
		population,
		mortaliy_under5
	from economies
	where year = '2019') as e19
left join
	(select
		country,
		GDP,
		population
	from economies
	where year = '2018') as e18
on e19.country = e18.country
left join
(select
		country,
		round(avg(gini), 1) avg_gini
	from economies
	where year between 2015 and 2019
	group by country) as e15_19
on e19.country = e15_19.country
left join
	(select
		country,
		round(avg(gini), 1) avg_gini
	from economies
	where year between 2010 and 2014
	group by country) as e10_14
on e19.country = e10_14.country;

-- Tabulka náboženství t_religion_data

create table t_religion_data
select
	distinct base.country,
	round(chr.population/rs.population * 100, 2) as 'Christianity (%)',
	round(isl.population/rs.population * 100, 2) as 'Islam (%)',
	round(unaf.population/rs.population * 100, 2) as 'Unaffiliated religions (%)',
	round(hin.population/rs.population * 100, 2) as 'Hinduism (%)',
	round(bud.population/rs.population * 100, 2) as 'Buddhism (%)',
	round(bud.population/rs.population * 100, 2) as 'Folk Religions (%)',
	round(bud.population/rs.population * 100, 2) as 'Other Religions (%)',
	round(bud.population/rs.population * 100, 2) as 'Judaism (%)'
from
	(select
		distinct country
	from religions where year = 2020 and country != 'All countries') base
left join
	(select
		distinct country,
		population
	from religions
	where year = 2020 and country != 'All countries' and religion = 'Christianity') chr
on base.country = chr.country
join
	(select
		distinct country,
		population
	from religions
	where year = 2020 and country != 'All countries' and religion = 'Islam') isl
on base.country = isl.country
left join
	(select
		distinct country,
		population
	from religions
	where year = 2020 and country != 'All countries' and religion = 'Unaffiliated Religions') unaf
on base.country = unaf.country
left join
	(select
		distinct country,
		population
	from religions
	where year = 2020 and country != 'All countries' and religion = 'Hinduism') hin
on base.country = hin.country
left join
	(select
		distinct country,
		population
	from religions
	where year = 2020 and country != 'All countries' and religion = 'Buddhism') bud
on base.country = bud.country
left join
	(select
		distinct country,
		population
	from religions
	where year = 2020 and country != 'All countries' and religion = 'Folk Religions') folk
on base.country = folk.country
left join
	(select
		distinct country,
		population
	from religions
	where year = 2020 and country != 'All countries' and religion = 'Other Religions') other
on base.country = other.country
left join
	(select
		distinct country,
		population
	from religions
	where year = 2020 and country != 'All countries' and religion = 'Judaism') juda
on base.country = juda.country
left join
	(select
		distinct country,
		sum(population) population
	from religions
	where year = 2020 and country != 'All countries'
	group by country
	having sum(population) > 0) rs
on base.country = rs.country;

-- Tabulka časových ukazatelů t_time_data

create table t_time_data as
select
	c.date,
	case
		when c.date > '2021-03-22' then 1
		else s.seasons
	end as season,
	case
		when weekday(c.date) in (5,6) then 1
		else 0
	end as weekend_flag
from
	(select
		distinct date
	from covid19_basic_differences) c
left join
	(select 
		date,
		seasons
	from seasons) s
on c.date = s.date;

-- Tabulka se změnou očekávané doby dožití t_life_expectancy_data

create table t_life_expectancy_data as
select
	past.country,
	round(past.life_expectancy, 1) as life_expectancy_1965,
	round(present.life_expectancy, 1) as life_expectancy_2015,
	round(present.life_expectancy - past.life_expectancy, 1) as life_expectancy_difference
from
	(select
		country,
		life_expectancy
	from life_expectancy
	where year = 2015) as present
left join
	(select
		country,
		life_expectancy
	from life_expectancy
	where year = 1965) as past
on present.country = past.country;

-- Tabulka s údaji o počasí t_weather_data

create table t_weather_data as
select
	date,
	city,
	round(avg(LEFT(temp,position (' ' IN temp) - 1)),1) AS avg_temp,
	max(cast(LEFT(wind,position (' ' IN wind) - 1) as int)) AS max_wind,
	sum(
		case 
			when LEFT(rain,position (' ' IN rain) - 1) != 0 then 3
			else 0
		end) as rainy_hours
from weather
where (time between '06:00' and '21:00') and city is not null
group by date, city;

-- Tabulka provedených testů t_covid19_tests_data

create table t_covid19_tests_data as
select 
	date, 
	country, 
	max (tests_performed) as tests_performed 
from covid19_tests
group by country, date;

-- Upravená tabulka covid19_basic_differences t_covid19_basic_differences

create table t_covid19_basic_differences_data
select
	*
from covid19_basic_differences
where country not in ('Diamond Princess', 'Kosovo', 'Ms Zaandam', 'Namibia', 'Taiwan*', 'West Bank and Gaza');

-- Tabulka vybraných ukazatelů jednotlivých zemí t_country_data

create table t_country_data as
select
	distinct country,
	population,
	population_density,
	median_age_2018
from countries where country != 'Moje_zeme';

-- Tabulka optimalizovaných klíčů t_keys

create table t_keys as
select
	lt.country lookup_table_country,
	case
		when lt.country = 'Namibia' then 'Namibia'
		else cntr.country
	end as countries_country,
	cntr.capital_city as countries_capital_city,
	case
		when cntr.country = 'Austria' then 'Vienna'
		when cntr.country = 'Belgium' then 'Brussels'
		when cntr.country = 'Czech Republic' then 'Prague'
		when cntr.country = 'Finland' then 'Helsinki'
		when cntr.country = 'Greece' then 'Athens'
		when cntr.country = 'Italy' then 'Rome'
		when cntr.country = 'Luxembourg' then 'Luxembourg'
		when cntr.country = 'Poland' then 'Warsaw'
		when cntr.country = 'Portugal' then 'Lisboa'
		when cntr.country = 'Romania' then 'Bucharest'
		when cntr.country = 'Ukraine' then 'Kiev'
		else w.city
	end as weather_city,
	case
		when cntr.country = 'Bahamas' then 'Bahamas, The'
		when cntr.country = 'Brunei' then 'Brunei Darussalar'
		when cntr.country = 'Fiji Islands' then 'Fiji'
		when cntr.country = 'Cape Verde' then 'Cabo Verde'
		when cntr.country = 'Libyan Arab Jamahiriya' then 'Libya'
		when cntr.country = 'Micronesia, Federated States of' then 'Micronesia, Fed. Sts.'
		else cntr.country
	end as economies_country,
	case
		when cntr.country = 'Fiji Islands' then 'Fiji'
		when cntr.country = 'Libyan Arab Jamahiriya' then 'Libya'
		when cntr.country = 'Holy See (Vatican City State)' then 'Vatican City'
		when cntr.country = 'Saint Lucia' then 'St. Lucia'
		when cntr.country = 'Saint Kitts and Nevis' then 'St. Kitts and Nevis'
		when cntr.country = 'Saint Vincent and the Grenadine' then 'St. Vincent and the Grenadines'
		else cntr.country
	end as religion_country,
	case
		when cntr.country = 'Bahamas' then 'Bahamas, The'
		when cntr.country = 'Brunei' then 'Brunei Darussalar'
		when cntr.country = 'Fiji Islands' then 'Fiji'
		when cntr.country = 'Cape Verde' then 'Cabo Verde'
		when cntr.country = 'Libyan Arab Jamahiriya' then 'Libya'
		when cntr.country = 'Micronesia, Federated States of' then 'Micronesia, Fed. Sts.'
		when cntr.country = 'Timor-Leste' then 'Timor'
		when cntr.country = 'Holy See (Vatican City State)' then 'Vatican'
		else le.country
	end as life_expectancy_country,
	case
		when cntr.country = 'Bahamas' then 'Bahamas, The'
		when cntr.country = 'Brunei' then 'Brunei Darussalar'
		when cntr.country = 'Fiji Islands' then 'Fiji'
		when cntr.country = 'Cape Verde' then 'Cabo Verde'
		when cntr.country = 'Libyan Arab Jamahiriya' then 'Libya'
		when cntr.country = 'Micronesia, Federated States of' then 'Micronesia, Fed. Sts.'
		when cntr.country = 'Holy See (Vatican City State)' then 'Vatican City'
		when cntr.country = 'Saint Lucia' then 'St. Lucia'
		when cntr.country = 'Saint Kitts and Nevis' then 'St. Kitts and Nevis'
		when cntr.country = 'Saint Vincent and the Grenadine' then 'St. Vincent and the Grenadines'
		when cntr.country = 'Timor-Leste' then 'Timor'
		else ct.country
	end as covid19_tests_country
from
	(
	select
		country,
		iso3
	from
		lookup_table
	where
		province is null) lt
left join (
	select
		country,
		capital_city,
		iso3
	from
		countries
	where
		country != 'Northern Ireland') cntr on
	lt.iso3 = cntr.iso3
left join (
	select
		city
	from
		weather
	where
		date = '2020-08-01'
		and time = '06:00') w on
	cntr.capital_city = w.city
	and cntr.capital_city is not null
left join (
	select
		distinct country
	from
		economies) e on
	e.country = cntr.country
left join (
	select
		distinct country
	from
		religions) r on
	r.country = cntr.country
left join (
	select
		distinct country
	from
		life_expectancy) le on
	cntr.country = le.country
left join (
	select
		distinct country
	from
		covid19_tests ct) ct on
	cntr.country = ct.country;

-- Vytvoření indexů v tabulkách t_covid19_basic_differences_data, t_weather_data a t_covid19_tests_data

create index c_date
on t_covid19_basic_differences_data (date);

create index c_country
on t_covid19_basic_differences_data (country);

create index w_date
on t_weather_data (date);

create index ct_date
on t_covid19_tests_data (date);

create index ct_country
on t_covid19_tests_data (country);