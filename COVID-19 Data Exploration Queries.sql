alter table ProjectPortfolio.coviddeaths modify column population bigint;

delete from ProjectPortfolio.coviddeaths

select * from ProjectPortfolio.coviddeaths
order by 3,4;

select * from ProjectPortfolio.covidvaccinations c 
order by 3,4;

select location,date,total_cases,new_cases,total_deaths,population
from ProjectPortfolio.coviddeaths
order by 1,2;


 
delete  from ProjectPortfolio.covidvaccinations c 


update user set `date`=TO_DATE('2/24/2020', 'YYYY-MM-DD HH:MM:SS')
where `date`='2/24/2020';


#total cases vs total deaths
select location,date,(total_cases),total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from projectportfolio.coviddeaths c 
where location like '%states%'
order by 1,2;


select location,date,population ,total_cases ,(total_cases/population)*100 as DeathPercentage
from projectportfolio.coviddeaths c 
#where location like '%states%'
order by 1,2;

#Looking at countries with highest Infection Rate compared to population
select location,population ,max(total_cases) as HighestInfectionCount  ,max((total_cases/population))*100 as PercentPopulationInfected
from projectportfolio.coviddeaths c 
group by location,population 
order by PercentPopulationInfected desc;

#showing countries with highest death count per population
select location,MAX(cast(total_deaths as UNSIGNED)) as TotalDeathCount
from projectportfolio.coviddeaths c 
where continent is not null 
group by location
order by TotalDeathCount desc;


select * from projectportfolio.coviddeaths c 
where continent is not null 
order by 3,4 desc

#showing the continent with the highest death count per population
select continent ,MAX(cast(total_deaths as UNSIGNED)) as TotalDeathCount
from projectportfolio.coviddeaths c 
where continent is not  null 
group by continent 
order by TotalDeathCount desc;



select date ,sum(cast(new_cases as unsigned))as total_cases ,
sum(cast(new_deaths as unsigned))as total_deaths ,sum(cast(new_deaths as unsigned))/sum(new_cases )*100
as DeathPercentage
from projectportfolio.coviddeaths c 
#where location like '%states%'
where continent is not null
group by date
order by 1,2;


select sum(cast(new_cases as unsigned))as total_cases ,
sum(cast(new_deaths as unsigned))as total_deaths ,sum(cast(new_deaths as unsigned))/sum(new_cases )*100
as DeathPercentage
from projectportfolio.coviddeaths c 
#where location like '%states%'
where continent is not null
order by 1,2;

#looking at toal population vs vaccinations
select c.continent ,c.location ,c.`date` ,c.population ,c2.new_vaccinations 
from projectportfolio.coviddeaths c 
join projectportfolio.covidvaccinations c2 
on c.location =c2.location 
and c.`date` =c2.`date` 
where c.continent is not null  and c.continent not IN ('') 
order by 2,3;



select c.continent ,c.location ,c.`date` ,c.population ,c2.new_vaccinations, 
sum(convert(c2.new_vaccinations,signed)) over (partition by c.location order by c.location,c.date)
from projectportfolio.coviddeaths c 
join projectportfolio.covidvaccinations c2 
on c.location =c2.location 
and c.`date` =c2.`date` 
where c.continent is not null  #and c.continent not IN ('') 
order by 2,3;



with PopVsVac(continent,Location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select c.continent ,c.location ,c.`date` ,c.population ,c2.new_vaccinations, 
sum(convert(c2.new_vaccinations,signed)) over (partition by c.location order by c.location,c.date)
as RollingPeopleVaccinated
from projectportfolio.coviddeaths c 
join projectportfolio.covidvaccinations c2 
on c.location =c2.location 
and c.`date` =c2.`date` 
where c.continent is not null  #and c.continent not IN ('') 
#order by 2,3;
)
select *,(RollingPeopleVaccinated/population)*100 from PopVsVac


#TEMP TABLE


drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent varchar(255),
Location varchar(255),
date datetime,
population INT,
new_vaccinations INT,
RollingPeopleVaccinated INT
);
insert into #PercentPopulationVaccinated
select c.continent ,c.location ,c.`date` ,c.population ,c2.new_vaccinations, 
sum(convert(c2.new_vaccinations,signed)) over (partition by c.location order by c.location,c.date)
as RollingPeopleVaccinated
from projectportfolio.coviddeaths c 
join projectportfolio.covidvaccinations c2 
on c.location =c2.location 
and c.`date` =c2.`date` 
#where c.continent is not null  #and c.continent not IN ('') 
#order by 2,3;
select *,(RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated




Create View projectportfolio.PercentPopulationVaccinated as

select c.continent ,c.location ,c.`date` ,c.population ,c2.new_vaccinations, 
sum(convert(c2.new_vaccinations,signed)) over (partition by c.location order by c.location,c.date)
as RollingPeopleVaccinated
from projectportfolio.coviddeaths c 
join projectportfolio.covidvaccinations c2 
on c.location =c2.location 
and c.`date` =c2.`date` 
where c.continent is not null  
#and c.continent not IN ('') 

Select SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as signed)) as total_deaths, 
SUM(cast(new_deaths as signed))/SUM(New_Cases)*100 as DeathPercentage
From projectportfolio.coviddeaths
#Where location like '%states%'
where continent is not null 
#Group By date
order by 1,2



Select location, SUM(cast(new_deaths as signed)) as TotalDeathCount
From projectportfolio.coviddeaths c 
#Where location like '%states%'
Where c.continent is  null 
and c.location not in ('World', 'European Union', 'International')
Group by c.location
order by TotalDeathCount desc

select *,continent from projectportfolio.coviddeaths c 
where continent  IN ('')

update projectportfolio.coviddeaths set continent=NULL where continent  IN ('null')


Select Location, Population, MAX(total_cases) as HighestInfectionCount, 
Max((total_cases/population))*100 as PercentPopulationInfected
From projectportfolio.CovidDeaths
#Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From projectportfolio.CovidDeaths
#Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc



