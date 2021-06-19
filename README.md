# Covid19_SQL

This project was worked out in frame of Engeto Data Academy course. The goal was to construct a panel data table, which will serve as a hypothetical platform for creation of mathematical model, describing the complex influence of many factors on the course and seriousness of the covid 19 pandemic in the particular countries. The factors include parameters which describe economical level, standard of living, weather and distribution of religion attendees in the countries. Furthermore, also specific parameter that gives an indirect information regarding the historical consequence in the given states is included (namely overall change in life expectancy over the last 50 years) and - of course - the parameters which are linked with the time-aspects. 


## Project solution

The project was written in SQL. The data source was the database _data.engeto.com_, to which I was connected using localhost. As a consequence, the results were not shared between the database users. Therefore, the direct output of the project are SQL scripts, which are designed to be postponed to the second side so that the second side can use the scripts to generate the required object which is the final table, as well as the auxiliary objects. 


### Auxiliary objects

This concept was chosen to help in understanding the creation process and to increase the transparency of the whole work. Rather than developing one query using temporary tables, generated by the with clause, the solution contains the particular tables, which must be generated prior to creation of the final table. Although this solution forces the project evaluator to employ himself by creating the particular tables, it also brings him a great advantage to see the root objects from which the final table is generated. 

The queries for creation of the auxiliary objects (particular tables) are in the attached file **Auxiliary_objects.sql**. 

In the following text, there is a following typographic convention: 

**The particular tables are written in bold**

***The source tables from data.engeto.com are written in bold italics***

_The columns in the tables are written in italics_


#### Table of life expectancy

This table is called **t_life_expectancy_data** after it is created. It is one of a very few tables, which does not need a wide description. 
The data were mined from the source table ***life_expectancy_*** and following columns are present: 

_country_ : field of distinct countries from the source table

_life_expectancy_1965_ : contains the life expectancy in the countries, valid for the year 1965

_life_expectancy_2015_ : contains the life expectancy in the countries, valid for the year 2015

_life_expectancy_difference_: contains the difference in the values of life expectancy in the year 1965 and 2015

Among these columns, only the column _life_expectancy_difference_ is contained in the final table.


#### Table of economical factors

This table is called **t_economy_data** after it is created. This table was created from the source table ***economies*** and consists of the following columns:

_country_ : includes distinct countries from the source table

_unit_GDP_ : includes the GDP for the given country, recalculated to one resident of the country (overall GDP divided by the overall population of the state)

_unit_GDP_year_ : includes the year from which the record in _unit_GDP_ is valid for the given country

_gini_coeficient_ : includes the GINI coeficient for the given country

_gini_calc_period_ : includes the time period from which the average GINI coeficient was calculated

_mortality_under_5_ : includes the mortality of children before reaching age of 5 years

Of course, the approach leading to creation of this table must be explained. The default data set, obtained from ***economies*** is little bit problematic in relation to the project task. There are 3 problems: 

1) There are no data for the year 2020 that would serve as best information source, because the data from pandemics are evaluated, which began in 2020. Therefore, older years were evaluated and used for the table creation.  

2) For most countries, the GDP and population are accesible from the year 2019, but still, for many countries the most actual data are from the year 2018

3) A very problematic quantity is GINI coeficient. The presence of this parameter differs very much from country to country - while some countries have multiple values in the last 5 years, some of the other countries do not have any records since 2015 and there are also many contries that do not have any estimation of this parameter since 2010. 

The afforementioned problems lead to specific solution of the table columns: 

1) The data in _unit_GDP_ were obtained from the year 2019 and if it was not possible due to the data inaccessibility for the given country, the value was obtained using the data from the year 2018. If even the values from the year 2018 were inaccesible, the _unit_GDP_ was set as NULL. The column _unit_GDP_year_ gives the information regarding the year from which the data were used to calculated the corresponding value in the column _unit_GDP_ for the given state, to distinguish between the manners of obtaining unit GDP for the given country. 

2) The data in _gini_coeficient_ were calculated as average value from period 2015 - 2019 and if it was not possible due to the data inaccessibility for the given country in this (relatively actual) period, the average values from period 2010 - 2014 were calculated instead. If even the calculation of GINI coeficeint using the data from period 2010 - 2014 was impossible, the _gini_coeficient_ was set as NULL. The column _gini_calc_period_ refers to the period from which the average GINI coeficient was calculated for the given state, in order to distinguish the cases of how the parameter was obtained.  

All of the afforementioned columns are present in the final table, except from the key column _countries_. In my opinion, the person who will create the model should have the possibility to know the complementary information, from which year or period the data were obtained. Then, he can decide whether he will include the data to the set for model depending on how they are actual, he can scale them according to their validity (to give lower weight to the older GDPs and GINI coeficients) etc.


#### Table of weather data

This table is called **t_weather_data** after it is created. The source data for this table are gained from the table ***weather*** in database data.engeto.com. The columns in **t_weather_data** are the following: 

_date_ : includes the date at which the weather parameters were determined

_city_ : includes the city in which the weather parameters were determined

_avg_temp_ : includes the average temperture for given city at given date during the day (night excluded)

_max_wind_ : includes the maximum wind speed for given city at given date during the day (night excluded)

_rainy_hours_ : includes the approximation of the rainy hours amount at given date during the day (night excluded)

All of the parameters _avg_temp_, _max_wind_ and _rainy_hours_ are determined using the data from table weather where the time is 06:00, 09:00, 12:00, 15:00, 18:00 and 21:00. This is in accordance with the assumption that weather influences the behaviour of the people, but most of them are active only during the day. Therefore, the weather data from the night are excluded. 

Important note must be stated, regarding the parameter _rainy_hours_. The amount of rainy hours is a raw approximation because only cumulative data are accessible at the times mentioned above. In case when there is an amount of precipitations above zero as a sum at 9:00, this information is expressed as 3 rainy hours in the array _rainy_hours_ (as if it would rain from 6:00 to 9:00). This is done despite the real situation can be that during that 3 hours, there was 10 minutes of rain, giving the overall sum of precipitations above zero, and this short rain did not influence so many people as the real 3 hours lasting rain. Nevertheless, there is no clue to improve the approximation in this way.

Furthermore, let me now shoot into my own work a little bit more. The weather data are only accessible for cities, and even these cities are only capitals of the European states. Therefore, the weather impacts can be evaluated only for Europe. And what is more, the weather in the selected country is approximated by the weather in its capital city. As a fan of meteorology and climatology, I do not like to see this approach, because even in a small country like Czech Republic, we know high difference regarding the weather in the same time from west to east, from lowlands to mountains, effect of the Prague warm city island that surely will be present also for some of the other cities, and many other effects.


#### Table of religions data

This table is called **t_religion_data** after it is created. This table was created from the source table ***religions*** in database data.engeto.com and consists of the following columns:

_country_ : country for which the religions data were determined

_Christianity %_ : ratio of the part of the population which denominate Christianity for the given country

_Islam %_ : ratio of the part of the population which denominate Islam

.........

I am not going to write down all religions that are able to be found in this table. For each of these religions, there is a separate column in **t_religion_data** and all these columns are used in the final table, according to the requirement.  

In the source table ***religions***, the religions were stated in column _religion_, but from a practical reason, they were transformed into columns in **t_religion_data**. The reason is obvious - it would not make sense to have multiple rows for each country and date in the final table, differing only in data regarding the distribution of population according to religion. 


#### Table of time indicators

This table is called **t_time_data** after it is created. The source data come from joined tables ***covid19_basic_differences*** and ***seasons*** in the database data.engeto.com.  The table **t_time_data** includes the following columns: 

_date_ : date for which the parameters in the table were determined

_season_ : the season in the year (0 - winter, 1 - spring, 2 - summer, 3 - autumn)

_weekend_flag_ : binary array (0 when the date is a working day, 1 when the date is one of the weekend days)


#### Table of performed tests

This table is called **t_covid19_tests_data** after it is created. The source data come from the table ***covid19_tests*** in the database data.engeto.com. The table **t_covid19_tests_data** contains the folowing columns: 

_date_ : date for which the parameters in the table were determined

_country_ : country for which the parameters in the table were determined

_tests_performed: the number of tests that were performed in the given country at the given date

I would like to note that for many countries, the data from testing are inaccessible in the source table, and therefore also in the prepared auxiliary table. 

Furthermore, some cases can be observed in the source table, where the same country has 2 records of performed tests for one date. Looking at those records, I realized that they are relatively similar (if not in all cases, then in most of them). I suppose that these are the cases when the country sent the incomplete data at first, followed by the second sending of completed data. Therefore, in case of 2 records for the same country in one day, I used the maximum from the 2 records as amount of the performed tests. 


#### Table of specific data for countries

This table is called **t_country_data** after it is created. The source data come from the table ***countries*** in the database data.engeto.com. The table **t_country_data** contains the folowing columns:

_country_ : ountry for which the parameters in the table were determined

_population_ : overall population of the given country

_population_density_ : population density of the given country

_median_age_2018_ : median of the age in the overall population, calculated explicitly from data in 2018 (not based on the selection of data from the year 2018 and calculation)


#### Modified table covid19_basic_differences

A few modifications of the table ***covid19_basic_differences*** from the database data.engeto.com were worth it from the project point of view. It lead to creation of a modified table, which is called **t_covid19_basic_differences_data** when it is created. The modification was done in two ways: 

The countries (and even one cruise ship "MS Zaandam") for which there are no data in the above descriped tables were excluded. The excluded items are 'Diamond Princess', 'Kosovo', 'Ms Zaandam', 'Namibia', 'Taiwan*' and 'West Bank and Gaza'


#### Table of optimized keys

This table serves to optimize the key arrays that serve to join the auxiliary tables together in the way to create the final table. It is called **t_keys** after its creation.

The reason for creation of this table may be described using the example for the 'Czech Republic'. In **t_covid19_basic_differences_data** it is represented by the string **'Czechia'**. However, in ***countries*** from data.engeto.com, which must be used to access the _capital_city_ for join on the _city_ from ***weather*** table, it is represented by the string **'Czech Republic'**. And furthermore, in **countries**, the capital city of the Czech Republic is **'Praha'**, while in the table ***weather*** it is **'Prague'**. 

**It is obvious that if the join between the afforementioned tables would be done using the original columns in these tables, we would not obtain the weather data for the Czech Republic, despite they are accessible!!** And even more, there are more cases similar to the one for the Czech Republic. 

Therefore, the table **t_keys** was created. It contains the modified arrays that are equivalent to the arrays from the original tables in data.engeto.com which are consequently equal to the arrays in the auxiliary tables that are used for joining the tables together in the query, creating the final table. The whole table **t_keys** is then 'invisibly joined' on the table **t_covid19_basic_differences_data** using join **on _t_covid19_basic_differences_data_ = _t_keys.lookup_table_country_**, because these arrays are equal. The other tables are joined on this construction, using corresponding arrays - in example the table **t_weater_data** is joined **on _t_weather_data.city_ = _t_keys.weather_city_**, while the table **t_economy_data** is joined **on _t_economy_data.country_ = _t_keys.economies_country_**


#### Database indexes

To decrease the time which is needed to execute the query that creates the final table, I recommend to create database indexes into the longest arrays which are used for joining the tables. Namely, I have created indexes in tables **t_covid19_basic_differences_data**, **t_weather** and **t_covid19_tests_data**. The indexes are also created by queries which can be found in the attached file **Auxiliary_objects.sql**.  


### The final table

Finally, we are moving to the final table. This table is created using the only query in the script for its creation, which is attached as **'Final_table.sql'**. The final table which is created after the query is executed is called **t_petr_jíša_project_sql_final**

Prior to creation of the final table, please be sure that the auxiliary tables were created by executing all queris from **Auxiliary_objects.sql**. 

The complete list of the auxiliary tables for the last crucial checkout is as follows: 

**t_life_expectancy_data**

**t_economy_data**

**t_weather_data**

**t_religions_data**

**t_time_data**

**t_covid19_tests_data**

**t_countries_data**

**t_covid19_basic_differences_data**

**t_keys**

# Thank you in advance for reading this documentation!
















