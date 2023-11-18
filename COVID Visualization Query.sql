/*

Queries used for Tableau Project

*/



-- 1. 
--Global numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Project..CovidDeaths
--Where location like '%india%' 
where continent is not null
--group by date
order by 1,2


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select Location,SUM(cast(total_deaths as int))as TotalDeathCount
From Project..CovidDeaths
--Where location like '%india%'
where continent is  null
and location not in ('World', 'European Union', 'International')
group by Location 
order by TotalDeathCount desc

-- 3.--Looking at Countries having highest infection rate compared to  whole population
Select Location,population,MAX(total_cases)as HighestInfectionCount,
MAX(( total_cases/population))*100 as PercentPopulationInfected
From Project..CovidDeaths
--Where location like '%india%'
--where continent is not null
group by Location, population
order by PercentPopulationInfected desc

-- 4.

Select Location,population,date,MAX(total_cases)as HighestInfectionCount,
MAX(( total_cases/population))*100 as PercentPopulationInfected
From Project..CovidDeaths
--Where location like '%india%'
--where continent is not null
group by Location, population, date
order by PercentPopulationInfected desc












-- Queries I originally had, but excluded some because it created too long of video
-- Here only in case you want to check them out


-- 1.
--Looking at Total Population Vs Vaccinations
SELECT dea.continent, dea.location, dea.date,dea.population,
MAX(vac.total_vaccinations ) as RollingCountOfPeopleVaccinated
--,(RollingCountOfPeopleVaccinated/population)*100
FROM Project..CovidDeaths dea
Join Project..CovidVaccinations vac
	on dea.location =vac.location
	and dea.date= vac.date
where dea.continent is not null
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3



-- 2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Project..CovidDeaths
--Where location like '%india%' 
where continent is not null
--group by date
order by 1,2


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe
Select location,SUM(cast(total_deaths as int))as TotalDeathCount
From Project..CovidDeaths
--Where location like '%india%'
where continent is not null
and location not in ('World', 'European Union', 'International')
group by location
order by TotalDeathCount desc


-- 4.
Select Location,population,MAX(total_cases)as HighestInfectionCount,
MAX(( total_cases/population))*100 as PercentPopulationInfected
From Project..CovidDeaths
--Where location like '%india%'
--where continent is not null
group by Location, population
order by PercentPopulationInfected desc




-- 5.
--Select Location,date,total_cases,total_deaths,( total_deaths/total_cases)*100 as DeathPercentage
--From Project..CovidDeaths
--Where location like '%india%' and continent is not null
--order by 1,2

-- took the above query and added population
Select Location,date,population,total_cases,total_deaths
From Project..CovidDeaths
--Where location like '%india%' and
Where continent is not null
order by 1,2


-- 6. 
--Use CTE of the previous query for getting percentage of  RollingCountOfPeopleVaccinated column
with PopVsVac (Continent, Location, Date, Population,New_Vaccination, RollingCountOfPeopleVaccinated)
as (
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingCountOfPeopleVaccinated
FROM Project..CovidDeaths dea
Join Project..CovidVaccinations vac
	on dea.location =vac.location
	and dea.date= vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingCountOfPeopleVaccinated/Population)*100 as percentPeopleVaccinated
From PopVsVac

-- 7. 
--Looking at Total Cases Vs Population
--shows what % of population got covid
Select Location,population,date,MAX(total_cases) as HighestInfectionCount,MAX(( total_cases/population))*100 as PercentPopulationInfected
From Project..CovidDeaths
--Where location like '%india%'
Group by Location, Population, date
order by PercentPopulationInfected desc

