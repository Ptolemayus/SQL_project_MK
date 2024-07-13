WITH Report AS(
	SELECT 
		t1.payroll_year AS payroll_year,
		t1.salary AS salary,
		t2.salary AS salary_next_year,
		ROUND(((t2.salary - t1.salary)/t1.salary)*100, 2) AS difference_salary,
		AVG(t1.value) AS food_price,
		AVG(t2.value) AS food_price_next_year,
		AVG(ROUND(((t2.value/t1.value) - 1)*100, 2)) AS difference_food
	FROM t_jan_kaminsky_project_SQL_primary_final t1
	JOIN t_jan_kaminsky_project_SQL_primary_final t2
		ON t1.payroll_year = t2.payroll_year-1
		AND t1.food_code = t2.food_code
	WHERE t1.ib_code IS NULL
	GROUP BY t1.payroll_year)
SELECT
	payroll_year,
	(payroll_year + 1) AS nextyear,
	salary,
	food_price,
	(difference_food - difference_salary) AS salaries_X_food,
	difference_salary,
	difference_food	
FROM Report 
ORDER BY salaries_X_food DESC
;

-- Áno, z 2012 na 2013. Jedlo + 11,05 % a Mzdy 0,00% (pokles menej než 0,001%)