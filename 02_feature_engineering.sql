CREATE VIEW loan_analysis_view AS
SELECT 
    *,

    -- Total Income
    ApplicantIncome + CoapplicantIncome AS Total_Income,

    -- Income Group
    CASE 
        WHEN ApplicantIncome < 3000 THEN 'Low'
        WHEN ApplicantIncome BETWEEN 3000 AND 7000 THEN 'Medium'
        ELSE 'High'
    END AS Income_Group,

    -- Loan Status Label
    CASE 
        WHEN Loan_Status = 'Y' THEN 'Approved'
        ELSE 'Rejected'
    END AS Loan_Status_Label,

    -- Risk Category (VERY IMPORTANT 🔥)
    CASE 
        WHEN Credit_History = 1 THEN 'Low Risk'
        ELSE 'High Risk'
    END AS Risk_Category

FROM loan_data;

SELECT * 
FROM loan_analysis_view 
LIMIT 10;