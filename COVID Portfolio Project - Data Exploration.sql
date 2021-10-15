-- select the data we are going to use 
select location, date, total_cases, new_cases, total_deaths, population from covid_deaths;

-- looking at total cases vs total deaths have a percentage of deaths who diagnsot coivd

-- shows likelihood of dying in your country
select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as percent_deaths, population from covid_deaths
where location like "%india%"; 

-- lokin at total cases vs population

select location, date, total_cases, new_cases, total_deaths, (total_cases/population)*100 as percent_deaths, population from covid_deaths
where location like "%india%"; 

-- highest infection rate compared to population

select location, date, max(total_cases), new_cases, total_deaths, max((total_cases/population))*100 as percent_deaths, population from covid_deaths
group by location, population
order by percent_deaths desc;

-- countries with highest death count for population 

select location, max(cast(total_deaths as double )) as totaldeathcount from covid_deaths
where continent is not null
group by location
order by totaldeathcount desc
;

select* from covid_deaths
where continent is  not null;


-- lets big things into continents 


select location, max(cast(total_deaths as double )) as totaldeathcount from covid_deaths
where continent!=''
group by location 
order by totaldeathcount desc
;

-- showing the continent with highest death count ^^^ see upp same 

-- global numbers 

select date, sum(new_cases) as total_cases, sum(new_deaths), sum(new_deaths)/sum(new_cases)*100 as percent_deaths, population from covid_deaths
-- where location like "%india%"; 
where continent!=''
group by date
order by 2;

select  sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as percent_deaths, population from covid_deaths
-- where location like "%india%"; 
where continent!=''
-- group by date
order by 2;


-- looking at total population vs vaccination 
select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date ) as roll_peps_vaccinated from covid_deaths  d
inner join covid_vaccinatoins v
on d.location=v.location
and d.date=v.date
where d.continent!=''
order by 2,3;

-- here we can't do sum of roll_peps so we gonna use CTE lets see what is that
-- USE CTE

with popvsvac (continent, location, date, population, new_vaccinations, roll_peps_vaccinated) 
as 
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
 sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date ) as roll_peps_vaccinated from covid_deaths  d
inner join covid_vaccinatoins v
on d.location=v.location
and d.date=v.date
where d.continent!=''
-- order by 2,3
)
select*, (roll_peps_vaccinated/population)*100 
 from popvsvac;
 
 
 -- temp table
 drop table if exists percentpopulationvaccinated;
 create table percentpopulationvaccinated(
	continent varchar(255),
    location varchar(255),
    date date,
    population numeric,
    new_vaccinations varchar(255),
    roll_peps_vaccinated numeric
 );
 insert into percentpopulationvaccinated
 select d.continent, d.location, d.date, d.population, v.new_vaccinations,
 sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date ) as roll_peps_vaccinated from covid_deaths  d
inner join covid_vaccinatoins v
on d.location=v.location
and d.date=v.date
-- where d.continent!=''
-- order by 2,3
;
select *, (roll_peps_vaccinated/population)*100 
 from percentpopulationvaccinated;
 
 -- creating view to store data for later visulizations
 
 create view percentpopulationvaccinate
 as
 select d.continent, d.location, d.date, d.population, v.new_vaccinations,
 sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date ) as roll_peps_vaccinated from covid_deaths  d
inner join covid_vaccinatoins v
on d.location=v.location
and d.date=v.date
 where d.continent!=''
-- order by 2,3
;
