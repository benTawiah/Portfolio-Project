Select *
from covid..CovidDeaths  
order by 3, 4;

--Select *
--from covid..CovidVaccinations
--order by 3, 4;

--Selecting Data to Use
Select location, date, total_cases,new_cases,total_deaths,population
from covid..CovidDeaths  
order by 1,2

--Total cases vs Total Deaths
Select location, date, total_cases,total_deaths, (convert(float,total_deaths) /NULLIF(convert(float, total_cases),0))*100 as DeathPercentage
from covid..CovidDeaths  
where location like 'ghana'

--Total cases vs Population

Select location, date, population,total_cases, (convert(float,total_cases) /NULLIF(convert(float, population),0))*100 as PopulationInfected
from covid..CovidDeaths  
where location like 'ghana'

--Countries with highest infection rate compared to population
Select location, population, max(total_cases) as HighestInfection, max((convert(float,total_cases)) /NULLIF(convert(float, population),0))*100 as PopulationInfected
from covid..CovidDeaths  
group by location,population
order by PopulationInfected desc



--Countries with highest Death count per population
Select location,  max(cast(total_deaths as int)) as TotalDeathCount
from covid..CovidDeaths  
where continent = ''
group by location
order by TotalDeathCount desc



--Continent with Highest Death Count
Select continent,  max(cast(total_deaths as int)) as TotalDeathCount
from covid..CovidDeaths  
where continent is not null
group by continent
order by TotalDeathCount desc



-- Global Numbers

Select SUM(cast(new_cases as int)) as TotalCases,  SUM(CAST(new_deaths AS int)) as TotalDeaths, SUM(CAST(new_deaths AS float)) / SUM(cast(new_cases as float)) *100 as DeathPercentage
from covid..CovidDeaths  
where continent =''
--group by date
order by 1,2


--Total Population vs Vaccionations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccine
--(RollingPeopleVaccine / population)
from covid..CovidDeaths dea
JOIN covid..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



--USE CTE
With PopvsVac (Continent, Location,Date, Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, cast(dea.population as float), vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccine / population)
from covid..CovidDeaths dea
JOIN covid..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated / NULLIF(Population,0)) *100 as VaccinationRate
from PopvsVac


--TEMP TABLE

CREATE Table #PercentPopulationVaccinate
(
	Continent NVARCHAR(255),
	Location NVARCHAR(255),
	Date DATETIME,
	Population FLOAT,
	New_vaccinations FLOAT,
	RollingPeopleVaccinated FLOAT

);

--Drop Table if exists #PercentPopulationVaccinate


insert into #PercentPopulationVaccinate

Select dea.continent, dea.location, dea.date, cast(dea.population as float), vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccine / population)
from covid..CovidDeaths dea
JOIN covid..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated / NULLIF(Population,0)) *100 as VaccinationRate
from #PercentPopulationVaccinate



--CREATING VIEW TO STORE DATA FOR VISUALIZATION

Create View PercentPopulationVaccinate as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid..CovidDeaths dea
Join covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


Select * 
from PercentPopulationVaccinate



