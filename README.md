# 🛒 Walmart Sales Analysis Using SQL

## 📌 Project Overview

This project analyses Walmart sales data using **MySQL** to explore sales performance, product trends, customer behaviour, payment methods, revenue, VAT, ratings, and branch-level performance.

The project focuses on using SQL for **data cleaning, feature engineering, aggregation, filtering, subqueries, joins, CASE statements, and window functions** to answer practical business questions from transactional sales data.

The dataset contains **1,000 sales transactions** across **3 branches/cities**, **6 product lines**, **2 customer types**, and **3 payment methods**.

---

## 🎯 Project Objectives

The main objectives of this project are to:

* Clean and prepare the Walmart sales data for analysis.
* Convert date and time fields into appropriate SQL data types.
* Create additional time-based features.
* Analyse product-line and sales performance.
* Identify customer purchasing patterns.
* Compare branch-level performance.
* Analyse revenue, COGS, VAT, quantity sold, and ratings.
* Answer business questions using SQL queries.
* Practise advanced SQL concepts such as subqueries and window functions.

---

## 🗂️ Dataset

The dataset contains Walmart sales transactions with information related to:

| Column                    | Description                         |
| ------------------------- | ----------------------------------- |
| `invoice_id`              | Unique invoice identifier           |
| `branch`                  | Walmart branch                      |
| `city`                    | City of the branch                  |
| `customer_type`           | Type of customer — Member or Normal |
| `gender`                  | Customer gender                     |
| `product_line`            | Product category                    |
| `unit_price`              | Price per unit                      |
| `quantity`                | Quantity purchased                  |
| `tax_5_percent`           | 5% VAT/tax amount                   |
| `total`                   | Total transaction value             |
| `Date`                    | Transaction date                    |
| `Time`                    | Transaction time                    |
| `payment`                 | Payment method                      |
| `cogs`                    | Cost of goods sold                  |
| `gross_margin_percentage` | Gross margin percentage             |
| `gross_income`            | Gross income                        |
| `rating`                  | Customer rating                     |
| `time_of_day`             | Derived time category               |
| `day_name`                | Derived day of the week             |
| `month_name`              | Derived month                       |

The dataset covers transactions from **January to March 2019** and contains **1,000 rows and 21 columns**.

---

## 🧹 Data Cleaning

The first stage of the project prepares the date and time columns for analysis.

### Date Conversion

The original `Date` field is converted into a proper MySQL `DATE` data type.

```sql
UPDATE walmart_sales
SET Date = STR_TO_DATE(Date,'%Y-%m-%d');

ALTER TABLE walmart_sales
MODIFY COLUMN Date DATE;
```

### Time Conversion

The `Time` field is converted into a proper MySQL `TIME` data type.

```sql
ALTER TABLE walmart_sales
MODIFY COLUMN Time TIME;

UPDATE walmart_sales
SET Time = STR_TO_DATE(Time,'%H:%i:%s');
```

These transformations allow the date and time information to be used effectively in subsequent analysis.

---

## ⚙️ Feature Engineering

Three additional features are created to make the transactional data easier to analyse.

### 1. Time of Day

Transactions are classified into:

* **Morning** — 00:00:00 to 11:59:59
* **Afternoon** — 12:00:00 to 16:59:59
* **Evening** — remaining hours

```sql
ALTER TABLE walmart_sales
ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmart_sales
SET time_of_day =
CASE
    WHEN TIME(time) BETWEEN '00:00:00' AND '11:59:59'
        THEN 'Morning'
    WHEN TIME(time) BETWEEN '12:00:00' AND '16:59:59'
        THEN 'Afternoon'
    ELSE 'Evening'
END;
```

### 2. Day Name

The day of the week is extracted from the transaction date.

```sql
ALTER TABLE walmart_sales
ADD COLUMN day_name VARCHAR(15);

UPDATE walmart_sales
SET day_name = DAYNAME(date);
```

### 3. Month Name

The month is extracted from the transaction date.

```sql
ALTER TABLE walmart_sales
ADD COLUMN month_name VARCHAR(15);

UPDATE walmart_sales
SET month_name = MONTHNAME(date);
```

These engineered features are subsequently used for time-based sales and customer-rating analysis.

---

# 📊 Business Analysis

The project answers business questions across four major areas:

## A. Generic Analysis

The analysis investigates:

* Number of unique cities in the dataset.
* Branch-to-city relationships.

Example:

```sql
SELECT branch, city
FROM walmart_sales
GROUP BY branch, city;
```

---

## B. Product Analysis

Product-level analysis covers:

* Number of unique product lines.
* Most common payment method.
* Most frequently sold product line.
* Total revenue by month.
* Month with the largest COGS.
* Product line generating the largest revenue.
* City generating the largest revenue.
* Product line with the largest VAT.
* Product lines performing above or below average sales.
* Branches selling more products than average.
* Most common product line by gender.
* Average rating for each product line.

The project uses `GROUP BY`, aggregate functions, `ORDER BY`, `LIMIT`, subqueries, and `CASE` expressions to answer these questions.

---

## 💰 Sales Analysis

The sales analysis focuses on:

### Sales by Time and Day

The number of sales is calculated for each combination of time of day and weekday.

```sql
SELECT time_of_day,
       day_name,
       COUNT(*) AS total_sales
FROM walmart_sales
GROUP BY time_of_day, day_name
ORDER BY total_sales DESC;
```

### Revenue by Customer Type

Customer types are compared based on their total revenue contribution.

### VAT by City

The average VAT percentage is compared across cities.

### VAT by Customer Type

The total VAT contributed by each customer type is calculated.

These queries provide a view of sales activity, revenue contribution, and tax patterns across different customer and geographic segments.

---

# 👥 Customer Analysis

The customer analysis investigates:

* Number of unique customer types.
* Number of unique payment methods.
* Most common customer type.
* Customer type purchasing the highest quantity.
* Gender distribution of customers.
* Gender distribution across branches.
* Time of day when customers provide the most ratings.
* Time of day with the most ratings for each branch.
* Day of the week with the highest average rating.
* Best-rated day of the week for each branch.

For branch-level rating analysis, the project uses the `RANK()` window function to identify the highest-performing time periods and days within each branch.

Example:

```sql
RANK() OVER (
    PARTITION BY branch
    ORDER BY AVG(rating) DESC
)
```

This demonstrates the use of **SQL window functions for grouped ranking analysis**.

---

# 🧠 SQL Concepts Used

This project demonstrates practical use of:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `LIMIT`
* `COUNT()`
* `SUM()`
* `AVG()`
* `ROUND()`
* `DISTINCT`
* `CASE`
* `UPDATE`
* `ALTER TABLE`
* `STR_TO_DATE()`
* `DAYNAME()`
* `MONTHNAME()`
* Subqueries
* Derived tables
* `JOIN`
* Window functions
* `RANK()`
* Feature engineering
* Data type conversion

---

# 📈 Key Dataset Facts

Based on the supplied dataset:

| Metric                  |              Value |
| ----------------------- | -----------------: |
| Total transactions      |              1,000 |
| Total quantity sold     |              5,510 |
| Total revenue (`total`) |        322,966.749 |
| Number of branches      |                  3 |
| Number of cities        |                  3 |
| Number of product lines |                  6 |
| Customer types          |                  2 |
| Payment methods         |                  3 |
| Time-of-day categories  |                  3 |
| Date range              | January–March 2019 |

---

# 📁 Project Structure

```text
Walmart-Sales-SQL-Analysis/
│
├── walmart_sales.csv
├── Project 6 - Walmart Sales.sql
└── README.md
```

### `walmart_sales.csv`

Contains the Walmart sales transaction data used for the analysis.

### `Project 6 - Walmart Sales.sql`

Contains the complete SQL workflow, including:

1. Data cleaning
2. Feature engineering
3. Generic analysis
4. Product analysis
5. Sales analysis
6. Customer analysis

---

# 🚀 How to Run the Project

### 1. Create the database

Create or select the required MySQL database:

```sql
CREATE DATABASE Projects;
USE Projects;
```

### 2. Import the dataset

Import `walmart_sales.csv` into a table named:

```text
walmart_sales
```

### 3. Run the SQL script

Open:

```text
Project 6 - Walmart Sales.sql
```

and execute the queries in order.

The script first performs the required data preparation and feature engineering before running the business-analysis queries.

---

# 🔍 Project Workflow

```text
Raw Walmart Sales Data
          ↓
     Data Cleaning
          ↓
 Date & Time Conversion
          ↓
   Feature Engineering
          ↓
Time of Day / Day / Month
          ↓
   Business Questions
          ↓
 Product Analysis
          ↓
   Sales Analysis
          ↓
 Customer Analysis
          ↓
     SQL Insights
```

---

# 💡 Business Questions Explored

The project uses SQL to answer questions such as:

* How many cities are represented in the dataset?
* Which branch belongs to each city?
* Which product line is sold most frequently?
* Which payment method is most commonly used?
* Which month generates the highest revenue?
* Which product line generates the highest revenue?
* Which city generates the highest revenue?
* Which branch sells more products than the average?
* Which customer type generates the most revenue?
* Which customer type purchases the most products?
* Which gender represents the largest customer group?
* When do customers provide the most ratings?
* Which day has the highest average customer rating?
* How do customer ratings vary across branches?

---

# 🛠️ Tools & Technologies

* **MySQL** — Data cleaning and SQL analysis
* **SQL** — Querying, aggregation, feature engineering and business analysis
* **CSV** — Source dataset

---

# 🎓 Learning Outcomes

Through this project, I strengthened my ability to:

* Work with real-world transactional data using SQL.
* Clean and transform data before analysis.
* Create useful analytical features from existing columns.
* Use aggregate functions to summarise business data.
* Analyse sales and customer behaviour using SQL.
* Work with subqueries and derived tables.
* Apply conditional logic using `CASE`.
* Use window functions such as `RANK()` for comparative analysis.
* Translate business questions into SQL queries.
* Organise a complete SQL analysis project for portfolio use.

---

# 👩‍💻 Author

**Shruti Gupta**

Bachelor of Arts (Honours) in English with Research
University of Delhi

---

⭐ If you found this project useful, feel free to explore the SQL queries and dataset included in this repository.
