Create database Credit_Debit_KPI;
use Credit_Debit_KPI;

 CREATE TABLE bank_data
    (Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(100),
    Account_Number BIGINT,
    Transaction_Date VARCHAR(30),
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(15,2),
    Balance DECIMAL(15,2),
    Branch VARCHAR(100),
    Transaction_Method VARCHAR(50),
    Bank_Name VARCHAR(100),
    Credit_Amount DECIMAL(15,2),
    Debit_Amount DECIMAL(15,2),
    High_Risk_Flag VARCHAR(10),
    Month_Year VARCHAR(20)
    );



 
SET GLOBAL Local_infile=1;
LOAD DATA LOCAL INFILE "C:/Temp/Credit and Debit Data SQL.csv"
INTO TABLE bank_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

(
Customer_Id,
Customer_Name,
Account_Number,
@Transaction_Date,
Transaction_Type,
Amount,
Balance,
Branch,
Transaction_Method,
Bank_Name,
Credit_Amount,
Debit_Amount,
High_Risk_Flag,
Month_Year
)
SET Transaction_Date = STR_TO_DATE(@Transaction_Date, '%d-%m-%Y');

select * from bank_data;
SELECT COUNT(*) FROM bank_data;



SELECT Customer_ID,Customer_Name, COUNT(*) AS Num_Transactions, ROUND(AVG(Balance),2) AS Avg_Balance, ROUND(COUNT(*)/NULLIF(AVG(Balance),0),6) AS Activity_Ratio 
FROM bank_data GROUP BY Customer_ID, Customer_Name ORDER BY Activity_Ratio DESC LIMIT 10; 

SELECT Month_Year AS Month, COUNT(*) AS Transaction_Count,
CONCAT(ROUND(SUM(Amount)/1000000,2),'M') AS Total_Amount,
ROUND(SUM(Amount)*100.0/(SELECT SUM(Amount) FROM bank_data),2) AS PCT_of_Total
FROM bank_data
GROUP BY Month_Year
ORDER BY SUM(Amount) DESC;


SELECT Branch, ROUND(SUM(Amount),2) AS Total_Transaction_Amount, COUNT(*) AS Total_Transactions, 
CONCAT(ROUND(SUM(Amount)/1000000,2),'M') AS Total_Amount,
CONCAT(ROUND(AVG(Amount),2),'') AS Avg_Transaction_Amount,
ROUND(SUM(Amount)*100.0/(SELECT SUM(Amount)
FROM bank_data),2) AS PCT_of_Total
FROM bank_data
GROUP BY `Branch`
ORDER BY SUM(`Amount`) DESC;

SELECT Bank_Name, ROUND(SUM(Amount),2) AS Total_Transaction_Volume, COUNT(*) AS Transaction_Count,
CONCAT(ROUND(SUM(Amount)/1000000,2),'M') AS Total_Amount,
CONCAT(ROUND(AVG(Amount), 2),'') AS Avg_Amount,
ROUND(SUM(Amount)*100.0/(SELECT SUM(Amount) FROM bank_data),2) AS PCT_of_Total
FROM bank_data
GROUP BY Bank_Name
ORDER BY SUM(Amount) DESC;


