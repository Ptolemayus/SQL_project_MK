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

SELECT 
	*
FROM czechia_payroll_industry_branch cpib 
/*
 * 	A	Zemědělství, lesnictví, rybářství
	B	Těžba a dobývání
	C	Zpracovatelský průmysl
	D	Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu
	E	Zásobování vodou; činnosti související s odpady a sanacemi
	F	Stavebnictví
	G	Velkoobchod a maloobchod; opravy a údržba motorových vozidel
	H	Doprava a skladování
	I	Ubytování, stravování a pohostinství
	J	Informační a komunikační činnosti
	K	Peněžnictví a pojišťovnictví
	L	Činnosti v oblasti nemovitostí
	M	Profesní, vědecké a technické činnosti
	N	Administrativní a podpůrné činnosti
	O	Veřejná správa a obrana; povinné sociální zabezpečení
	P	Vzdělávání
	Q	Zdravotní a sociální péče
	R	Kulturní, zábavní a rekreační činnosti
	S	Ostatní činnosti
 */

CREATE TABLE t_Martin_Kmet_project_SQL_primary_final
AS (
	SELECT 
		cpay.payroll_id,
		cpay.salary,
		cpay.payroll_calculation,
		cpay.payroll_industry,
		cpay.`year`,
		cp.price_category,
		cp.amount,
		cp.price_unit,
		cp.product, 
		cp.price,
		cp.region_code
	FROM 
		(
		SELECT 
			cp.id AS payroll_id,
			round(avg(cp.value ), 2) AS salary,
			CASE  
				WHEN calculation_code = 100 THEN "fyzický"
				ELSE "přepočtený"
			END
			AS payroll_calculation,
			cp.payroll_year AS `year`,
			CASE 
				WHEN cp.industry_branch_code = "A" THEN "Zemědělství, lesnictví, rybářství"
				WHEN cp.industry_branch_code = "B" THEN "Těžba a dobývání"
				WHEN cp.industry_branch_code = "C" THEN "Zpracovatelský průmysl"
				WHEN cp.industry_branch_code = "D" THEN "Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu"
				WHEN cp.industry_branch_code = "E" THEN "Zásobování vodou; činnosti související s odpady a sanacemi"
				WHEN cp.industry_branch_code = "F" THEN "Stavebnictví"
				WHEN cp.industry_branch_code = "G" THEN "Velkoobchod a maloobchod; opravy a údržba motorových vozidel"
				WHEN cp.industry_branch_code = "H" THEN "Doprava a skladování"
				WHEN cp.industry_branch_code = "I" THEN "Ubytování, stravování a pohostinství"
				WHEN cp.industry_branch_code = "J" THEN "Informační a komunikační činnosti"
				WHEN cp.industry_branch_code = "K" THEN "Peněžnictví a pojišťovnictví"
				WHEN cp.industry_branch_code = "L" THEN "Činnosti v oblasti nemovitostí"
				WHEN cp.industry_branch_code = "M" THEN "Profesní, vědecké a technické činnosti"
				WHEN cp.industry_branch_code = "N" THEN "Administrativní a podpůrné činnosti"
				WHEN cp.industry_branch_code = "O" THEN "Veřejná správa a obrana; povinné sociální zabezpečení"
				WHEN cp.industry_branch_code = "P" THEN "Vzdělávání"
				WHEN cp.industry_branch_code = "Q" THEN "Zdravotní a sociální péče"
				WHEN cp.industry_branch_code = "R" THEN "Kulturní, zábavní a rekreační činnosti"
				WHEN cp.industry_branch_code = "S" THEN "Ostatní činnosti"
			END 
			AS payroll_industry
		FROM czechia_payroll cp 
		WHERE cp.value_type_code = 5958
		AND cp.calculation_code = 200
		GROUP BY 
			cp.id,
			cp.value_type_code,
			cp.unit_code,
			cp.calculation_code,
			cp.industry_branch_code,
			cp.payroll_year	
		) cpay
		INNER JOIN 
		(SELECT 
				czpc.name AS price_category,
				czpc.price_value AS amount,
				czpc.price_unit,
				czp.id AS product, 
				round(avg(czp.value), 2) AS price,
				czp.category_code AS product_code,
				czp.region_code,
				czp.date_from
			FROM czechia_price czp
			LEFT JOIN czechia_price_category czpc
				ON czp.category_code = czpc.code
			GROUP BY 
				czpc.name,
				czpc.price_value,
				czpc.price_unit,
				czp.id, 
				czp.category_code,
				czp.region_code,
				YEAR(czp.date_from)
			) cp
		ON YEAR (cp.date_from) = cpay.`year`
);

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

