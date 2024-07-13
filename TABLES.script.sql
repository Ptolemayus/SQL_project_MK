SELECT 
	*
FROM czechia_payroll_calculation cpc;
-- 100 = fyzický / 200 = přepočtený

SELECT 
	*
FROM czechia_payroll_unit cpu;
-- 200 = kč / 80,403 = tis. osob (tis. os.)

SELECT 
	*
FROM czechia_payroll_value_type cpvt;    
-- 316 = Průměrný počet zaměstnaných osob / 5958 = Průměrná hrubá mzda na zaměstnance

CREATE OR REPLACE TABLE t_Martin_Kmet_project_SQL_primary_final 
AS (
	SELECT 
	cpay.payroll_year,
	cpay.industry,
	cpay.industry_code,
	cpay.salary,
	cpay.value_type_code,
	cp.food_code,
	cp.food,
	cp.value
	FROM (
	SELECT
		year(cp.date_from) AS date_from,
		round(avg(cp.value), 2) AS value,
		cpc.code AS food_code,
		cpc.name AS food,
		cpc.price_value AS price,
		cpc.price_unit AS price_unit
	FROM czechia_price cp
	LEFT JOIN czechia_price_category cpc 
		ON cp.category_code = cpc.code
	WHERE region_code IS NULL
	GROUP BY food_code, year(cp.date_from)
	) cp
	INNER JOIN (
	SELECT 
		cpay.value_type_code AS value_type_code,
		cpay.unit_code AS unit_code,
		cpay_u.name AS unit_code_name,
		round(avg(cpay.value ), 2) AS salary,
		cpay.payroll_year AS payroll_year,
		cpay.calculation_code AS calculation_code,
		cpay_c.name AS cpc_name,
		cpay.industry_branch_code AS industry_code,
		cpay_ib.name AS industry
	FROM czechia_payroll cpay
	LEFT JOIN czechia_payroll_calculation cpay_c 
		ON cpay.calculation_code = cpay_c.code
	LEFT JOIN czechia_payroll_industry_branch cpay_ib 
		ON cpay.industry_branch_code = cpay_ib.code 
	LEFT JOIN czechia_payroll_unit cpay_u
		ON cpay.unit_code = cpay_u.code 
	LEFT JOIN czechia_payroll_value_type cpay_vt
		ON cpay.value_type_code = cpay_vt.code
	WHERE cpay.value_type_code = 5958
	GROUP BY payroll_year, industry_code
	) cpay 
	ON cp.date_from = cpay.payroll_year);

-- just GDP of CR needed for project
CREATE TABLE t_Martin_Kmet_project_SQL_secondary_final
AS (
	SELECT 
		e.GDP,
		e.`year`
	FROM economies e 
	LEFT JOIN countries c 
		ON e.country = c.country 
	WHERE e.country = "Czech Republic"
	AND e.GDP IS NOT NULL 
	);

