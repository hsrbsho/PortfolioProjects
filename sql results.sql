-- looking at total_cases(病例数） vs total_deaths(死亡人数）
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS deathpercentage
FROM portfolioproject.coviddeaths
ORDER BY location,date;

-- looking at total_cases and population
-- show what percentage of population got Covid
SELECT location,date,total_cases,population,(total_cases/population)*100 AS got_covidpercentage
FROM portfolioproject.coviddeaths
ORDER BY location,date;

-- 找到每个location确诊数最多的时候的感染比例
WITH ranked_data AS (
  SELECT 
    location,population,total_cases,(total_cases / population) * 100 AS percentPopulationInfected,
    ROW_NUMBER() OVER (PARTITION BY location ORDER BY total_cases DESC) AS rn
  FROM coviddeaths)
SELECT 
  location,
  population,
  total_cases AS HighestInfectionCount,
  percentPopulationInfected
FROM ranked_data
WHERE rn = 1
ORDER BY location;

-- 每个地区的最高死亡人数
SELECT location,MAX(cast(total_deaths AS SIGNED)) AS TotalDeathCount
FROM coviddeaths
GROUP BY location;
-- 每个洲的最高死亡人数
SELECT continent,MAX(cast(total_deaths AS SIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent;

-- 所有地区汇总数据
SELECT date,
SUM(cast(new_deaths AS SIGNED)) AS TotalDeath,
SUM(cast(new_cases AS SIGNED)) AS TotalCases,
SUM(cast(new_deaths AS SIGNED))/SUM(cast(new_cases AS SIGNED)) *100 AS DeathPercentage
FROM coviddeaths
GROUP BY date
ORDER BY date;
SELECT 
SUM(cast(new_deaths AS SIGNED)) AS TotalDeath,
SUM(cast(new_cases AS SIGNED)) AS TotalCases,
SUM(cast(new_deaths AS SIGNED))/SUM(cast(new_cases AS SIGNED)) *100 AS DeathPercentage
FROM coviddeaths;

-- 实现每个地区接种疫苗人数的累积分布
SELECT cd.location,cd.date,cd.population,cv.new_vaccinations,
SUM(cast(cv.new_vaccinations AS SIGNED))OVER(PARTITION BY cd.location ORDER BY cd.date) AS RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/cast(cd.population AS SIGNED))*100
FROM coviddeaths cd
JOIN covidvacinations cv
ON cd.location=cv.location  AND cd.date=cv.date;

-- 增加接种人数/人口这一列，这需要解决在同一个select语句中不能使用列的别名的问题（use CTE)
WITH temp(location,date,population,new_vaccinations,RollingPeopleVaccinated)AS(
SELECT cd.location,cd.date,cd.population,cv.new_vaccinations,
SUM(cast(cv.new_vaccinations AS SIGNED))OVER(PARTITION BY cd.location ORDER BY cd.date) AS RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/cast(cd.population AS SIGNED))*100
FROM coviddeaths cd
JOIN covidvacinations cv
ON cd.location=cv.location  AND cd.date=cv.date
)
SELECT * ,(RollingPeopleVaccinated/cast(population AS SIGNED))*100 AS VaccinatedPercentage
FROM temp



