-- Analyze how credit history impacts loan approval
SELECT 
    Credit_History,
    Loan_Status_Label,
    COUNT(*) AS count
FROM loan_analysis_view
GROUP BY Credit_History, Loan_Status_Label
ORDER BY Credit_History;

-- Distribution of applicants based on risk category
SELECT 
    Risk_Category,
    COUNT(*) AS total_applicants
FROM loan_analysis_view
GROUP BY Risk_Category;

-- Analyze approval rate based on financial burden (loan vs income)
SELECT 
    CASE 
        WHEN LoanAmount / NULLIF(Total_Income, 0) < 0.2 THEN 'Low Burden'
        WHEN LoanAmount / NULLIF(Total_Income, 0) BETWEEN 0.2 AND 0.5 THEN 'Medium Burden'
        ELSE 'High Burden'
    END AS burden_category,

    ROUND(
        (COUNT(*) FILTER (WHERE Loan_Status_Label = 'Approved') * 100.0 
        / COUNT(*))::numeric, 
        2
    ) AS approval_rate

FROM loan_analysis_view
GROUP BY burden_category;

-- Analyze how income level affects loan approval
SELECT 
    Income_Group,
    Loan_Status_Label,
    COUNT(*) AS count
FROM loan_analysis_view
GROUP BY Income_Group, Loan_Status_Label;

-- Check if having a coapplicant improves approval chances
SELECT 
    CASE 
        WHEN CoapplicantIncome > 0 THEN 'Has Coapplicant'
        ELSE 'No Coapplicant'
    END AS coapplicant_status,

    ROUND(
        (COUNT(*) FILTER (WHERE Loan_Status_Label = 'Approved') * 100.0 
        / COUNT(*))::numeric, 
        2
    ) AS approval_rate

FROM loan_analysis_view
GROUP BY coapplicant_status;

-- Analyze approval rate across different property areas
SELECT 
    Property_Area,
    ROUND(
        (COUNT(*) FILTER (WHERE Loan_Status_Label = 'Approved') * 100.0 
        / COUNT(*))::numeric, 
        2
    ) AS approval_rate

FROM loan_analysis_view
GROUP BY Property_Area;

-- Check whether education level impacts approval
SELECT 
    Education,
    ROUND(
        (COUNT(*) FILTER (WHERE Loan_Status_Label = 'Approved') * 100.0 
        / COUNT(*))::numeric, 
        2
    ) AS approval_rate

FROM loan_analysis_view
GROUP BY Education;

-- Identify high-risk combinations (low income + poor credit history)
SELECT 
    Income_Group,
    Credit_History,
    ROUND(
        (COUNT(*) FILTER (WHERE Loan_Status_Label = 'Rejected') * 100.0 
        / COUNT(*))::numeric, 
        2
    ) AS rejection_rate

FROM loan_analysis_view
GROUP BY Income_Group, Credit_History
ORDER BY rejection_rate DESC;