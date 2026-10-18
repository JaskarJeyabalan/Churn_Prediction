USE db_Churn
GO

IF OBJECT_ID('dbo.prod_Churn', 'U') IS NOT NULL
    DROP TABLE dbo.prod_Churn;
GO

WITH Median_Charge AS (
    -- median of VALID (>= 0) monthly charges for each internet type
    SELECT DISTINCT
        ISNULL(Internet_Type, 'None') AS Internet_Type,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Monthly_Charge)
            OVER (PARTITION BY ISNULL(Internet_Type, 'None')) AS Median_Monthly_Charge
    FROM [db_Churn].[dbo].[stg_Churn]
    WHERE Monthly_Charge >= 0
)
SELECT
    s.Customer_ID,
    s.Gender,
    s.Age,
    s.Married,
    s.State,
    s.Number_of_Referrals,
    s.Tenure_in_Months,
    ISNULL(s.Value_Deal, 'None') AS Value_Deal,
    s.Phone_Service,
    ISNULL(s.Multiple_Lines, 'No') AS Multiple_Lines,
    s.Internet_Service,
    ISNULL(s.Internet_Type, 'None') AS Internet_Type,
    ISNULL(s.Online_Security, 'No') AS Online_Security,
    ISNULL(s.Online_Backup, 'No') AS Online_Backup,
    ISNULL(s.Device_Protection_Plan, 'No') AS Device_Protection_Plan,
    ISNULL(s.Premium_Support, 'No') AS Premium_Support,
    ISNULL(s.Streaming_TV, 'No') AS Streaming_TV,
    ISNULL(s.Streaming_Movies, 'No') AS Streaming_Movies,
    ISNULL(s.Streaming_Music, 'No') AS Streaming_Music,
    ISNULL(s.Unlimited_Data, 'No') AS Unlimited_Data,
    s.Contract,
    s.Paperless_Billing,
    s.Payment_Method,
    CASE WHEN s.Monthly_Charge < 0 THEN m.Median_Monthly_Charge
         ELSE s.Monthly_Charge END                                      AS Monthly_Charge,
    s.Total_Charges,
    s.Total_Refunds,
    s.Total_Extra_Data_Charges,
    s.Total_Long_Distance_Charges,
    s.Total_Revenue,
    s.Customer_Status,
    CASE WHEN s.Customer_Status = 'Churned'
         THEN ISNULL(s.Churn_Category, 'Unknown') ELSE 'Not Applicable' END AS Churn_Category,
    CASE WHEN s.Customer_Status = 'Churned'
         THEN ISNULL(s.Churn_Reason,   'Unknown') ELSE 'Not Applicable' END AS Churn_Reason
INTO [db_Churn].[dbo].[prod_Churn]
FROM [db_Churn].[dbo].[stg_Churn] AS s
LEFT JOIN Median_Charge AS m
       ON m.Internet_Type = ISNULL(s.Internet_Type, 'None');
GO

-- sanity checks (expect 6418 rows, 0 negative charges)
SELECT COUNT(*) AS Total_Rows,
       SUM(CASE WHEN Monthly_Charge < 0 THEN 1 ELSE 0 END) AS Negative_Charges
FROM prod_Churn;
