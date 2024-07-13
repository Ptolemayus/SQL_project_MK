-- Calculate year-over-year changes
SELECT
    year,
    avg_food_price,
    LAG(avg_food_price) OVER (ORDER BY year) AS prev_avg_food_price,
    avg_salary,
    LAG(avg_salary) OVER (ORDER BY year) AS prev_avg_salary,
    GDP,
    LAG(GDP) OVER (ORDER BY year) AS prev_GDP,
    (avg_food_price - LAG(avg_food_price) OVER (ORDER BY year)) / LAG(avg_food_price) OVER (ORDER BY year) * 100 AS food_price_change,
    (avg_salary - LAG(avg_salary) OVER (ORDER BY year)) / LAG(avg_salary) OVER (ORDER BY year) * 100 AS salary_change,
    (GDP - LAG(GDP) OVER (ORDER BY year)) / LAG(GDP) OVER (ORDER BY year) * 100 AS GDP_change
FROM (
    SELECT
        f.payroll_year AS year,
        AVG(f.value) AS avg_food_price,
        AVG(f.salary) AS avg_salary,
        g.GDP
    FROM t_Martin_Kmet_project_SQL_primary_final f
    INNER JOIN t_Martin_Kmet_project_SQL_secondary_final g
        ON f.payroll_year = g.year
    GROUP BY f.payroll_year, g.GDP
    ORDER BY f.payroll_year
) subquery;

-- Nevidím vážnejšiu koreláciu medzi zmenou GDP a zmenou miezd alebo cien potravín