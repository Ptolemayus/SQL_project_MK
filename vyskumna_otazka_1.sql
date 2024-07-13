-- Zistenie počtu odvetví, kde mzdy rastú, klesajú a sú stabilné
SELECT 
    trend,
    COUNT(DISTINCT industry) AS industry_count
FROM (
    SELECT 
        industry,
        payroll_year,
        AVG(salary) AS average_salary,
        CASE 
            WHEN AVG(salary) > LAG(AVG(salary)) OVER (PARTITION BY industry ORDER BY payroll_year) THEN 'growth'
            WHEN AVG(salary) < LAG(AVG(salary)) OVER (PARTITION BY industry ORDER BY payroll_year) THEN 'decrease'
            ELSE 'Stable'
        END AS trend
    FROM t_Martin_Kmet_project_SQL_primary_final
    GROUP BY 
        industry,
        payroll_year
) trends
GROUP BY 
    trend;
    
-- Rastú v 19, stabilné v 19 a kleasjú v 15