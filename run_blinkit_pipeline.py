import pandas as pd
from sqlalchemy import create_engine
import urllib

# ----------------------------
# SQL Server Connection
# ----------------------------

params = urllib.parse.quote_plus(
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=LAPTOP-71G1NMQR\\SQLEXPRESS;"
    "DATABASE=BLINKIT_DB;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)

engine = create_engine(
    f"mssql+pyodbc:///?odbc_connect={params}"
)

print("Connected to SQL Server")

# ----------------------------
# Load Tables
# ----------------------------

customers = pd.read_sql("SELECT * FROM CUSTOMERS_CLEAN", engine)
orders = pd.read_sql("SELECT * FROM ORDERS_CLEAN", engine)
order_items = pd.read_sql("SELECT * FROM ORDER_ITEMS_CLEAN", engine)
products = pd.read_sql("SELECT * FROM PRODUCTS_CLEAN", engine)

print("Tables Loaded")

# ----------------------------
# Merge Tables
# ----------------------------

df = customers.merge(orders, on="customer_id")
df = df.merge(order_items, on="order_id")
df = df.merge(products, on="product_id")

print("Merge Completed")

# ----------------------------
# Feature Engineering
# ----------------------------

df["revenue"] = df["quantity"] * df["unit_price"]

df["cost_price"] = (
    df["price"] *
    (1 - df["margin_percentage"]/100)
)

df["profit"] = (
    df["quantity"] *
    (df["price"] - df["cost_price"])
)

df["delivery_minutes"] = (
    df["actual_delivery_time"] -
    df["promised_delivery_time"]
).dt.total_seconds()/60

print("Business Columns Created")

# ----------------------------
# Save Final Dataset
# ----------------------------

df.to_csv(
    "Blinkit_Final_EDA_Dataset.csv",
    index=False,
    encoding="utf-8-sig"
)

print("CSV Saved Successfully")

# ----------------------------
# Quick Report
# ----------------------------

print("="*50)
print("Blinkit Pipeline Completed")
print("="*50)

print("Rows :", len(df))
print("Revenue :", round(df["revenue"].sum(),2))
print("Profit :", round(df["profit"].sum(),2))
print("Customers :", df["customer_id"].nunique())
print("Products :", df["product_id"].nunique())
