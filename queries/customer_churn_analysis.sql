CREATE DATABASE Customer_Churn_Analysis

USE Customer_Churn_Analysis

SELECT * FROM dbo.churn

-- Business problems

-- 1: How big is the churn problem?

SELECT 
	COUNT(*) AS total_customers,
	SUM(churnflag) AS churned_customers,
	ROUND(100.0 * SUM(churnflag) / COUNT(*), 1) AS churn_rate_pct,
	ROUND(SUM(monthlycharges),0) AS total_mrr,
	ROUND(SUM(CASE WHEN churnflag = 1 THEN monthlycharges ELSE 0 END), 0) AS mrr_lost,
	ROUND(100.0 * SUM(CASE WHEN churnflag = 1 THEN monthlycharges ELSE 0 END)
	/ SUM(monthlycharges), 1) AS mrr_lost_pct
FROM dbo.churn;

--2: Which contract types churn most?

SELECT
	contract,
	COUNT(*) AS total_customers,
	SUM(churnflag) AS churned,
	ROUND(100.0 * SUM(churnflag) / COUNT(*), 1) AS churn_rate_pct
FROM dbo.churn
GROUP BY contract
ORDER BY churn_rate_pct DESC

--3: When in the lifecycle do customers leave?

SELECT
	tenuregroup,
	COUNT(*) AS total_customers,
	SUM(churnflag) AS churned,
	ROUND(100.0 * SUM(churnflag) / COUNT(*), 1) AS churn_rate_pct
FROM dbo.churn
GROUP BY tenuregroup, tenureorder
ORDER BY tenureorder

--4: Does the service mix matter? (internet type and tech support)

SELECT
	internetservice,
	techsupport,
	COUNT(*) AS total_customers,
	SUM(churnflag) AS churned,
	ROUND(100.0 * SUM(churnflag) / COUNT(*), 1) AS churn_rate_pct
FROM dbo.churn
WHERE internetservice != 'No'
GROUP BY internetservice, techsupport
ORDER BY churn_rate_pct DESC

--5: Payment method and churn

SELECT
	paymentmethod,
	COUNT(*) AS total_customers,
	SUM(churnflag) AS churned,
	ROUND(100.0 * SUM(churnflag) / COUNT(*), 1) AS churn_rate_pct
FROM dbo.churn
GROUP BY paymentmethod
ORDER BY churn_rate_pct DESC

--6: Which segment should the retention team target first?

SELECT COUNT(*) AS customers, SUM(churnflag) AS churned,
ROUND(100.0 * SUM(churnflag) / COUNT(*), 1) AS churn_rate_pct,
ROUND(SUM(CASE WHEN churnflag = 1 THEN monthlycharges ELSE 0 END), 0) AS mrr_lost
FROM dbo.churn
WHERE contract = 'Month-to-month'
AND internetservice = 'Fiber optic'
AND techsupport = 'No';

--7: What share of all churn comes from each contract type?

WITH totals AS (SELECT SUM(churnflag) AS all_churn FROM dbo.churn)
SELECT contract, SUM(churnflag) AS churned,
ROUND(100.0 * SUM(churnflag) / (SELECT all_churn FROM totals), 1) AS share_of_all_churn
FROM dbo.churn
GROUP BY contract
ORDER BY churned DESC;

