<div align="center">

# 🛒 Blinkit Business Analytics
### End-to-End Data Analytics Project using SQL Server, Python & Power BI

![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas)
![NumPy](https://img.shields.io/badge/NumPy-013243?style=for-the-badge&logo=numpy)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github)

### 📊 SQL Server • ETL • Data Cleaning • Python EDA • Power BI Dashboard

</div>

---

# 📖 Project Overview

This project demonstrates an end-to-end Data Analytics workflow built on a simulated Blinkit business dataset.

The project starts with raw CSV files, loads them into SQL Server using Bulk Insert, performs comprehensive data cleaning and validation, builds clean relational tables with Primary and Foreign Keys, analyzes the data using Python, and finally visualizes business insights through an interactive Power BI dashboard.

The project follows a real-world data engineering and analytics workflow similar to enterprise reporting solutions.

---

# 🎯 Business Problem

Business stakeholders need a centralized analytics solution to answer questions such as:

- Which products generate the highest revenue?
- Which customer segments contribute the most revenue?
- Which categories are most profitable?
- How efficient are deliveries?
- What are monthly sales trends?
- Which payment methods are most frequently used?
- Which products require inventory optimization?

---

# 🎯 Project Objectives

- Import raw CSV files into SQL Server
- Build a structured relational database
- Perform comprehensive SQL data cleaning
- Validate business rules
- Maintain referential integrity
- Convert raw data into analytics-ready datasets
- Perform Exploratory Data Analysis using Python
- Build an interactive Power BI Dashboard
- Generate business insights for decision making

---

# 🛠 Tech Stack

| Technology | Purpose |
|------------|---------|
| SQL Server | Database Management |
| SQL | ETL & Data Cleaning |
| Python | Data Analysis |
| Pandas | Data Manipulation |
| NumPy | Numerical Computing |
| Matplotlib | Visualization |
| Seaborn | Statistical Charts |
| Jupyter Notebook | EDA |
| Power BI | Dashboard |
| Git & GitHub | Version Control |

---

# 📂 Dataset

The project consists of four relational datasets.

| Table | Records |
|--------|---------:|
| Customers | 2,500 |
| Orders | 5,000 |
| Order Items | 5,000 |
| Products | 268 |

---

# 🏗 Project Architecture

```text
                CSV Files
                    │
                    ▼
             SQL Server Database
                    │
          Bulk Insert (Raw Layer)
                    │
                    ▼
          Data Cleaning & Validation
                    │
                    ▼
          Clean Relational Tables
                    │
                    ▼
         Primary & Foreign Keys
                    │
                    ▼
              Python (EDA)
                    │
                    ▼
          Business Insights
                    │
                    ▼
        Power BI Interactive Dashboard
```

---

# 🗄 Database Design

## Raw Tables

- BLINKIT_CUSTOMERS
- BLINKIT_ORDERS
- BLINKIT_ORDER_ITEMS
- BLINKIT_PRODUCTS

## Clean Tables

- CUSTOMERS_CLEAN
- ORDERS_CLEAN
- ORDER_ITEMS_CLEAN
- PRODUCTS_CLEAN

---

# 🔄 ETL Workflow

### Step 1

Create SQL Server Database

### Step 2

Create Raw Tables

### Step 3

Bulk Insert CSV Files

### Step 4

Validate Imported Data

### Step 5

Perform Data Cleaning

### Step 6

Validate Business Rules

### Step 7

Create Clean Tables

### Step 8

Apply Primary Keys

### Step 9

Apply Foreign Keys

### Step 10

Export Clean Data for Python Analysis

---

# 🧹 SQL Data Cleaning

The following validation checks were performed across all tables:

### Customers

- Null Value Validation
- Blank Value Validation
- Duplicate Customer Validation
- Email Validation
- Phone Number Validation
- Pincode Validation
- Registration Date Validation
- Customer Segment Validation
- Total Orders Validation
- Average Order Value Validation
- Business Rule Validation

---

### Orders

- Null Value Validation
- Duplicate Order Validation
- Customer Referential Integrity
- Order Date Validation
- Delivery Time Validation
- Order Total Validation
- Payment Method Validation
- Store Validation
- Delivery Partner Validation
- Delayed Delivery Analysis

---

### Order Items

- Duplicate Validation
- Quantity Validation
- Unit Price Validation
- Product Validation
- Referential Integrity
- Business Rule Validation

---

### Products

- Null Value Validation
- Duplicate Product Validation
- Price Validation
- MRP Validation
- Margin Validation
- Shelf Life Validation
- Minimum Stock Validation
- Maximum Stock Validation
- Price vs MRP Validation
- Inventory Business Rules

---

# 🔐 Data Integrity

Primary Keys

- Customer ID
- Order ID
- Product ID

Foreign Keys

- Orders → Customers
- Order Items → Orders
- Order Items → Products

This ensures complete relational integrity throughout the database.

---

# 📊 Python Exploratory Data Analysis

EDA includes:

- Revenue Analysis
- Profit Analysis
- Monthly Revenue Trend
- Monthly Profit Trend
- Category Analysis
- Customer Analysis
- Product Analysis
- Payment Method Analysis
- Delivery Analysis
- Correlation Analysis
- Outlier Detection

---

# 📈 Key Performance Indicators

- Total Revenue
- Total Profit
- Total Orders
- Total Customers
- Average Order Value
- Revenue by Category
- Revenue by Payment Method
- Delivery Performance
- Product Performance
- Customer Segment Performance

---

# 📉 Dashboard Features

The Power BI dashboard provides:

- Executive KPI Cards
- Revenue Dashboard
- Profit Dashboard
- Customer Dashboard
- Product Dashboard
- Delivery Dashboard
- Monthly Trend Analysis
- Interactive Filters
- Drill-down Analysis

---

# 💡 Business Insights

The analysis helps identify:

- High-performing products
- High-value customers
- Revenue trends
- Profitability trends
- Delivery efficiency
- Customer purchasing behavior
- Inventory optimization opportunities

---

# 🚀 Business Recommendations

- Increase inventory for high-demand products.
- Focus marketing campaigns on premium customers.
- Improve delayed delivery performance.
- Promote high-margin product categories.
- Optimize stock planning using historical demand.
- Monitor monthly sales and profitability trends.

---

# 📁 Repository Structure

```text
Blinkit-Business-Analytics/
│
├── Dataset/
│
├── SQL/
│   ├── 01_RAW_LAYER.sql
│   ├── Cleaning_Part_Blinkit.sql
│
├── Python/
│   ├── Blinkit_EDA.ipynb
│   └── Blinkit_Final_EDA.ipynb
│
├── Dashboard/
│   └── Blinkit_Dashboard.pbix
│
├── Images/
│
└── README.md
```

---

# ▶️ How to Run

## SQL Server

1. Create Database
2. Execute `01_RAW_LAYER.sql`
3. Import CSV files using Bulk Insert
4. Execute Cleaning SQL Script
5. Validate Clean Tables

## Python

```bash
pip install pandas numpy matplotlib seaborn jupyter
```

Run

```text
Blinkit_Final_EDA.ipynb
```

---

# 📷 Dashboard Preview

> Add your dashboard screenshots here.

Example:

```text
Images/dashboard_overview.png
Images/customer_analysis.png
Images/product_analysis.png
``

---

# 💼 Skills Demonstrated

- SQL
- SQL Server
- ETL Pipeline
- Data Cleaning
- Data Validation
- Data Modeling
- Referential Integrity
- Primary & Foreign Keys
- Python
- Pandas
- Data Visualization
- Exploratory Data Analysis
- Power BI
- Business Intelligence
- GitHub

---

# 🔮 Future Enhancements

- Sales Forecasting
- Customer Segmentation
- Demand Prediction
- Machine Learning Models
- Azure SQL Integration
- Automated ETL Pipeline
- Real-Time Dashboard

---

# 👨‍💻 Author

**Saswat Betta Aptakam**

**Aspiring Data Analyst**

### Technical Skills

- SQL Server
- SQL
- Python
- Power BI
- Excel
- Pandas
- NumPy
- Data Visualization
- Business Analytics

---

## 📬 Contact
- **GitHub:** https://github.com/saswat925
