# 🛒 Blinkit Quick Commerce Analytics

> **End-to-end data engineering and analytics pipeline for rapid delivery e-commerce platform**

[![Databricks](https://img.shields.io/badge/Databricks-SQL-FF3621?logo=databricks)](https://databricks.com)
[![Status](https://img.shields.io/badge/Status-Production-success)](#)
[![Data](https://img.shields.io/badge/Transactions-5K-blue)](#)
[![Revenue](https://img.shields.io/badge/Revenue-₹4.97M-green)](#)
[![Customers](https://img.shields.io/badge/Customers-2.5K-orange)](#)

---

## 📊 Project Overview

This project demonstrates enterprise-grade data engineering and business intelligence capabilities through comprehensive analysis of Blinkit's quick commerce operations. The analysis encompasses **5,000 orders**, **2,496 unique customers**, and **268 products** across multiple categories, generating **₹4.97 million** in revenue over **2 years** (2023-2024).

### 🎯 Business Objectives

* **Data Engineering**: Build robust ETL pipeline with comprehensive data quality framework
* **Star Schema Design**: Implement dimensional modeling for optimized analytical queries
* **Quality Assurance**: Deploy multi-layered validation across 4 core datasets
* **Business Intelligence**: Extract actionable insights for operations, inventory, and customer success
* **Performance Analytics**: Identify revenue drivers, delivery patterns, and growth opportunities

---

## 🏗️ Data Architecture

### Star Schema Design

```
                    ┌─────────────────┐
                    │  dim_customers  │
                    │  (2,496 rows)   │
                    └────────┬────────┘
                             │
                             │
┌─────────────────┐          │          ┌─────────────────┐
│  dim_products   │──────────┼──────────│   dim_orders    │
│  (268 rows)     │          │          │   (5,000 rows)  │
└────────┬────────┘          │          └────────┬────────┘
         │                   │                   │
         │         ┌─────────▼────────┐         │
         └─────────│ fact_order_items │─────────┘
                   │  (5,000 rows)    │
                   │  [FACT TABLE]    │
                   └──────────────────┘
```

### ETL Pipeline Architecture

```
┌──────────────────┐
│   Source Tables  │
├──────────────────┤
│ • blinkit_customers     │
│ • blinkit_products      │
│ • blinkit_orders        │
│ • blinkit_order_items   │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Data Quality    │
│  Validation      │
├──────────────────┤
│ ✓ Null checks    │
│ ✓ Duplicate det  │
│ ✓ Type validation│
│ ✓ Outlier detect │
│ ✓ Business rules │
│ ✓ Format checks  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Transformation  │
│  & Cleansing     │
├──────────────────┤
│ • Trim spaces    │
│ • Dedup emails   │
│ • Fix margins    │
│ • Type casting   │
│ • Pincode clean  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Clean Tables    │
├──────────────────┤
│ • *_clean tables │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Star Schema     │
│  Modeling        │
├──────────────────┤
│ • dim_customers  │
│ • dim_products   │
│ • dim_orders     │
│ • fact_order_items│
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   Analytics      │
│   & Insights     │
├──────────────────┤
│ • Revenue KPIs   │
│ • Product perf   │
│ • Customer LTV   │
│ • Delivery SLA   │
│ • Time trends    │
└──────────────────┘
```

---

## 🔧 Data Engineering Process

### Phase 1: Data Quality Assessment

#### 🧹 **Order Items Table** (5,000 records)

| Check | Result | Action |
|-------|--------|--------|
| Null values | ✅ 0 nulls | None required |
| Duplicates | ✅ No duplicates | None required |
| Quantity outliers | ✅ No outliers (3σ) | None required |
| Price outliers | ✅ No outliers (3σ) | None required |
| Data types | ✅ Valid schema | None required |

#### 📦 **Orders Table** (5,000 records)

| Check | Result | Action |
|-------|--------|--------|
| Null values | ✅ 0 nulls across 10 columns | None required |
| Duplicates | ✅ No duplicate order_ids | None required |
| Blank text | ✅ No blank values | None required |
| Extra spaces | ✅ No whitespace issues | None required |
| High outliers | ⚠️ 5 orders > ₹6,000 | Flagged (valid bulk orders) |

**High-Value Orders Identified:**
* ₹6,721.46 (Highest spending customer)
* ₹6,543.19 (Potential bulk purchase)
* ₹6,458.90, ₹6,173.45, ₹6,161.48 (Premium baskets)

#### 👥 **Customers Table** (2,500 → 2,496 records)

| Check | Result | Action |
|-------|--------|--------|
| Null values | ✅ 0 nulls across 11 columns | None required |
| Duplicates | ✅ No duplicate customer_ids | None required |
| Blank values | ✅ No blank strings | None required |
| Phone format | ✅ All +91XXXXXXXXXX (12 chars) | None required |
| Pincode length | ⚠️ 223 invalid pincodes | **Fixed: Set to '000000'** |
| Email duplicates | ⚠️ 4 duplicate emails | **Fixed: Kept earliest registration** |
| Special characters | ⚠️ 5 names with curly quotes | **Fixed: Replaced ' → '** |
| Negative values | ✅ No negative orders/values | None required |
| Future dates | ✅ No future registrations | None required |
| Outliers | ✅ No avg_order_value outliers | None required |

**Data Cleansing Actions:**
```sql
-- Fix invalid pincodes (223 records)
UPDATE blinkit_customers_clean
SET pincode = '000000'
WHERE LENGTH(CAST(pincode AS STRING)) <> 6;

-- Remove duplicate emails (4 duplicates)
CREATE OR REPLACE TABLE blinkit_customers_clean AS
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY email ORDER BY registration_date) AS rn
    FROM blinkit_customers_clean
) WHERE rn = 1;

-- Fix special characters (5 records)
UPDATE blinkit_customers_clean
SET customer_name = REPLACE(customer_name, ''', ''');
```

#### 🛍️ **Products Table** (268 records)

| Check | Result | Action |
|-------|--------|--------|
| Null values | ✅ 0 nulls | None required |
| Duplicates | ✅ No duplicate product_ids | None required |
| Blank values | ✅ No blanks | None required |
| Extra spaces | ✅ No whitespace | None required |
| Price validation | ✅ All prices > 0, price ≤ MRP | None required |
| Margin calculation | ⚠️ 4 products wrong margin | **Fixed: Recalculated** |
| Shelf life | ✅ All > 0 days | None required |
| Stock levels | ✅ min ≤ max, all > 0 | None required |
| Price outliers | ✅ No outliers (3σ) | None required |

**Margin Correction:**
```sql
-- Recalculate margin for 4 products
UPDATE blinkit_products_clean
SET margin_percentage = ROUND(((mrp - price) / mrp) * 100, 2);
```

### Phase 2: Star Schema Implementation

**Dimensional Model Design Rationale:**
* **Fact Table**: `fact_order_items` - Grain: One row per product per order
* **Customer Dimension**: Demographic and segmentation attributes
* **Product Dimension**: Product master with pricing and inventory metadata
* **Order Dimension**: Transaction metadata, delivery, and payment info

---

## 📈 Business Analytics & Key Insights

### 💰 Executive KPI Dashboard

| Metric | Value | Insight |
|--------|-------|----------|
| **Total Revenue** | ₹4,972,415 | Strong performance over 2 years |
| **Total Orders** | 5,000 | Complete transaction coverage |
| **Average Order Value** | ₹994.48 | High basket size for quick commerce |
| **Unique Customers** | 2,496 | ~2 orders per customer lifetime |
| **Product Catalog** | 268 SKUs | Curated assortment strategy |
| **On-Time Delivery** | 69.4% | Room for improvement |
| **Avg Delivery Delay** | 4.44 min | Acceptable SLA performance |

---

### 🏆 Product Performance Analysis

#### Top 10 Products by Volume Sold

| Rank | Product | Units Sold | Category |
|------|---------|------------|----------|
| 🥇 | Pet Treats | 473 | Pet Care |
| 🥈 | Toilet Cleaner | 430 | Household Care |
| 🥉 | Dish Soap | 397 | Household Care |
| 4 | Vitamins | 380 | Pharmacy |
| 5 | Cough Syrup | 373 | Pharmacy |
| 6 | Lotion | 350 | Personal Care |
| 7 | Baby Wipes | 328 | Baby Care |
| 8 | Cat Food | 307 | Pet Care |
| 9 | Pulses | 273 | Grocery |
| 10 | Bread | 270 | Dairy & Breakfast |

**💡 Insight**: Household essentials and pharmacy products drive volume—optimize inventory for these SKUs.

#### Top 10 Products by Revenue

| Rank | Product | Revenue (₹) | Margin Impact |
|------|---------|-------------|---------------|
| 🥇 | Vitamins | 260,822 | High-value pharmacy |
| 🥈 | Pet Treats | 252,007 | Volume × Price |
| 🥉 | Cough Syrup | 203,570 | Seasonal demand |
| 4 | Toilet Cleaner | 199,837 | Consistent replenishment |
| 5 | Bread | 184,851 | Daily essential |
| 6 | Dish Soap | 184,441 | Household staple |
| 7 | Cat Food | 166,596 | Pet care premium |
| 8 | Baby Wipes | 158,768 | Baby care essential |
| 9 | Onions | 138,858 | Fresh produce |
| 10 | Baby Food | 137,443 | Premium pricing |

**💡 Insight**: Pharmacy and pet care deliver highest revenue—consider expanding these categories.

---

### 📊 Category Performance

| Rank | Category | Revenue (₹) | % Contribution |
|------|----------|-------------|----------------|
| 1 | Dairy & Breakfast | 639,222 | **12.86%** |
| 2 | Pharmacy | 592,369 | **11.92%** |
| 3 | Fruits & Vegetables | 559,053 | **11.25%** |
| 4 | Pet Care | 539,889 | **10.86%** |
| 5 | Household Care | 444,244 | **8.94%** |
| 6 | Personal Care | 394,895 | **7.94%** |
| 7 | Snacks & Munchies | 394,649 | **7.94%** |
| 8 | Cold Drinks & Juices | 392,718 | **7.90%** |
| 9 | Grocery & Staples | 359,938 | **7.24%** |
| 10 | Baby Care | 348,227 | **7.01%** |
| 11 | Instant & Frozen Food | 307,213 | **6.18%** |

**💡 Strategic Insight**: Top 4 categories (Dairy, Pharmacy, Fresh, Pet) contribute **46.8%** of revenue—focus inventory depth here.

---

### 🏢 Brand Performance (Top 5)

| Brand | Revenue (₹) | Strategy |
|-------|-------------|----------|
| Karnik PLC | 65,213 | Premium positioning |
| Mandal-Kar | 56,465 | Value leader |
| Roy-Char | 55,183 | Mid-market |
| Sundaram Inc | 51,830 | Quality focus |
| Gole-Doshi | 51,791 | Emerging brand |

---

### 👥 Customer Intelligence

#### Top 5 Customers by Lifetime Value

| Customer | Total Spent (₹) | Orders (Est) |
|----------|-----------------|-------------|
| Odika Kannan | 10,533 | High-value VIP |
| Nidhi Sha | 10,116 | Loyal customer |
| Dev Bal | 9,925 | Premium buyer |
| Anmol Koshy | 9,699 | Frequent purchaser |
| Lipika Kumer | 9,554 | Top 0.2% spender |

#### Customer Segmentation Analysis

```sql
-- Revenue by customer segment
SELECT 
    c.customer_segment, 
    ROUND(SUM(f.sales_amount), 2) AS total_spent 
FROM fact_order_items f
JOIN dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY total_spent DESC;
```

#### Geographic Performance (Top 5 Areas by Units)

| Area | Units Sold | Regional Focus |
|------|------------|----------------|
| Orai | 93 | Leading market |
| Deoghar | 79 | Strong presence |
| Nandyal | 73 | Growth opportunity |
| Bathinda | 73 | Consistent demand |
| Gandhinagar | 71 | Emerging market |

**💡 Insight**: Geographic concentration suggests expansion potential in top-performing regions.

---

### 🚚 Delivery & Operations Analytics

#### Delivery Performance

| Status | Orders | % of Total | SLA Impact |
|--------|--------|------------|------------|
| **On Time** | 3,470 | **69.4%** | ✅ Meeting baseline |
| **Slightly Delayed** | 1,037 | **20.7%** | ⚠️ Needs improvement |
| **Significantly Delayed** | 493 | **9.9%** | 🚨 Critical issue |

**Average Delivery Delay**: 4.44 minutes (acceptable but can improve)

**💡 Operational Recommendation**: 
* Investigate root causes for 30.6% delayed orders
* Focus on reducing "Significantly Delayed" segment (9.9%)
* Target: Achieve 85%+ on-time delivery rate

#### Payment Method Distribution

| Payment Method | Orders | % Share |
|----------------|--------|----------|
| Card | 1,285 | 25.7% |
| Cash | 1,257 | 25.1% |
| Wallet | 1,244 | 24.9% |
| UPI | 1,214 | 24.3% |

**💡 Insight**: Balanced payment mix indicates strong digital adoption alongside cash preference.

---

### ⏰ Time-Based Analytics

#### Yearly Revenue Trend

| Year | Revenue (₹) | YoY Growth |
|------|-------------|------------|
| 2023 | 2,460,612 | - |
| 2024 | 2,511,804 | **+2.08%** |

**💡 Insight**: Modest growth; consider aggressive customer acquisition and retention strategies.

#### Monthly Revenue Pattern

* **Peak Performance**: Months 5-10 (mid-year strength)
* **Highest Month**: Month 8 (peak revenue)
* **Concern**: Sharp drop in months 11-12 (year-end seasonality or operational issue)

**💡 Strategic Action**: Investigate Q4 decline—potential causes:
* Seasonal demand drop
* Supply chain constraints
* Budget exhaustion
* Competitive pressure

#### Daily Revenue Volatility

* **Peak Day**: Day 10 (₹217,021)
* **Lowest Day**: Day 31 (₹95,425)
* **Pattern**: High spikes on Days 9, 21, 23, 27 (potential weekly promotions)

#### Weekday vs Weekend Performance

| Day Type | Revenue (₹) | % Contribution |
|----------|-------------|----------------|
| **Weekday** | 3,593,749 | **72.3%** |
| **Weekend** | 1,378,666 | **27.7%** |

**💡 Insight**: Strong weekday dominance—consider targeted weekend promotions.

#### Hourly Demand Pattern

**Peak Ordering Hours:**
1. **8 AM** - 240 orders (morning rush)
2. **1 PM** - 239 orders (lunch peak)
3. **6-8 PM** - 226-228 orders (dinner time)

**Revenue Peaks:**
* Morning: Hours 8-10
* Late night: Hour 23 (strong late-night demand)

**Slowest Period**: Hours 11-16 (mid-day dip)

**💡 Operational Recommendation**:
* Increase staffing at 8 AM, 1 PM, 6-8 PM
* Optimize inventory replenishment before peak hours
* Consider mid-day promotions to boost 11-16 hour performance

---

### 📦 Inventory & Product Strategy

#### High-Margin Products (Top 10)

| Product | Margin % | Strategy |
|---------|----------|----------|
| Instant Noodles | 40% | Maximize visibility |
| Frozen Pizza | 40% | Premium placement |
| Frozen Vegetables | 40% | Bundling opportunity |
| Ice Cream | 40% | Impulse category |
| Frozen Biryani | 40% | Ready-to-eat growth |
| Cookies | 35% | Snacking essential |
| Popcorn | 35% | High-margin snack |
| Chocolates | 35% | Impulse purchase |
| Biscuits | 35% | Volume driver |

**💡 Strategic Priority**: Promote 40% margin products aggressively—drive profitability.

#### Low Stock Risk Products

Products with `min_stock_level > 10` require active monitoring to prevent stockouts.

---

## 🎯 Strategic Recommendations

### 🔥 High-Priority Actions

#### 1. **Delivery Performance Improvement**
* **Goal**: Increase on-time delivery from 69.4% to 85%+
* **Actions**:
  * Root cause analysis for "Significantly Delayed" orders (9.9%)
  * Implement predictive ETA algorithms
  * Optimize delivery partner allocation
  * Add buffer time during peak hours (8 AM, 1 PM, 6-8 PM)

#### 2. **Revenue Growth Acceleration**
* **Goal**: Reverse 2024 modest growth (+2.08%) to double-digit growth
* **Actions**:
  * Investigate Q4 decline (months 11-12)
  * Launch aggressive customer acquisition in top-performing areas (Orai, Deoghar)
  * Expand Pharmacy and Pet Care categories (combined 22.8% revenue)
  * Implement retention programs for top 100 customers

#### 3. **Weekend Revenue Boost**
* **Goal**: Increase weekend contribution from 27.7% to 35%
* **Actions**:
  * Launch weekend-specific promotions
  * Extend operating hours on Saturdays
  * Target leisure categories (Snacks, Cold Drinks, Instant Food)

#### 4. **Mid-Day Performance Optimization**
* **Goal**: Reduce 11-16 hour revenue dip
* **Actions**:
  * Launch "Lunch Break" flash sales
  * Promote office delivery bundles
  * Offer mid-day exclusive discounts

### 💡 Category Strategy

#### **Expand High-Performers**
* **Pharmacy** (11.92% revenue): Add wellness and supplement SKUs
* **Pet Care** (10.86% revenue): Introduce premium pet food brands
* **Dairy & Breakfast** (12.86% revenue): Expand fresh and organic options

#### **Revive Underperformers**
* **Instant & Frozen Food** (6.18% revenue): Bundle deals, recipe marketing
* **Personal Care** (7.94% revenue): Add grooming and beauty products

### 👥 Customer Strategy

#### **VIP Customer Program**
* Target top 5% customers (₹9,500+ lifetime value)
* Offer early access to new products
* Provide free delivery above ₹500

#### **Segmentation-Based Marketing**
* Analyze customer_segment revenue distribution
* Tailor promotions by segment behavior
* Build lookalike audiences for acquisition

### 📍 Geographic Expansion

* **Double down on Orai**: Already leading (93 units)—increase SKU depth
* **Grow Deoghar & Nandyal**: Strong performance (73-79 units)—invest in local marketing
* **Test new markets**: Use data to identify similar demographics

---

## 🛠️ Technical Stack

| Component | Technology |
|-----------|------------|
| **Platform** | Databricks |
| **Compute** | Serverless SQL Warehouse (PRO, 2X-Small) |
| **Acceleration** | Photon-enabled |
| **Language** | Databricks SQL |
| **Catalog** | Unity Catalog (`saswat.pintu`) |
| **Modeling** | Star Schema (3 dimensions + 1 fact table) |
| **Cloud Provider** | AWS |

---

## 📁 Project Structure

```
.
├── README.md                          # This file
├── blinkit_analysis.dbquery.ipynb    # Main SQL analysis (84 statements)
│
├── data/
│   ├── raw/
│   │   ├── blinkit_customers          # 2,500 customers
│   │   ├── blinkit_products           # 268 products
│   │   ├── blinkit_orders             # 5,000 orders
│   │   └── blinkit_order_items        # 5,000 line items
│   │
│   ├── clean/
│   │   ├── blinkit_customers_clean    # Cleaned: 2,496 customers
│   │   ├── blinkit_products_clean     # Cleaned: 268 products
│   │   ├── blinkit_orders_clean       # Cleaned: 5,000 orders
│   │   └── blinkit_order_items_clean  # Cleaned: 5,000 line items
│   │
│   └── star_schema/
│       ├── dim_customers              # Customer dimension
│       ├── dim_products               # Product dimension
│       ├── dim_orders                 # Order dimension
│       └── fact_order_items           # Central fact table
│
└── analysis/
    ├── 01_data_quality_checks.sql     # Statements 1-56
    ├── 02_star_schema_design.sql      # Statements 57-64
    ├── 03_kpi_analysis.sql            # Statements 65-78
    └── 04_time_based_analysis.sql     # Statements 79-84
```

---

## 🚀 How to Use This Project

### Prerequisites
* Databricks workspace with SQL warehouse access
* Unity Catalog enabled
* Catalog: `saswat` | Schema: `pintu`

### Setup & Execution

#### **Step 1: Load Raw Data**
```sql
USE CATALOG saswat;
USE SCHEMA pintu;

-- Ensure source tables exist:
-- • blinkit_customers (2,500 rows)
-- • blinkit_products (268 rows)
-- • blinkit_orders (5,000 rows)
-- • blinkit_order_items (5,000 rows)
```

#### **Step 2: Run Data Quality Pipeline**
```sql
-- Execute statements 1-6: Create clean table copies
-- Execute statements 7-56: Run all validation and cleansing
```

**Key Cleansing Operations:**
* Fix 223 invalid pincodes
* Remove 4 duplicate emails
* Correct 4 product margin calculations
* Standardize 5 customer names with special characters

#### **Step 3: Build Star Schema**
```sql
-- Execute statements 57-63: Create dimension tables
-- dim_customers, dim_products, dim_orders

-- Execute statement 64: Create fact table
-- fact_order_items (joins order items + orders)
```

#### **Step 4: Run Analytics**
```sql
-- Execute statements 65-78: KPI analysis
-- • Revenue metrics
-- • Product performance
-- • Customer LTV
-- • Delivery analytics

-- Execute statements 79-84: Time-based analysis
-- • Daily, monthly, yearly trends
-- • Weekday vs weekend
-- • Hourly demand patterns
```

---

## 📊 Sample Queries

### Revenue Analysis
```sql
-- Total revenue and AOV
SELECT 
    ROUND(SUM(sales_amount), 2) AS total_revenue,
    ROUND(SUM(sales_amount) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM fact_order_items;
```

### Top Products by Revenue
```sql
SELECT 
    p.product_name, 
    ROUND(SUM(f.sales_amount), 2) AS total_revenue
FROM fact_order_items f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;
```

### Delivery Performance
```sql
SELECT 
    delivery_status,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / SUM(COUNT(DISTINCT order_id)) OVER(), 2) AS pct
FROM dim_orders
GROUP BY delivery_status;
```

### Hourly Demand Pattern
```sql
SELECT 
    HOUR(o.order_date) AS hour,
    COUNT(DISTINCT f.order_id) AS orders,
    ROUND(SUM(f.sales_amount), 2) AS revenue
FROM fact_order_items f
JOIN dim_orders o ON f.order_id = o.order_id
GROUP BY HOUR(o.order_date)
ORDER BY orders DESC;
```

---

## 🎓 Key Learnings

### Data Engineering Best Practices Demonstrated

1. **Comprehensive Data Quality Framework**
   * Multi-dimensional validation (nulls, duplicates, types, outliers, business rules)
   * Automated outlier detection using statistical methods (mean ± 3σ)
   * Format validation (phone, pincode, email)

2. **Robust ETL Pipeline Design**
   * Separate raw and clean table layers
   * Idempotent transformations (CREATE OR REPLACE)
   * Audit trail via comments and documentation

3. **Star Schema Optimization**
   * Fact table at order line item grain (most granular)
   * Denormalized dimensions for query performance
   * Natural vs surrogate key considerations

4. **SQL Performance Patterns**
   * Window functions for deduplication (ROW_NUMBER)
   * Aggregate functions with statistical analysis
   * Efficient join patterns (fact to dimensions)

5. **Business-Driven Analytics**
   * KPIs aligned to business objectives (revenue, delivery SLA, customer LTV)
   * Actionable insights with clear recommendations
   * Time-series analysis for trend identification

---

## 📈 Business Impact

### Quantified Value Delivered

| Area | Finding | Impact |
|------|---------|--------|
| **Data Quality** | Fixed 231 data issues | Improved analytics accuracy |
| **Delivery SLA** | Identified 30.6% delayed orders | Action plan for 15% improvement |
| **Product Mix** | Top 4 categories = 46.8% revenue | Focus inventory investment |
| **Customer LTV** | Top 5% customers = ₹9,500+ value | VIP program ROI potential |
| **Peak Hours** | 8 AM = 240 orders (max) | Optimized staffing plan |
| **Weekday Focus** | 72.3% revenue from weekdays | Weekend promo opportunity |
| **High Margin** | 40% margin on frozen foods | Profitability driver |

---

## 🔮 Future Enhancements

### Phase 2 Roadmap

1. **Advanced Analytics**
   * Customer cohort analysis (registration month → LTV)
   * Product affinity analysis (market basket)
   * Churn prediction modeling
   * Price elasticity analysis

2. **Operational Intelligence**
   * Real-time delivery tracking dashboard
   * Inventory optimization models (EOQ)
   * Demand forecasting (time-series ML)
   * Route optimization for delivery partners

3. **Customer 360**
   * RFM segmentation (Recency, Frequency, Monetary)
   * Propensity-to-buy models
   * Next-best-product recommendations
   * Personalized promotions engine

4. **Technical Enhancements**
   * Implement CDC (Change Data Capture) for real-time updates
   * Add data quality monitoring with alerts
   * Build automated testing framework
   * Create Lakeview dashboards for self-service BI

---

## 👨‍💻 Author

**Saswat Betta Aptakam**  
*Data Engineering & Analytics Professional*

📧 saswatbetta.aptakam@gmail.com  
📍 Catalog: `saswat` | Schema: `pintu`

---

## 📄 License

This project is created for educational and portfolio demonstration purposes.

---

## 🙏 Acknowledgments

* **Platform**: Databricks for providing enterprise-grade analytics infrastructure
* **Compute**: Serverless SQL with Photon acceleration for fast query performance
* **Dataset**: Synthetic Blinkit e-commerce data for analysis

---

## 📞 Contact & Collaboration

Interested in discussing data engineering patterns, SQL optimization, or business analytics?

**Let's connect!**

* Open to collaboration on data projects
* Available for consulting on analytics pipeline design
* Happy to discuss dimensional modeling and star schema best practices

---

<div align="center">

**⭐ If you found this project useful, please star it! ⭐**

*Built with* ❤️ *using Databricks SQL*

</div>
