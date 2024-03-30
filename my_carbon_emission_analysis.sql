-- creating database
create database carbon_emission_analysis;
use carbon_emission_analysis;
show tables;

-- created a new table carbon_emission and imported data from a csv file
desc carbon_emission;

-- checking for null values in the columns

select * from carbon_emission where country is null;

select * from carbon_emission where year is null;

select * from carbon_emission where series is null;

select * from carbon_emission where value is null;

-- total no of rows
select count(*) from carbon_emission;

-- year range of the data
select max(year), min(year) from carbon_emission;

select distinct(series) from carbon_emission;

select max(value), series , country from carbon_emission group by country, series order by max(value) desc; 

-- since there are two distinct series, so we can make two more table to make data querying easier

create table emissions(
country varchar(100) not null,
year int not null,
series varchar(100),
value double
);

-- the emissions table will contain 'Emissions (thousand metric tons of carbon dioxide)' data
insert into emissions
select * from carbon_emission where series= "Emissions (thousand metric tons of carbon dioxide)";

select * from emissions;

-- another table percapita_emissions will have 'Emissions per capita (metric tons of carbon dioxide)' data

create table percapita_emissions (
country varchar(100) not null,
year int not null,
series varchar(255) not null,
value double not null
);


insert into percapita_emissions
select * from carbon_emission where series = 'Emissions per capita (metric tons of carbon dioxide)';

select * from percapita_emissions;

-- finding data about india

-- finding the max and min emission by india
select max(value), min(value) from emissions where country = "india"; 

select round(max(value),0) as max_emission, year from emissions
where country = "india" group by year order by max_emission desc ; 
-- the max emission by india was in 2017 and min in 1975


-- top 5 emitter of CO2 in thousand metric ton in 2017, 
select country,year,round(max(value),0) as max_emission from emissions group by country,
year order by year desc , max_emission desc ;

-- india ranks 3rd in 2017, top emitter is china then USA


--   historically ranking countries based on total emissions from 1975 to 2017
select sum(value) as total_emission, country from emissions group by country order by total_emission desc;
-- china, usa, india

-- percentage increase in indian emission from 1975 to 2017
select round((((max(value)-min(value))/min(value))*100),2) as emission_growth from emissions where country = "india";

-- finding countries with highest emission growth
select round((((max(value)-min(value))/min(value))*100),2) as emission_growth, country 
from emissions group by country  order by emission_growth desc;
-- oman has the highest increase historically




-- exploring the percapita_emission table
-- overview of indian data
select * from percapita_emissions where country ="india";

-- max and min emission of india
select max(value), min(value) from percapita_emissions where country = "india"; 

select round(max(value),3) as max_emission, year from percapita_emissions
where country = "india" group by year order by max_emission desc;
-- max and min percapita emission of india was in 2017-1.614 and 1975-0.35 resp

-- top 5 emitters in 2017
select country,year,round(max(value),3) as max_emission from percapita_emissions group by country,year order by year desc ,max_emission desc ;
-- qatar was top percapita emitter in 2017

select sum(value) as total_emission, country from percapita_emissions group by country order by total_emission desc;

 create view value_2017 as
 select country, value from percapita_emissions where year =2017;
 
 select * from value_2017;
 
 create view value_1975 as
 select country, value from percapita_emissions where year =1975;
 
 select * from value_1975;
 
 -- finding the growth in emissions from 1975 to 2017
 select value_2017.country,round((value_2017.value - value_1975.value)/value_1975.value,2) as changes
  from value_2017
INNER JOIN value_1975 ON value_1975.Country = value_2017.Country
ORDER BY changes DESC;
 
 -- the rate of growth is highest in oman
 
 
 


















 