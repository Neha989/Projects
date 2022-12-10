--Data Exploration

select location,date,total_cases,new_cases, population
from deaths
order by 1,2

--looking at total cases vs total_cases
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Percentage_death
from deaths
order by 1,2

--looking at total cases vs total_cases in India,likelihood of dying if infected by covid in India
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Percentage_death
from deaths 
where location like 'India'
order by 1,2

--looking at total cases vs population,shows % infected
select location,date,total_cases,population,(total_cases/population)*100 as Percentage_infected
from deaths
order by 1,2

--looking at total cases vs population,shows % infected in India
select location,date,total_cases,population,(total_cases/population)*100 as Percentage_infected
from deaths
where location like 'India'
order by 1,2

--looking at highest total cases vs population,shows % infected
select location,max(total_cases),population,max(total_cases/population)*100 as Percentage_infected
from deaths
group by 1,3
order by 4 desc

--highest death count location wise
select location,max(cast(total_deaths as int)) as death_count_max
from deaths
where continent is  null
group by 1
order by 2 desc

--highest death count continent wise
select continent,max(cast(total_deaths as int)) as death_count_max
from deaths
where continent is not null
group by 1
order by 2 desc


--global numbers
select date,sum(new_cases) new_cases,sum(cast(new_deaths as int)) new_deaths,
	(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from deaths
where continent is not null
group by 1
order by 1 desc

--total new death_percentage 
select sum(new_cases) new_cases,sum(cast(new_deaths as int)) new_deaths,
	(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from deaths
where continent is not null
order by 1 desc

select *
from vaccinations

--total_population vs cumulative sum of new_vaccination
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
	sum(v.new_vaccinations)over(partition by d.location order by d.date) as cumulative_sum_vaccinated
from deaths d
join vaccinations v
on d.location=v.location and d.date=v.date
--where new_vaccinations is not null
order by 2,3

--total_population vs new_vaccination_location_wise_percentage
with vaccination_percentage_location_wise as (select d.continent,d.location,d.date,d.population,v.new_vaccinations,
	sum(v.new_vaccinations)over(partition by d.location ) as cumulative_sum_vaccinated
from deaths d
join vaccinations v
on d.location=v.location and d.date=v.date
--where new_vaccinations is not null
order by 2,3)
select continent,location,date,population,new_vaccinations,
	cumulative_sum_vaccinated,(cumulative_sum_vaccinated/population)*100 as vaccination_percentage_location_wise
from vaccination_percentage_location_wise
group by continent,location,date,population,new_vaccinations,cumulative_sum_vaccinated

--

--location wise total tests conducted
select location, sum(total_tests) total_tests
from vaccinations
group by 1
order by 1 desc

--percentage of people vaccinated 
select sum(people_vaccinated) as total_population_vaccinated, 
	(sum(people_vaccinated)/sum(population)*100) as percentage_of_vaccinated_people
from vaccinations

--percentage fully vaccinated 
select sum(people_fully_vaccinated) as total_population_fully_vaccinated, 
	(sum(people_fully_vaccinated)/sum(population)*100) as percentage_of_fully_vaccinated_people
from vaccinations

--continent with the highest stringency index 
select continent, max(stringency_index)
from vaccinations
group by 1
order by 2 desc

--stringency index vs avg total deaths
select d.location,avg(d.total_deaths),v.stringency_index
			   from deaths d
			   join vaccinations v
			   on d.date=v.date and d.location=v.location
			   group by 1,3
			   order by 3 desc


--life expectancy vs stringency rate
select continent,life_expectancy, max(stringency_index)
from vaccinations
group by 2,1
order by 2 desc

--location with highest total_tests conducted 
select location,sum(total_tests) total_tests,rank()over(order by sum(total_tests) desc)
from vaccinations
where total_tests is not null
group by 1

----location with highest total_tests conducted in India
select location,date,total_tests,rank()over(partition by location order by total_tests desc)
from vaccinations
where location like '%India%' and total_tests is not null

--population density vs stringency index
select location,avg(population_density) as avg_population_density,avg(stringency_index) as avg_stringency_index
from vaccinations
where population_density is not null
group  by 1
order by 3 desc


