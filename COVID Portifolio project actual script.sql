Select*
From PortfolioProject..CovidDeaths$
Where continent is not null
Order by 3,4

--Select*
--From PortfolioProject..CovidVaccinations$
--Order by 3,4

--Select Data that we are going to be using



--Looking at Total Cases Vs Total Deaths

Select Location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
Order by 1,2

SELECT 
   location,
   date,
   total_deaths,
   total_cases,
   CASE 
      WHEN total_cases <> 0 THEN total_deaths * 100 / total_cases
      ELSE NULL
   END AS deathPercentage
FROM PortfolioProject..CovidDeaths$;

--Looking at Total Cases vs Population
--shows what percentage of population got covid

select Location,date,population_density, total_cases, (total_cases/population_density)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
where location like '%states%'
and continent is not null
Order by 1,2

--looking at countries with highest infection rate compared to population

select Location,population_density, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population_density))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
--where location like '%states%'
Group by location, population_density
Order by PercentPopulationInfected desc

--Showing countries with Highest Death Count per population

select Location,MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--where location like '%states%'
Where continent is not null
Group by location
Order by TotalDeathCount desc

--LETS BREAK THINGS DOWN BY CONTINENT


--Showing continents with the highest death count per population

select continent,MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(New_deaths)/SUM(cast(New_deaths as int))/SUM(New_Cases)*100 as DeathPercentage--,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
From PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

--Looking at total population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population_density,vac.new_vaccinations
,Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population_density)*100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 order by 2,3

 ---Use CTE

 With popvsvac (continent,location,date ,population_density,new_vaccinations,rollingpeoplevaccinated)
 as
 (
 select dea.continent,dea.location,dea.date,dea.population_density,vac.new_vaccinations 
,Sum(convert(int,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population_density)*100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --order by 2,3
 )
 Select*, (rollingpeoplevaccinated/population_density)*100
 from popvsvac

 --Temp table

 drop table if exists  #percentpopulationvaccinated
 Create table #percentpopulationvaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 rollingpeoplevaccinated numeric
 )

 insert into #percentpopulationvaccinated
 select dea.continent,dea.location,dea.date,dea.population_density,vac.new_vaccinations 
,Sum(convert(int,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population_density)*100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 --where dea.continent is not null
 --order by 2,3

 select*,(rollingpeoplevaccinated/population)*100
 from #percentpopulationvaccinated



 --Creating view to store data for later visualization
 create view percentpopulationvaccinated as
 select dea.continent,dea.location,dea.date,dea.population_density,vac.new_vaccinations 
,Sum(convert(int,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population_density)*100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --order by 2,3


 select*
 from percentpopulationvaccinated












