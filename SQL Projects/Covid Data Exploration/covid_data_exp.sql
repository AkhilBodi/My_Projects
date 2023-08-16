use data_exp;
select * from data_exp.CovidDeaths;
select * from data_exp.CovidVaccinations;
-- ALTER TABLE covid_vaccinations RENAME CovidVaccinations;

-- LOAD DATA LOCAL INFILE
-- 'Documents/Data Science/Journey/Projects/CovidDeaths.csv'
-- INTO TABLE data_exp.CovidDeaths
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES;

-- Data By Location(Country)
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent <> ''
ORDER BY location, date; 

-- Death Percentage Of Each Country
SELECT location, date, total_cases, total_deaths , (total_deaths/total_cases)*100 AS death_percent
FROM CovidDeaths
WHERE continent <> ''AND location LIKE '%India%'
ORDER BY date DESC;

-- Countries With Their Population With Covid
SELECT location, date, population, total_cases, total_deaths, (total_cases/population)*100 AS pop_with_covid
FROM CovidDeaths
-- WHERE location LIKE '%India%'
WHERE continent <> ''
ORDER BY location,date;

-- Countries With Their Highest Infection Count And Percentage of population infected
SELECT location, population,MAX(total_cases) AS max_infection_count, MAX((total_cases/population))*100 AS percent_of_pop_infected
FROM CovidDeaths
-- WHERE location LIKE '%India%'
WHERE continent <> ''
GROUP BY location,population
ORDER BY percent_of_pop_infected DESC;

-- Countries With Their Highest Death Count
SELECT location,MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM CovidDeaths
-- WHERE location LIKE '%India%'
WHERE continent <> ''
GROUP BY location
ORDER BY total_death_count DESC;

-- DATA BY CONTINENT

-- The Actual Data
-- SELECT location,MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
-- FROM CovidDeaths
-- -- WHERE location LIKE '%India%'
-- GROUP BY location
-- ORDER BY total_death_count DESC;

-- Continents With Their Highest Death Count
SELECT continent,MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM CovidDeaths
-- WHERE location LIKE '%India%'
WHERE continent <> ''
GROUP BY continent
ORDER BY total_death_count DESC;

-- GLOBAL NUMBERS
-- Total Cases and Deaths With Death Percentage
SELECT date, SUM(total_cases) AS sum_total_cases, SUM(total_deaths) AS sum_total_deaths,(SUM(total_deaths)/SUM(total_cases))*100 AS death_percent
FROM CovidDeaths
WHERE continent <> ''
GROUP BY date
ORDER BY date, sum_total_cases;

-- Total New Cases and New Deaths With Death Percentage
SELECT date, SUM(new_cases) AS sum_new_cases, SUM(new_deaths) AS sum_new_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_percent
FROM CovidDeaths
WHERE continent <> ''
GROUP BY date
ORDER BY date, sum_new_cases;

-- Total Cases And Deaths With Death Percentage
SELECT SUM(new_cases) AS sum_new_cases, SUM(new_deaths) AS sum_new_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_percent
FROM CovidDeaths
WHERE continent <> ''
ORDER BY date, sum_new_cases;

-- Table 2
SELECT * FROM data_exp.CovidVaccinations;

-- JOINING THE TABLES
SELECT * 
FROM data_exp.CovidDeaths death
JOIN data_exp.CovidVaccinations vaccination
	ON death.location = vaccination.location
    AND death.date = vaccination.date;
 
 -- Total Population vs Vaccination
SELECT death.continent, death.location, death.date, death.population, vaccination.new_vaccinations
, SUM(vaccination.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location
, death.date) AS people_vaccinated
FROM data_exp.CovidDeaths death
JOIN data_exp.CovidVaccinations vaccination
	ON death.location = vaccination.location
    AND death.date = vaccination.date
WHERE death.continent <> ''
ORDER BY 2,3;


-- USING COMMON TABLE EXPRESSION

WITH pop_vs_vac (Continent, Location, Date, Population, New_Vaccinations, People_Vaccinated)
AS
(
SELECT death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
SUM(vaccination.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date)
AS people_vaccinated
FROM data_exp.CovidDeaths death
JOIN data_exp.CovidVaccinations vaccination
	ON death.location = vaccination.location
    AND death.date = vaccination.date
WHERE death.continent <> ''
)

SELECT *,(People_Vaccinated/Population)*100 AS vaccination_percent FROM pop_vs_vac;


-- TEMP TABLE 
DROP TABLE IF EXISTS percent_population_vaccinated;
CREATE TEMPORARY TABLE percent_population_vaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_Vaccinations NUMERIC,
People_Vaccinated NUMERIC
);

INSERT INTO percent_population_vaccinated
SELECT death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
SUM(vaccination.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date)
AS people_vaccinated
FROM data_exp.CovidDeaths death
JOIN data_exp.CovidVaccinations vaccination
	ON death.location = vaccination.location
    AND death.date = vaccination.date
WHERE death.continent <> '';

SELECT *,(People_Vaccinated/Population)*100 AS vaccination_percent FROM percent_population_vaccinated;

-- CREATING VIEW
CREATE VIEW percent_population_vaccinated AS 
SELECT death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
SUM(vaccination.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date)
AS people_vaccinated
FROM data_exp.CovidDeaths death
JOIN data_exp.CovidVaccinations vaccination
	ON death.location = vaccination.location
    AND death.date = vaccination.date
WHERE death.continent <> '';

SELECT * FROM percent_population_vaccinated;
