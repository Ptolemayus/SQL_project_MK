#mleko 114201
#chleb 111301

SELECT *
FROM (
	SELECT 
		payroll_year,
		food_code,
		food,
		value,
		salary,
		ROUND((salary/value), 0) AS How_much
	FROM t_Martin_Kmet_project_SQL_primary_final
	WHERE food_code IN (114201, 111301)
		AND industry_code IS NULL
	GROUP BY payroll_year, food_code 
	ORDER BY payroll_year ASC 
	LIMIT 2) AS subquery1
UNION ALL
SELECT *
FROM (
	SELECT 
		payroll_year,
		food_code,
		food,
		value,
		salary,
		ROUND((salary/value), 0) AS How_much
	FROM t_Martin_Kmet_project_SQL_primary_final
	WHERE food_code IN (114201, 111301)
		AND industry_code IS NULL
	GROUP BY payroll_year, food_code 
	ORDER BY payroll_year DESC 
	LIMIT 2) AS subquery2
;
    
-- 2006 CH - 1.192, Kg / M - 1.331, L
-- 2018 CH - 1.300, Kg / M - 1.590, L