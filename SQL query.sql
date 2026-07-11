CREATE DATABASE securedrive_general_insurance

ALTER DATABASE securedrive_general_insurance
SET datestyle = 'ISO, MDY';


create table customer 

(
customer_id numeric primary key,
age numeric,
gender varchar(50),
city varchar(50),
state varchar(50),
occupation varchar(50),
annual_income numeric,
customer_since date

);

select * from customer


create table policies

( policy_id numeric primary key,
customer_id numeric,
policy_type varchar(50),
add_on_cover varchar(50),
vehicle_model varchar(50),
vehicle_make varchar(50),
vehicle_type varchar(50),
fuel_type varchar(50),
vehicle_year numeric,
idv numeric,
premium_amount numeric
);

select * from policies

create table claim

( claim_id numeric primary key,
policy_id numeric,
claim_date date,
claim_type varchar(50),
claim_amount numeric,
amount_approved numeric,
claim_status varchar(50),
settlement_days numeric,
garage_type varchar(50)

);

select * from claim

-- Q 1. How many customers, policies and claims does SecureDrive currently have?

-- First approach


SELECT COUNT(DISTINCT p.customer_id) AS customer, COUNT(DISTINCT p.policy_id) AS policy, 
COUNT( DISTINCT c.claim_id) AS claim
FROM policies as p
JOIN claim as c
ON c.policy_id = p.policy_id

-- error in query , excludes unmatched records because of the INNER JOIN.

-- Second approach

SELECT 
(SELECT COUNT (*) FROM customer) as total_customers,
(SELECT COUNT (*) FROM policies) as total_policies,
(SELECT COUNT (*) FROM claim) as total_claims;

-- Returns the exact record count from each table without joining them.

-- Q 2. What is the total premium collected by the company ?

SELECT SUM(premium_amount) AS total_premium
FROM policies;

-- Q 3. What is the total claim amount requested and the total amount approved ?

SELECT SUM(claim_amount) AS total_claim_amount_requested, 
SUM(amount_approved) AS total_claim_amount_approved    
FROM claim;

-- Q 4. What is the average annual income of customers by occupation?

-- First approach

SELECT occupation, AVG(annual_income) AS average_income
FROM customer
GROUP BY occupation
ORDER BY average_income DESC;

-- Displays the average annual income with full decimal value.

-- Second approach

SELECT occupation, ROUND(AVG(annual_income), 2) AS average_income
FROM customer
GROUP BY occupation
ORDER BY average_income DESC;

-- Rounds the average annual income to two decimal places.

-- Q 5. Which are the Top 10 highest claim amounts ?

SELECT claim_id, claim_amount
FROM claim
ORDER by claim_amount DESC
LIMIT 10;

-- Q 6. Which cities have generated the highest total claim amount?

SELECT c.city as city, SUM(c2.amount_approved) as total_claim_amount 
FROM customer as c
JOIN policies as p ON c.customer_id = p.customer_id
JOIN claim as c2 ON p.policy_id = c2.policy_id
GROUP BY c.city
ORDER BY total_claim_amount DESC;

-- Q 7. Which policy type generates the highest premium revenue ?

SELECT policy_type, SUM(premium_amount) AS total_premium
FROM policies
GROUP BY policy_type
ORDER BY total_premium DESC;

-- Q 8. What is the average premium collected for each vehicle type ?

SELECT vehicle_type, ROUND (AVG(premium_amount), 2 ) AS average_premium
FROM policies
GROUP BY vehicle_type
ORDER BY average_premium DESC;

-- Q 9. Which claim type occurs most frequently?

SELECT claim_type, COUNT (claim_type) AS frequency
FROM claim
GROUP BY claim_type
ORDER BY frequency DESC; 

-- Q 10. Which fuel type has the highest average approved claim amount?

SELECT p.fuel_type,
ROUND (AVG (c.amount_approved) , 2) AS avg_amount_approved
FROM claim AS c
JOIN policies AS p
ON p.policy_id = c.policy_id
WHERE c.claim_status = 'Approved'
GROUP BY p.fuel_type
ORDER BY avg_amount_approved DESC;

-- Q 11. Rank the Top 10 customers based on total premium paid.

-- First approch

WITH ranked AS (

SELECT c.customer_id, p.premium_amount,
RANK() OVER (PARTITION BY c.customer_id ORDER BY p.premium_amount DESC ) AS "rank"
FROM customer AS c
JOIN policies AS p
ON c.customer_id = p.customer_id
)

SELECT * 
FROM ranked
WHERE rank = 1
LIMIT 10;

--  ERROR = only shows premium paid for a single policy , does not combine all policy premium paid by the single customer

SELECT c.customer_id, SUM(p.premium_amount) AS total_premium,
RANK() OVER (ORDER BY SUM(p.premium_amount) DESC) AS customer_rank
FROM customer c
JOIN policies p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY customer_rank
LIMIT 10;

-- Combines the premium amounts from all policies and ranks customers based on their total premium paid.

-- Q 12. Which occupations generate the highest premium revenue while having the lowest claim ratio ?



SELECT c1.occupation,
SUM (p.premium_amount) as total_premium,
ROUND(SUM(c.amount_approved) / NULLIF(SUM(p.premium_amount) , 0) * 100 , 2) AS claim_ratio 
FROM policies AS p
JOIN claim AS c
ON c.policy_id = p.policy_id
JOIN customer AS c1
ON c1.customer_id = p.customer_id
GROUP BY c1.occupation
ORDER BY claim_ratio ASC,  total_premium DESC;

-- Q 13. Find customers who own more than one insurance policy ?

-- First approach

WITH total_policies AS (
SELECT c.customer_id, count(p.policy_id) as policy_count
FROM customer AS c
JOIN policies AS p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id)

SELECT * 
FROM total_policies 
WHERE policy_count > 1
ORDER BY policy_count DESC

-- Second approach

SELECT customer_id, COUNT(policy_id) AS policy_count
FROM policies
GROUP BY customer_id
HAVING COUNT(policy_id) > 1
ORDER BY policy_count DESC;


-- Q 14. Calculate the Claim Ratio for every vehicle model.

SELECT p.vehicle_model,
ROUND(SUM(c.amount_approved) / SUM(p.premium_amount) * 100 , 2) AS claim_ratio 
FROM policies AS p
JOIN claim AS c
ON p.policy_id = c.policy_id
GROUP BY p.vehicle_model
ORDER BY claim_ratio ASC;

-- Q 15 Rank customers within each state based on the total premium they have paid ?

SELECT c.state, c.customer_id,
SUM(p.premium_amount) AS total_premium,
RANK() OVER (PARTITION BY c.state ORDER BY SUM(p.premium_amount) DESC) AS state_rank
FROM customer c
JOIN policies p
ON c.customer_id = p.customer_id
GROUP BY c.state, c.customer_id
ORDER BY c.state, state_rank;

-- Q 16 Categorize customers based on the total premium they have paid ?

SELECT c.customer_id, SUM(p.premium_amount) AS total_premium,
CASE
WHEN SUM(p.premium_amount) >= 100000 THEN 'Platinum'
WHEN SUM(p.premium_amount) >= 70000 THEN 'Gold'
WHEN SUM(p.premium_amount) >= 40000 THEN 'Silver'
ELSE 'Bronze'
END AS customer_category
FROM customer c
JOIN policies p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_premium DESC;


-- Q 17. Executive Business Report (Master Query)

WITH executive_business_report AS (

SELECT c.customer_id, c.city, c.occupation, p.policy_type, p.vehicle_model,
SUM(p.premium_amount) AS total_premium_paid,SUM(c2.claim_amount) AS total_claim_amount,
SUM(c2.amount_approved) AS total_approved_amount,
COUNT(c2.claim_id) AS number_of_claims, ROUND (AVG(c2.settlement_days), 0 ) AS avg_settlement_days
FROM customer AS c
JOIN policies AS p
ON c.customer_id = p.customer_id
JOIN claim AS c2
ON p.policy_id = c2.policy_id
GROUP BY c.customer_id, c.city, c.occupation, p.policy_type, p.vehicle_model)

SELECT * 
FROM executive_business_report
ORDER BY total_premium_paid DESC;


-- View 1 – Customer Summary

-- Purpose: Customer profile , Policies per customer, Premium paid

CREATE VIEW vw_customer_summary AS
SELECT c.customer_id, c.city, c.state, c.occupation,
COUNT(p.policy_id) AS total_policies,
SUM(p.premium_amount) AS total_premium
FROM customer c
JOIN policies p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.city, c.state, c.occupation;

SELECT * FROM vw_customer_summary

-- View 2 – Policy Performance

-- Purpose: Policy analysis, Premium revenue

CREATE VIEW vw_policy_performance AS
SELECT policy_type,
COUNT(policy_id) AS total_policies,
SUM(premium_amount) AS premium_revenue,
AVG(premium_amount) AS average_premium
FROM policies
GROUP BY policy_type;

SELECT * FROM vw_policy_performance

-- View 3 – Claim Analysis

-- Purpose: Claim dashboard

CREATE VIEW vw_claim_analysis AS
SELECT claim_status,
COUNT(claim_id) AS total_claims,
SUM(claim_amount) AS claim_requested,
SUM(amount_approved) AS claim_paid
FROM claim
GROUP BY claim_status;

SELECT * FROM vw_claim_analysis

-- View 4 – Vehicle Analysis

-- Purpose: Vehicle performance

CREATE VIEW vw_vehicle_analysis AS
SELECT p.vehicle_model, p.vehicle_type,
SUM(c.amount_approved) AS total_claim_paid,
SUM(p.premium_amount) AS premium_collected
FROM policies p
JOIN claim c
ON p.policy_id = c.policy_id
GROUP BY p.vehicle_model, p.vehicle_type;

SELECT * FROM vw_vehicle_analysis

