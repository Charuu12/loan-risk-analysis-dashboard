CREATE TABLE loan_data (
    Loan_ID VARCHAR(20),
    Gender VARCHAR(10),
    Married VARCHAR(10),
    Dependents VARCHAR(10),
    Education VARCHAR(20),
    Self_Employed VARCHAR(10),
    ApplicantIncome INT,
    CoapplicantIncome FLOAT,
    LoanAmount FLOAT,
    Loan_Amount_Term FLOAT,
    Credit_History FLOAT,
    Property_Area VARCHAR(20),
    Loan_Status VARCHAR(5)
);
-- Verify data
SELECT * FROM loan_data LIMIT 10;



-- Data Cleaning
SELECT 
    COUNT(*) FILTER (WHERE LoanAmount IS NULL) AS missing_loan_amount,
    COUNT(*) FILTER (WHERE Credit_History IS NULL) AS missing_credit_history,
    COUNT(*) FILTER (WHERE Gender IS NULL) AS missing_gender,
    COUNT(*) FILTER (WHERE Dependents IS NULL) AS missing_dependents
FROM loan_data;

-- Fix Credit_History
UPDATE loan_data
SET Credit_History = 0
WHERE Credit_History IS NULL;

-- Fix LoanAmount
UPDATE loan_data
SET LoanAmount = (
    SELECT AVG(LoanAmount) FROM loan_data
)
WHERE LoanAmount IS NULL;

-- Fix Gender
UPDATE loan_data
SET Gender = 'Unknown'
WHERE Gender IS NULL;

-- Fix Dependants
UPDATE loan_data
SET Dependents = '0'
WHERE Dependents IS NULL;

-- Fix Self_Employed
UPDATE loan_data
SET Self_Employed = 'No'
WHERE Self_Employed IS NULL;

-- Fix Loan Term
UPDATE loan_data
SET Loan_Amount_Term = 360
WHERE Loan_Amount_Term IS NULL;

-- Fix Married
UPDATE loan_data
SET Married = 'No'
WHERE Married IS NULL;

SELECT 
    COUNT(*) FILTER (WHERE Loan_ID IS NULL) AS Loan_ID_nulls,
    COUNT(*) FILTER (WHERE Gender IS NULL) AS Gender_nulls,
    COUNT(*) FILTER (WHERE Married IS NULL) AS Married_nulls,
    COUNT(*) FILTER (WHERE Dependents IS NULL) AS Dependents_nulls,
    COUNT(*) FILTER (WHERE Education IS NULL) AS Education_nulls,
    COUNT(*) FILTER (WHERE Self_Employed IS NULL) AS Self_Employed_nulls,
    COUNT(*) FILTER (WHERE ApplicantIncome IS NULL) AS ApplicantIncome_nulls,
    COUNT(*) FILTER (WHERE CoapplicantIncome IS NULL) AS CoapplicantIncome_nulls,
    COUNT(*) FILTER (WHERE LoanAmount IS NULL) AS LoanAmount_nulls,
    COUNT(*) FILTER (WHERE Loan_Amount_Term IS NULL) AS Loan_Term_nulls,
    COUNT(*) FILTER (WHERE Credit_History IS NULL) AS Credit_History_nulls,
    COUNT(*) FILTER (WHERE Property_Area IS NULL) AS Property_Area_nulls,
    COUNT(*) FILTER (WHERE Loan_Status IS NULL) AS Loan_Status_nulls
FROM loan_data;