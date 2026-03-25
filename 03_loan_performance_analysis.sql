-- Total number of loan applications
SELECT COUNT(*) AS total_applications
FROM loan_analysis_view;

-- Count of approved vs rejected loans
SELECT Loan_Status_Label, COUNT(*) AS total
FROM loan_analysis_view
GROUP BY Loan_Status_Label;

-- Percentage of loans approved
SELECT 
   ROUND(
    (COUNT(*) FILTER (WHERE Loan_Status_Label = 'Approved') * 100.0 
    / COUNT(*))::numeric, 
    2
) AS approval_rate_percentage
FROM loan_analysis_view;


-- Average loan amount across all applications
SELECT ROUND(AVG(LoanAmount)::numeric, 2) AS avg_loan_amount
FROM loan_analysis_view;

-- Categorizing loans into Small, Medium, Large
SELECT 
    CASE 
        WHEN LoanAmount < 100 THEN 'Small'
        WHEN LoanAmount BETWEEN 100 AND 200 THEN 'Medium'
        ELSE 'Large'
    END AS loan_size,
    COUNT(*) AS count
FROM loan_analysis_view
GROUP BY loan_size;

-- Approval rate for different loan size categories
SELECT 
    CASE 
        WHEN LoanAmount < 100 THEN 'Small'
        WHEN LoanAmount BETWEEN 100 AND 200 THEN 'Medium'
        ELSE 'Large'
    END AS loan_size,
    
    ROUND(
        COUNT(*) FILTER (WHERE Loan_Status_Label = 'Approved') * 100.0 
        / COUNT(*), 2
    ) AS approval_rate
FROM loan_analysis_view
GROUP BY loan_size;

-- Average loan amount for each category
SELECT 
    CASE 
        WHEN LoanAmount < 100 THEN 'Small'
        WHEN LoanAmount BETWEEN 100 AND 200 THEN 'Medium'
        ELSE 'Large'
    END AS loan_size,

    ROUND(AVG(LoanAmount)::numeric, 2) AS avg_loan

FROM loan_analysis_view
GROUP BY loan_size;

-- Total loan amount disbursed (approved loans only)
SELECT 
    ROUND(SUM(LoanAmount)::numeric, 2) AS total_disbursed_amount
FROM loan_analysis_view
WHERE Loan_Status_Label = 'Approved';

-- Contribution of each loan size category to total approved loan value
SELECT 
    loan_size,
    
    ROUND(
        (
            SUM(LoanAmount) * 100.0 
            / SUM(SUM(LoanAmount)) OVER ()
        )::numeric, 
        2
    ) AS contribution_percentage

FROM (
    SELECT 
        LoanAmount,
        CASE 
            WHEN LoanAmount < 100 THEN 'Small'
            WHEN LoanAmount BETWEEN 100 AND 200 THEN 'Medium'
            ELSE 'Large'
        END AS loan_size
    FROM loan_analysis_view
    WHERE Loan_Status_Label = 'Approved'
) sub

GROUP BY loan_size;

-- Average ratio of loan amount to total income (financial burden)
SELECT 
    ROUND(
        AVG(LoanAmount / NULLIF(Total_Income, 0))::numeric,3) AS avg_loan_income_ratio
FROM loan_analysis_view;

-- Top 10 highest loan amounts (approved loans)
SELECT Loan_ID, LoanAmount
FROM loan_analysis_view
WHERE Loan_Status_Label = 'Approved'
ORDER BY LoanAmount DESC
LIMIT 10;

