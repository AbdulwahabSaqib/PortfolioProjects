Select *
from PortfolioProject..CovidDeaths$
where continent is not NULL
order by 3,4

--Select *
--from PortfolioProject..CovidVaccination$
--order by 1,2

Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
where continent is not NULL
order by 1,2

-- Total cases vs total deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
---where Location like '%Pakistan%'
where continent is not NULL
order by 1,2

--Countries with highest infection rate

Select Location, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
where continent is not NULL
Group by Location, population
---where Location like '%Pakistan%'

order by PercentPopulationInfected desc

--showing countries highest death count
Select Location, MAX(cast(Total_Deaths as int)) as TotalDeathsCount
from PortfolioProject..CovidDeaths$
where continent is not NULL
Group by Location
---where Location like '%Pakistan%'
order by TotalDeathsCount desc


-- By Continents Highest death count


Select continent, MAX(cast(Total_Deaths as int)) as TotalDeathsCount
from PortfolioProject..CovidDeaths$
where continent is not NULL
Group by continent
---where Location like '%Pakistan%'
order by TotalDeathsCount desc









-- Global Numbers

Select date, SUM(new_cases) as total_cases, SUM(cast(total_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
---where Location like '%Pakistan%'
where continent is not NULL
Group by date
order by 1,2

-- total cases right now

Select SUM(new_cases) as total_cases, SUM(cast(total_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
---where Location like '%Pakistan%'
where continent is not NULL
--Group by date
order by 1,2




Select * 
from  PortfolioProject..CovidVaccinations


--Looking for total population vs vaccinaion 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(CONVERT(float, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated, 
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3


-- Use CTE

With PopvsVac(Continent, Location, Date, Population, new_vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(CONVERT(float, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


-- Temp Table


Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)	

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(CONVERT(float, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2, 3

Select *, (RollingPeopleVaccinated/population)*100
from PercentPopulationVaccinated


-- Creating View to store date for visualizations

Create View PercentPopulatedVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(CONVERT(float, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3


Select * 
from PercentPopulatedVaccinated