WITH food_prices AS (
    SELECT
        payroll_year,
        food_code,
        AVG(value) AS avg_price
    FROM t_Martin_Kmet_project_SQL_primary_final
    GROUP BY payroll_year, food_code
),
percentage_increase AS (
    SELECT
        fp1.food_code,
        ((fp2.avg_price - fp1.avg_price) / fp1.avg_price) * 100 AS percentage_increase
    FROM food_prices fp1
    JOIN food_prices fp2 ON fp1.food_code = fp2.food_code AND fp1.payroll_year + 1 = fp2.payroll_year
)
SELECT
    food_code,
    AVG(percentage_increase) AS average_increase
FROM percentage_increase
GROUP BY food_code
ORDER BY average_increase ASC;

-- Cukr krystalový	-1.92 %

