/* ============================================================
   BANKING DATA ANALYTICS PROJECT
   Domain: Banking & Financial Services
   Database: sbi_banking_db
   Tools: MySQL 8.0, MySQL Workbench 8.0
   Language: SQL
   Dataset: Simulated SBI-Inspired Banking Dataset
   Total Records: 16,380
   Total Tables: 6
   Author: Data Analytics Portfolio Project
   Year: 2026
   ============================================================ */
-- ============================================================
-- DATABASE SETUP
-- ============================================================

USE sbi_banking_db;

-- ============================================================
-- 1. CUSTOMER ANALYSIS
-- ============================================================
-- Q1. Customer count by city

SELECT
    city,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- Q2. Gender-wise customer distribution and percentage contribution

SELECT
    gender,
    COUNT(customer_id) AS total_customers,
    ROUND(
        COUNT(customer_id) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS percentage_contribution
FROM customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Q3. Customer distribution by age group

SELECT
    CASE
        WHEN age < 25 THEN 'Young'
        WHEN age BETWEEN 25 AND 40 THEN 'Adult'
        WHEN age BETWEEN 41 AND 60 THEN 'Middle-aged'
        ELSE 'Senior'
    END AS age_group,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY age_group
ORDER BY total_customers DESC;

-- Q4. Year-wise customer joining trend

SELECT
    YEAR(joining_date) AS joining_year,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY YEAR(joining_date)
ORDER BY joining_year;

-- Q5. State-wise customer distribution and percentage contribution

SELECT
    state,
    COUNT(customer_id) AS total_customers,
    ROUND(
        COUNT(customer_id) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS percentage_contribution
FROM customers
GROUP BY state
ORDER BY total_customers DESC;

-- Q6. Average customer age by city

SELECT
    city,
    ROUND(AVG(age), 2) AS average_age,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city
ORDER BY average_age DESC;

-- Q7. Customer distribution by gender and city

SELECT
    city,
    gender,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city, gender
ORDER BY city, total_customers DESC;

-- Q8. Youngest and oldest customer age by state

SELECT
    state,
    MIN(age) AS youngest_customer_age,
    MAX(age) AS oldest_customer_age
FROM customers
GROUP BY state
ORDER BY state;

-- Q9. Quarterly customer joining analysis

SELECT
    YEAR(joining_date) AS joining_year,
    QUARTER(joining_date) AS joining_quarter,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY
    YEAR(joining_date),
    QUARTER(joining_date)
ORDER BY
    joining_year,
    joining_quarter;
    
    -- Q10. Top 5 cities by customer acquisition

SELECT
    city,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC
LIMIT 5;

-- ============================================================
-- 2. ACCOUNT ANALYSIS
-- ============================================================
-- Q1. Number of accounts by account type

SELECT
    account_type,
    COUNT(account_id) AS total_accounts
FROM accounts
GROUP BY account_type
ORDER BY total_accounts DESC;
-- Q2. Total account balance by account type

SELECT
    account_type,
    ROUND(SUM(balance), 2) AS total_balance
FROM accounts
GROUP BY account_type
ORDER BY total_balance DESC;

-- Q3. Average account balance by account type

SELECT
    account_type,
    ROUND(AVG(balance), 2) AS average_balance
FROM accounts
GROUP BY account_type
ORDER BY average_balance DESC;

-- Q4. Highest and lowest account balance by account type

SELECT
    account_type,
    MAX(balance) AS highest_balance,
    MIN(balance) AS lowest_balance
FROM accounts
GROUP BY account_type
ORDER BY account_type;

-- Q5. Number of accounts by branch

SELECT
    branch_id,
    COUNT(account_id) AS total_accounts
FROM accounts
GROUP BY branch_id
ORDER BY total_accounts DESC;

-- Q6. Total account balance by branch

SELECT
    branch_id,
    ROUND(SUM(balance), 2) AS total_branch_balance
FROM accounts
GROUP BY branch_id
ORDER BY total_branch_balance DESC;

-- Q7. Year-wise account opening trend

SELECT
    YEAR(opening_date) AS opening_year,
    COUNT(account_id) AS total_accounts
FROM accounts
GROUP BY YEAR(opening_date)
ORDER BY opening_year;

-- Q8. Percentage contribution of each account type

SELECT
    account_type,
    COUNT(account_id) AS total_accounts,
    ROUND(
        COUNT(account_id) * 100.0 /
        (SELECT COUNT(*) FROM accounts),
        2
    ) AS percentage_contribution
FROM accounts
GROUP BY account_type
ORDER BY percentage_contribution DESC;

-- Q9. Identify low-balance accounts below 10000

SELECT
    account_id,
    customer_id,
    account_type,
    balance
FROM accounts
WHERE balance < 10000
ORDER BY balance ASC;

-- Q10. Top 5 customers by combined total account balance

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(a.balance), 2) AS total_account_balance
FROM customers AS c
JOIN accounts AS a
    ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_account_balance DESC
LIMIT 5;

-- ============================================================
-- 3. TRANSACTION ANALYSIS
-- ============================================================

-- Q1. Number of transactions by transaction type

SELECT
    transaction_type,
    COUNT(transaction_id) AS total_transactions
FROM transactions
GROUP BY transaction_type
ORDER BY total_transactions DESC;

-- Q2. Total transaction amount by transaction type

SELECT
    transaction_type,
    ROUND(SUM(amount), 2) AS total_transaction_amount
FROM transactions
GROUP BY transaction_type
ORDER BY total_transaction_amount DESC;

-- Q3. Average transaction amount by transaction type

SELECT
    transaction_type,
    ROUND(AVG(amount), 2) AS average_transaction_amount
FROM transactions
GROUP BY transaction_type
ORDER BY average_transaction_amount DESC;

#Q4. Highest and lowest transaction amount by type

SELECT
    transaction_type,
    MAX(amount) AS highest_transaction,
    MIN(amount) AS lowest_transaction
FROM transactions
GROUP BY transaction_type
ORDER BY transaction_type;

#Q5. Number of transactions by payment mode

SELECT
    payment_mode,
    COUNT(transaction_id) AS total_transactions
FROM transactions
GROUP BY payment_mode
ORDER BY total_transactions DESC;

-- Q6. Total transaction amount by payment mode

SELECT
    payment_mode,
    ROUND(SUM(amount), 2) AS total_transaction_amount
FROM transactions
GROUP BY payment_mode
ORDER BY total_transaction_amount DESC;

-- Q7. Average transaction amount by payment mode

SELECT
    payment_mode,
    ROUND(AVG(amount), 2) AS average_transaction_amount
FROM transactions
GROUP BY payment_mode
ORDER BY average_transaction_amount DESC;

-- Q8. Highest transaction amount by payment mode

SELECT
    payment_mode,
    MAX(amount) AS highest_transaction_amount
FROM transactions
GROUP BY payment_mode
ORDER BY highest_transaction_amount DESC;

-- Q10. Total deposits and withdrawals per account

SELECT
    account_id,
    ROUND(
        SUM(CASE
            WHEN transaction_type = 'Deposit' THEN amount
            ELSE 0
        END), 2
    ) AS total_deposit,
    ROUND(
        SUM(CASE
            WHEN transaction_type = 'Withdrawal' THEN amount
            ELSE 0
        END), 2
    ) AS total_withdrawal
FROM transactions
GROUP BY account_id
ORDER BY account_id;

-- ============================================================
-- 4. LOAN ANALYSIS
-- ============================================================

-- Q1. Number of loans by loan type

SELECT
    loan_type,
    COUNT(loan_id) AS total_loans
FROM loans
GROUP BY loan_type
ORDER BY total_loans DESC;

-- Q2. Total loan amount by loan type

SELECT
    loan_type,
    ROUND(SUM(loan_amount), 2) AS total_loan_amount
FROM loans
GROUP BY loan_type
ORDER BY total_loan_amount DESC;

-- Q3. Average loan amount by loan type

SELECT
    loan_type,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY loan_type
ORDER BY average_loan_amount DESC;

-- Q4. Highest and lowest loan amount by loan type

SELECT
    loan_type,
    MAX(loan_amount) AS highest_loan_amount,
    MIN(loan_amount) AS lowest_loan_amount
FROM loans
GROUP BY loan_type
ORDER BY loan_type;

-- Q5. Number of loans by loan status

SELECT
    loan_status,
    COUNT(loan_id) AS total_loans
FROM loans
GROUP BY loan_status
ORDER BY total_loans DESC;

-- Q6. Average interest rate by loan type

SELECT
    loan_type,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate
FROM loans
GROUP BY loan_type
ORDER BY average_interest_rate DESC;

-- Q7. Total loan amount by loan status

SELECT
    loan_status,
    ROUND(SUM(loan_amount), 2) AS total_loan_amount
FROM loans
GROUP BY loan_status
ORDER BY total_loan_amount DESC;

-- Q8. Loan distribution by loan type and status

SELECT
    loan_type,
    loan_status,
    COUNT(loan_id) AS total_loans
FROM loans
GROUP BY loan_type, loan_status
ORDER BY loan_type, total_loans DESC;

-- Q9. Identify loans above 10 lakh

SELECT
    loan_id,
    customer_id,
    loan_type,
    loan_amount,
    loan_status
FROM loans
WHERE loan_amount > 1000000
ORDER BY loan_amount DESC;

-- ============================================================
-- 5. LOAN PAYMENT ANALYSIS
-- ============================================================

-- Q1. Number of loan payments by status

SELECT
    status,
    COUNT(payment_id) AS total_payments
FROM loan_payments
GROUP BY status
ORDER BY total_payments DESC;

-- Q2. Total loan payment amount by status

SELECT
    status,
    ROUND(SUM(payment_amount), 2) AS total_payment_amount
FROM loan_payments
GROUP BY status
ORDER BY total_payment_amount DESC;

-- Q3. Average loan payment amount by status

SELECT
    status,
    ROUND(AVG(payment_amount), 2) AS average_payment_amount
FROM loan_payments
GROUP BY status
ORDER BY average_payment_amount DESC;

-- Q4. Highest and lowest loan payment amount

SELECT
    MAX(payment_amount) AS highest_payment,
    MIN(payment_amount) AS lowest_payment
FROM loan_payments;

-- Q5. Total payment amount per loan

SELECT
    loan_id,
    COUNT(payment_id) AS total_payment_records,
    ROUND(SUM(payment_amount), 2) AS total_payment_amount
FROM loan_payments
GROUP BY loan_id
ORDER BY total_payment_amount DESC;

-- Q6. Total payment amount by loan and status

SELECT
    loan_id,
    status,
    COUNT(payment_id) AS total_payment_records,
    ROUND(SUM(payment_amount), 2) AS total_payment_amount
FROM loan_payments
GROUP BY loan_id, status
ORDER BY loan_id, total_payment_amount DESC;

-- Q7. Number of late payments per loan

SELECT
    loan_id,
    COUNT(payment_id) AS total_late_payments
FROM loan_payments
WHERE status = 'Late'
GROUP BY loan_id
ORDER BY total_late_payments DESC;

-- Q8. Total late payment amount per loan

SELECT
    loan_id,
    COUNT(payment_id) AS total_late_payments,
    ROUND(SUM(payment_amount), 2) AS total_late_payment_amount
FROM loan_payments
WHERE status = 'Late'
GROUP BY loan_id
ORDER BY total_late_payment_amount DESC;

-- Q9. Count payments above 50000 per loan

SELECT
    loan_id,
    COUNT(payment_id) AS total_payments_above_50000
FROM loan_payments
WHERE payment_amount > 50000
GROUP BY loan_id
ORDER BY total_payments_above_50000 DESC;

-- Q10. Top 5 loans by total payment amount

SELECT
    loan_id,
    COUNT(payment_id) AS total_payment_records,
    ROUND(SUM(payment_amount), 2) AS total_payment_amount
FROM loan_payments
GROUP BY loan_id
ORDER BY total_payment_amount DESC
LIMIT 5;
-- ============================================================
-- 6. JOIN ANALYSIS
-- ============================================================

-- Q1. Number of loans per customer

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(l.loan_id) AS total_loans
FROM customers AS c
JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_loans DESC;

-- Q2. Total loan amount per customer

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(l.loan_amount), 2) AS total_loan_amount
FROM customers AS c
JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_loan_amount DESC;

-- Q3. Total loan payment records per customer

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(lp.payment_id) AS total_payment_records
FROM customers AS c
JOIN loans AS l
    ON c.customer_id = l.customer_id
JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_payment_records DESC;

-- Q4. Total transaction amount per customer

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(t.amount), 2) AS total_transaction_amount
FROM customers AS c
JOIN accounts AS a
    ON c.customer_id = a.customer_id
JOIN transactions AS t
    ON a.account_id = t.account_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_transaction_amount DESC;

-- Q5. Total accounts and combined balance per customer

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(a.account_id) AS total_accounts,
    ROUND(SUM(a.balance), 2) AS total_account_balance
FROM customers AS c
JOIN accounts AS a
    ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_account_balance DESC;

-- Q6. Total transactions and average amount per customer

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(AVG(t.amount), 2) AS average_transaction_amount
FROM customers AS c
JOIN accounts AS a
    ON c.customer_id = a.customer_id
JOIN transactions AS t
    ON a.account_id = t.account_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_transactions DESC;

-- Q7. Highest transaction amount per customer

SELECT
    c.customer_id,
    c.customer_name,
    MAX(t.amount) AS highest_transaction_amount
FROM customers AS c
JOIN accounts AS a
    ON c.customer_id = a.customer_id
JOIN transactions AS t
    ON a.account_id = t.account_id
GROUP BY c.customer_id, c.customer_name
ORDER BY highest_transaction_amount DESC;

-- Q8. Total deposits and withdrawals per customer

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(CASE
            WHEN t.transaction_type = 'Deposit' THEN t.amount
            ELSE 0
        END), 2
    ) AS total_deposit,
    ROUND(
        SUM(CASE
            WHEN t.transaction_type = 'Withdrawal' THEN t.amount
            ELSE 0
        END), 2
    ) AS total_withdrawal
FROM customers AS c
JOIN accounts AS a
    ON c.customer_id = a.customer_id
JOIN transactions AS t
    ON a.account_id = t.account_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_deposit DESC;

-- Q9. Transaction count by payment mode per customer

SELECT
    c.customer_id,
    c.customer_name,
    t.payment_mode,
    COUNT(t.transaction_id) AS total_transactions
FROM customers AS c
JOIN accounts AS a
    ON c.customer_id = a.customer_id
JOIN transactions AS t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.customer_name,
    t.payment_mode
ORDER BY
    c.customer_id,
    total_transactions DESC;
    
    -- Q10. Total loan payments per customer

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(lp.payment_id) AS total_payment_records,
    ROUND(SUM(lp.payment_amount), 2) AS total_loan_payments
FROM customers AS c
JOIN loans AS l
    ON c.customer_id = l.customer_id
JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_loan_payments DESC;

-- ============================================================
-- 7. WINDOW FUNCTION ANALYSIS
-- ============================================================

-- Q1. Rank accounts by balance using ROW_NUMBER()

SELECT
    account_id,
    customer_id,
    balance,
    ROW_NUMBER() OVER(
        ORDER BY balance DESC
    ) AS row_num
FROM accounts
ORDER BY row_num;

-- Q2. Compare ROW_NUMBER, RANK and DENSE_RANK

SELECT
    account_id,
    customer_id,
    balance,

    ROW_NUMBER() OVER(
        ORDER BY balance DESC
    ) AS row_num,

    RANK() OVER(
        ORDER BY balance DESC
    ) AS account_rank,

    DENSE_RANK() OVER(
        ORDER BY balance DESC
    ) AS dense_rank_num

FROM accounts
ORDER BY balance DESC;

-- Q3. Find top 3 distinct account balances

WITH Account_Ranking AS (
    SELECT
        account_id,
        customer_id,
        balance,
        DENSE_RANK() OVER(
            ORDER BY balance DESC
        ) AS balance_rank
    FROM accounts
)

SELECT
    account_id,
    customer_id,
    balance,
    balance_rank
FROM Account_Ranking
WHERE balance_rank <= 3
ORDER BY balance_rank;

-- Q4. Top 5 customers by combined account balance

WITH Customer_Balance AS (
    SELECT
        c.customer_id,
        c.customer_name,
        ROUND(SUM(a.balance), 2) AS total_account_balance
    FROM customers AS c
    JOIN accounts AS a
        ON c.customer_id = a.customer_id
    GROUP BY c.customer_id, c.customer_name
),

Balance_Ranking AS (
    SELECT
        customer_id,
        customer_name,
        total_account_balance,
        RANK() OVER(
            ORDER BY total_account_balance DESC
        ) AS customer_rank
    FROM Customer_Balance
)

SELECT
    customer_id,
    customer_name,
    total_account_balance,
    customer_rank
FROM Balance_Ranking
WHERE customer_rank <= 5
ORDER BY customer_rank;

-- Q5. Find second-highest distinct account balance

WITH Account_Ranking AS (
    SELECT
        account_id,
        customer_id,
        balance,
        DENSE_RANK() OVER(
            ORDER BY balance DESC
        ) AS balance_rank
    FROM accounts
)

SELECT
    account_id,
    customer_id,
    balance
FROM Account_Ranking
WHERE balance_rank = 2;
use sbi_banking_db;

-- Q6. Previous transaction amount per account using LAG

SELECT
    account_id,
    transaction_id,
    transaction_date,
    amount,

    LAG(amount) OVER(
        PARTITION BY account_id
        ORDER BY transaction_date, transaction_id
    ) AS previous_transaction_amount

FROM transactions
ORDER BY account_id, transaction_date, transaction_id;

-- Q7. Next transaction amount per account using LEAD

SELECT
    account_id,
    transaction_id,
    transaction_date,
    amount,

    LEAD(amount) OVER(
        PARTITION BY account_id
        ORDER BY transaction_date, transaction_id
    ) AS next_transaction_amount

FROM transactions
ORDER BY account_id, transaction_date, transaction_id;

-- Q8. Running total of transactions per account

SELECT
    account_id,
    transaction_id,
    transaction_date,
    amount,

    SUM(amount) OVER(
        PARTITION BY account_id
        ORDER BY transaction_date, transaction_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total

FROM transactions
ORDER BY account_id, transaction_date, transaction_id;

-- Q9. Monthly transaction trend and month-over-month growth

WITH Monthly_Transactions AS (
    SELECT
        YEAR(transaction_date) AS transaction_year,
        MONTH(transaction_date) AS transaction_month,
        ROUND(SUM(amount), 2) AS monthly_amount
    FROM transactions
    GROUP BY
        YEAR(transaction_date),
        MONTH(transaction_date)
),

Monthly_Comparison AS (
    SELECT
        transaction_year,
        transaction_month,
        monthly_amount,

        LAG(monthly_amount) OVER(
            ORDER BY transaction_year, transaction_month
        ) AS previous_month_amount

    FROM Monthly_Transactions
)

SELECT
    transaction_year,
    transaction_month,
    monthly_amount,
    previous_month_amount,

    ROUND(
        (monthly_amount - previous_month_amount) * 100.0 /
        NULLIF(previous_month_amount, 0),
        2
    ) AS growth_percentage

FROM Monthly_Comparison
ORDER BY transaction_year, transaction_month;

-- Q10. Top 3 customers by total transaction amount

WITH Customer_Transactions AS (
    SELECT
        c.customer_id,
        c.customer_name,
        ROUND(SUM(t.amount), 2) AS total_transaction_amount
    FROM customers AS c
    JOIN accounts AS a
        ON c.customer_id = a.customer_id
    JOIN transactions AS t
        ON a.account_id = t.account_id
    GROUP BY c.customer_id, c.customer_name
),

Transaction_Ranking AS (
    SELECT
        customer_id,
        customer_name,
        total_transaction_amount,

        DENSE_RANK() OVER(
            ORDER BY total_transaction_amount DESC
        ) AS transaction_rank

    FROM Customer_Transactions
)

SELECT
    customer_id,
    customer_name,
    total_transaction_amount,
    transaction_rank
FROM Transaction_Ranking
WHERE transaction_rank <= 3
ORDER BY transaction_rank;

-- ============================================================
-- 8. ADVANCED BANKING BUSINESS ANALYSIS
-- ============================================================

-- Q1. Customers whose total deposits exceed total withdrawals

WITH Customer_Transactions AS (
    SELECT
        c.customer_id,
        c.customer_name,

        ROUND(
            SUM(CASE
                WHEN t.transaction_type = 'Deposit'
                THEN t.amount ELSE 0
            END), 2
        ) AS total_deposit,

        ROUND(
            SUM(CASE
                WHEN t.transaction_type = 'Withdrawal'
                THEN t.amount ELSE 0
            END), 2
        ) AS total_withdrawal

    FROM customers AS c
    JOIN accounts AS a
        ON c.customer_id = a.customer_id
    JOIN transactions AS t
        ON a.account_id = t.account_id

    GROUP BY c.customer_id, c.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_deposit,
    total_withdrawal,

    ROUND(
        total_deposit - total_withdrawal, 2
    ) AS net_transaction_amount

FROM Customer_Transactions
WHERE total_deposit > total_withdrawal;

-- Q2. Top 10 customers by total transaction amount

WITH Customer_Total_Transactions AS (
    SELECT
        c.customer_id,
        c.customer_name,
        ROUND(SUM(t.amount), 2) AS total_transaction_amount

    FROM customers AS c
    JOIN accounts AS a
        ON c.customer_id = a.customer_id
    JOIN transactions AS t
        ON a.account_id = t.account_id

    GROUP BY c.customer_id, c.customer_name
),

Customer_Ranking AS (
    SELECT
        customer_id,
        customer_name,
        total_transaction_amount,

        DENSE_RANK() OVER(
            ORDER BY total_transaction_amount DESC
        ) AS customer_rank

    FROM Customer_Total_Transactions
)

SELECT
    customer_id,
    customer_name,
    total_transaction_amount,
    customer_rank

FROM Customer_Ranking
WHERE customer_rank <= 10
ORDER BY customer_rank;

-- Q4. Branch-wise total deposits and withdrawals

SELECT
    b.branch_id,
    b.branch_name,
    b.city,

    ROUND(
        SUM(CASE
            WHEN t.transaction_type = 'Deposit'
            THEN t.amount ELSE 0
        END), 2
    ) AS total_deposits,

    ROUND(
        SUM(CASE
            WHEN t.transaction_type = 'Withdrawal'
            THEN t.amount ELSE 0
        END), 2
    ) AS total_withdrawals,

    ROUND(SUM(t.amount), 2) AS total_transaction_amount

FROM branches AS b
JOIN accounts AS a
    ON b.branch_id = a.branch_id
JOIN transactions AS t
    ON a.account_id = t.account_id

GROUP BY
    b.branch_id,
    b.branch_name,
    b.city

ORDER BY total_transaction_amount DESC;

-- Q5. Rank branches by total account balance

WITH Branch_Balance AS (
    SELECT
        b.branch_id,
        b.branch_name,
        b.city,
        ROUND(SUM(a.balance), 2) AS total_branch_balance

    FROM branches AS b
    JOIN accounts AS a
        ON b.branch_id = a.branch_id

    GROUP BY
        b.branch_id,
        b.branch_name,
        b.city
)

SELECT
    branch_id,
    branch_name,
    city,
    total_branch_balance,

    DENSE_RANK() OVER(
        ORDER BY total_branch_balance DESC
    ) AS branch_rank

FROM Branch_Balance
ORDER BY branch_rank;

-- Q6. Loan status distribution by loan type

SELECT
    loan_type,
    COUNT(loan_id) AS total_loans,
    SUM(CASE
        WHEN loan_status = 'Active'
        THEN 1 ELSE 0
    END) AS active_loans,
    SUM(CASE
        WHEN loan_status = 'Closed'
        THEN 1 ELSE 0
    END) AS closed_loans,
    SUM(CASE
        WHEN loan_status = 'Overdue'
        THEN 1 ELSE 0
    END) AS overdue_loans
FROM loans
GROUP BY loan_type
ORDER BY total_loans DESC;

-- Q7. Customers having multiple loans

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.loan_amount), 2) AS total_loan_amount
FROM customers AS c
JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(l.loan_id) > 1
ORDER BY total_loans DESC, total_loan_amount DESC;

-- Q8. Customers having no loan records

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    c.state
FROM customers AS c
LEFT JOIN loans AS l
    ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL
ORDER BY c.customer_id;

-- Q9. Customers having no transactions

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    c.state
FROM customers AS c
LEFT JOIN accounts AS a
    ON c.customer_id = a.customer_id
LEFT JOIN transactions AS t
    ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL
ORDER BY c.customer_id;
 
 -- Q10. Account-wise deposit-to-withdrawal ratio

SELECT
    a.account_id,
    a.customer_id,
    a.account_type,
    ROUND(
        SUM(CASE
            WHEN t.transaction_type = 'Deposit'
            THEN t.amount ELSE 0
        END), 2
    ) AS total_deposits,
    ROUND(
        SUM(CASE
            WHEN t.transaction_type = 'Withdrawal'
            THEN t.amount ELSE 0
        END), 2
    ) AS total_withdrawals,
    ROUND(
        SUM(CASE
            WHEN t.transaction_type = 'Deposit'
            THEN t.amount ELSE 0
        END)
        /
        NULLIF(
            SUM(CASE
                WHEN t.transaction_type = 'Withdrawal'
                THEN t.amount ELSE 0
            END), 0
        ),
        2
    ) AS deposit_withdrawal_ratio
FROM accounts AS a
LEFT JOIN transactions AS t
    ON a.account_id = t.account_id
GROUP BY
    a.account_id,
    a.customer_id,
    a.account_type
ORDER BY deposit_withdrawal_ratio DESC;

-- Q11. Monthly deposit and withdrawal trends

SELECT
    YEAR(transaction_date) AS transaction_year,
    MONTH(transaction_date) AS transaction_month,
    ROUND(
        SUM(CASE
            WHEN transaction_type = 'Deposit'
            THEN amount ELSE 0
        END), 2
    ) AS monthly_deposits,
    ROUND(
        SUM(CASE
            WHEN transaction_type = 'Withdrawal'
            THEN amount ELSE 0
        END), 2
    ) AS monthly_withdrawals,
    ROUND(SUM(amount), 2) AS total_transaction_amount
FROM transactions
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date)
ORDER BY
    transaction_year,
    transaction_month;
    
    -- Q12. Month-over-month deposit growth percentage

WITH Monthly_Deposits AS (
    SELECT
        YEAR(transaction_date) AS transaction_year,
        MONTH(transaction_date) AS transaction_month,
        SUM(amount) AS total_deposits

    FROM transactions

    WHERE transaction_type = 'Deposit'

    GROUP BY
        YEAR(transaction_date),
        MONTH(transaction_date)
),

Deposit_Comparison AS (
    SELECT
        transaction_year,
        transaction_month,
        total_deposits,

        LAG(total_deposits) OVER(
            ORDER BY transaction_year, transaction_month
        ) AS previous_month_deposits

    FROM Monthly_Deposits
)

SELECT
    transaction_year,
    transaction_month,
    ROUND(total_deposits, 2) AS total_deposits,
    ROUND(previous_month_deposits, 2) AS previous_month_deposits,
    ROUND(
        (total_deposits - previous_month_deposits)
        * 100.0 / NULLIF(previous_month_deposits, 0),
        2
    ) AS deposit_growth_percentage
FROM Deposit_Comparison
ORDER BY transaction_year, transaction_month;


-- Q13. Top 5 branches by transaction volume

WITH Branch_Transactions AS (
    SELECT
        b.branch_id,
        b.branch_name,
        b.city,
        COUNT(t.transaction_id) AS total_transactions,
        ROUND(SUM(t.amount), 2) AS total_transaction_amount
    FROM branches AS b
    JOIN accounts AS a
        ON b.branch_id = a.branch_id
    JOIN transactions AS t
        ON a.account_id = t.account_id
    GROUP BY
        b.branch_id,
        b.branch_name,
        b.city
),
Branch_Ranking AS (
    SELECT
        branch_id,
        branch_name,
        city,
        total_transactions,
        total_transaction_amount,
        DENSE_RANK() OVER(
            ORDER BY total_transaction_amount DESC
        ) AS branch_rank
    FROM Branch_Transactions
)
SELECT *
FROM Branch_Ranking
WHERE branch_rank <= 5
ORDER BY branch_rank;

-- Q14. Customers with late loan payments

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(lp.payment_id) AS total_late_payments,
    ROUND(SUM(lp.payment_amount), 2) AS total_late_payment_amount
FROM customers AS c
JOIN loans AS l
    ON c.customer_id = l.customer_id
JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id
WHERE lp.status = 'Late'
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY
    total_late_payments DESC,
    total_late_payment_amount DESC;
    
    -- Q15. Loan payment collection percentage by loan

WITH Loan_Collection AS (
    SELECT
        l.loan_id,
        l.customer_id,
        l.loan_type,
        l.loan_amount,
        COALESCE(SUM(lp.payment_amount), 0) AS total_payment_collected
 FROM loans AS l
    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id
    GROUP BY
        l.loan_id,
        l.customer_id,
        l.loan_type,
        l.loan_amount
)
SELECT
    loan_id,
    customer_id,
    loan_type,
    loan_amount,
    ROUND(total_payment_collected, 2) AS total_payment_collected,
    ROUND(
        total_payment_collected * 100.0 /
        NULLIF(loan_amount, 0),
        2
    ) AS payment_collection_percentage
FROM Loan_Collection
ORDER BY payment_collection_percentage DESC;