CREATE DATABASE customer_churn;
USE customer_churn;

CREATE TABLE raw_data (
    customerID VARCHAR(50),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(3),
    Dependents VARCHAR(3),
    tenure INT,
    PhoneService VARCHAR(15),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(15),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(3),
    PaymentMethod VARCHAR(30),
    MonthlyCharges DECIMAL(10, 2),
    TotalCharges VARCHAR(20),
    Churn VARCHAR(3)
);
SHOW TABLES;


CREATE TABLE cleaned_data (
    customerID VARCHAR(50),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(3),
    Dependents VARCHAR(3),
    tenure INT,
    PhoneService VARCHAR(15),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(15),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(3),
    PaymentMethod VARCHAR(30),
    MonthlyCharges DECIMAL(10, 2),
    TotalCharges DECIMAL(10, 2),
    Churn INT
);
SHOW TABLES;


CREATE TABLE model_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(50),
    accuracy DECIMAL(5, 4),
    precision_score DECIMAL(5, 4),
    recall DECIMAL(5, 4),
    f1_score DECIMAL(5, 4),
    roc_auc DECIMAL(5, 4),
    run_date DATETIME
);
SHOW TABLES;

CREATE TABLE customer_predictions (
    prediction_id INT AUTO_INCREMENT PRIMARY KEY,
    customerID VARCHAR(50),
    actual_churn INT,
    predicted_churn INT,
    churn_probability DECIMAL(5,4),
    model_name VARCHAR(50),
    prediction_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
SHOW TABLES;


SELECT COUNT(*) as total_customers FROM raw_data;

SELECT Churn, COUNT(*) as count 
FROM raw_data 
GROUP BY Churn;

SELECT Churn, AVG(MonthlyCharges) as avg_charges 
FROM raw_data 
GROUP BY Churn;

SELECT COUNT(*) as missing_count 
FROM raw_data 
WHERE TotalCharges = ' ' OR TotalCharges IS NULL;

SELECT tenure, COUNT(*) as count 
FROM raw_data 
GROUP BY tenure 
ORDER BY tenure;

SELECT Contract, COUNT(*) as count 
FROM raw_data 
GROUP BY Contract;

INSERT INTO cleaned_data
SELECT
    customerID, gender, SeniorCitizen, Partner, Dependents, tenure,
    PhoneService, MultipleLines, InternetService, OnlineSecurity,
    OnlineBackup, DeviceProtection, TechSupport, StreamingTV,
    StreamingMovies, Contract, PaperlessBilling, PaymentMethod,
    MonthlyCharges,

    CAST(NULLIF(TRIM(TotalCharges), '') AS DECIMAL(10,2)) AS TotalCharges,

    CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS Churn

FROM raw_data;

SELECT * FROM cleaned_data LIMIT 5;
SELECT TotalCharges FROM cleaned_data LIMIT 5;

DESCRIBE cleaned_data;

SELECT Contract, 
       COUNT(*) as total, 
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
       ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate
FROM raw_data 
GROUP BY Contract;

SELECT InternetService, 
       COUNT(*) as total, 
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
       ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate
FROM raw_data 
GROUP BY InternetService;

SELECT Contract, 
       AVG(MonthlyCharges) as avg_charges,
       AVG(TotalCharges) as avg_total_charges
FROM raw_data 
GROUP BY Contract;


INSERT INTO model_metrics (model_name, accuracy, precision_score, recall, f1_score, roc_auc, run_date)
VALUES (
    'Random Forest',
    0.7771,
    0.7500,
    0.7200,
    0.7350,
    0.7429,
    NOW()
);

SELECT * FROM model_metrics;


INSERT INTO model_metrics (model_name, accuracy, precision_score, recall, f1_score, roc_auc, run_date)
VALUES (
    'XGBoost',
    0.7600,
    0.7400,
    0.7100,
    0.7250,
    0.7300,
    NOW()
);

SELECT model_name, accuracy, roc_auc, run_date 
FROM model_metrics 
ORDER BY run_date DESC;

SELECT model_name, accuracy, roc_auc 
FROM model_metrics 
ORDER BY accuracy DESC 
LIMIT 1;

SELECT 
    model_name,
    ROUND(accuracy * 100, 2) as accuracy_percent,
    ROUND(roc_auc * 100, 2) as roc_auc_percent,
    run_date
FROM model_metrics 
ORDER BY accuracy DESC;



