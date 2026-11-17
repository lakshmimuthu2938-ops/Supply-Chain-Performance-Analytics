import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load dataset
df = pd.read_csv("supply_chain_Cleaned.csv")

# Display first 5 rows
print(df.head())
# Dataset Information
print("\nDataset Shape:")
print(df.shape)

print("\nColumn Names:")
print(df.columns)

print("\nData Types:")
print(df.dtypes)

print("\nDataset Information:")
df.info()

# Missing Values Check
print("\nMissing Values:")
print(df.isnull().sum())

# Duplicate Values Check
print("\nDuplicate Rows:")
print(df.duplicated().sum())

# Descriptive Statistics
print("\nDescriptive Statistics:")
print(df.describe())

# Convert Date Column
df['Date'] = pd.to_datetime(df['Date'], format='%d-%m-%Y')

print("\nDate Data Type:")
print(df['Date'].dtype)

# Save Processed Dataset
df.to_csv("supply_chain_processed.csv", index=False)

print("\nProcessed Dataset Saved Successfully!")

# Verify Processed Dataset
print("\nProcessed Dataset Shape:")
print(df.shape)

print("\nProcessed Dataset Preview:")
print(df.head())

# Stockout Flag Analysis
print("\nStockout Flag Distribution:")
print(df['Stockout_Flag'].value_counts())

# Supplier Performance Analysis
supplier_analysis = df.groupby('Supplier_ID')['Supplier_Lead_Time_Days'].agg(
    ['mean', 'min', 'max']
)

print("\nSupplier Performance Analysis:")
print(supplier_analysis)

# Warehouse Performance Analysis
warehouse_analysis = df.groupby('Warehouse_ID').agg({
    'Units_Sold': 'mean',
    'Inventory_Level': 'mean',
    'Order_Quantity': 'mean'
})

print("\nWarehouse Performance Analysis:")
print(warehouse_analysis)

# Region Performance Analysis
region_analysis = df.groupby('Region').agg({
    'Units_Sold': 'mean',
    'Inventory_Level': 'mean',
    'Demand_Forecast': 'mean'
})

print("\nRegion Performance Analysis:")
print(region_analysis)

# SKU Performance Analysis

sku_analysis = df.groupby('SKU_ID').agg({
    'Units_Sold': 'sum',
    'Inventory_Level': 'mean',
    'Demand_Forecast': 'mean',
    'Order_Quantity': 'sum'
})

print("\nSKU Performance Analysis:")
print(sku_analysis)

# Profitability Analysis

df['Profit_Per_Unit'] = df['Unit_Price'] - df['Unit_Cost']

df['Total_Profit'] = df['Profit_Per_Unit'] * df['Units_Sold']

profit_analysis = df.groupby('SKU_ID').agg({
    'Profit_Per_Unit': 'mean',
    'Total_Profit': 'sum'
})

print("\nProfitability Analysis:")
print(profit_analysis)

print("\nTotal Business Profit:")
print(df['Total_Profit'].sum())

# Promotion Analysis

promotion_analysis = df.groupby('Promotion_Flag').agg({
    'Units_Sold': 'mean',
    'Total_Profit': 'mean',
    'Demand_Forecast': 'mean'
})

print("\nPromotion Analysis:")
print(promotion_analysis)

# Monthly Sales Trend Analysis

df['Month'] = df['Date'].dt.to_period('M')

monthly_sales = df.groupby('Month').agg({
    'Units_Sold': 'sum',
    'Total_Profit': 'sum',
    'Demand_Forecast': 'mean'
})

print("\nMonthly Sales Trend Analysis:")
print(monthly_sales)


# Correlation Analysis

correlation = df[[
    'Units_Sold',
    'Inventory_Level',
    'Supplier_Lead_Time_Days',
    'Reorder_Point',
    'Order_Quantity',
    'Unit_Cost',
    'Unit_Price',
    'Demand_Forecast',
    'Total_Profit'
]].corr()

print("\nCorrelation Analysis:")
print(correlation.round(2))


import matplotlib.pyplot as plt

# 1. Monthly Sales Trend
plt.figure(figsize=(10, 5))
plt.plot(monthly_sales.index.astype(str),
         monthly_sales['Units_Sold'],
         marker='o')

plt.title('Monthly Sales Trend')
plt.xlabel('Month')
plt.ylabel('Total Units Sold')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('monthly_sales_trend.png')
plt.show()


# 2. Warehouse Performance Chart

warehouse_analysis = df.groupby('Warehouse_ID')['Units_Sold'].sum()

plt.figure(figsize=(8, 5))
warehouse_analysis.plot(kind='bar')

plt.title('Warehouse-wise Sales Performance')
plt.xlabel('Warehouse')
plt.ylabel('Total Units Sold')
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig('warehouse_performance.png')
plt.show()

import matplotlib.pyplot as plt
import seaborn as sns

# 3. Region-wise Sales Performance

region_sales = df.groupby('Region')['Units_Sold'].sum()

plt.figure(figsize=(8, 5))
region_sales.plot(kind='bar')

plt.title('Region-wise Sales Performance')
plt.xlabel('Region')
plt.ylabel('Total Units Sold')
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig('region_performance.png')
plt.show()

# 4. Top 10 SKU Sales Performance
sku_sales = df.groupby('SKU_ID')['Units_Sold'].sum()

top_10_sku = sku_sales.sort_values(ascending=False).head(10)

plt.figure(figsize=(10, 5))
top_10_sku.plot(kind='bar')

plt.title('Top 10 SKU Sales Performance')
plt.xlabel('SKU ID')
plt.ylabel('Total Units Sold')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('top_10_sku_sales.png')
plt.show()


# 5. Demand Forecasting using Moving Average

print("\nDemand Forecasting Analysis:")

# Calculate daily total sales
daily_sales = df.groupby('Date')['Units_Sold'].sum().sort_index()

# Calculate 7-day Moving Average
moving_average = daily_sales.shift(1).rolling(window=7).mean()

# Display Forecast
forecast_df = pd.DataFrame({
    'Actual_Sales': daily_sales,
    'Moving_Average_Forecast': moving_average
})

print(forecast_df.tail(15))

# Save Forecast Results
forecast_df.to_csv("demand_forecasting_results.csv")

print("\nDemand Forecasting Results Saved Successfully!")


# 6. Forecast Accuracy Evaluation

from sklearn.metrics import mean_absolute_error, mean_squared_error
import numpy as np

# Remove missing forecast values
accuracy_df = forecast_df.dropna()

# Calculate MAE
mae = mean_absolute_error(
    accuracy_df['Actual_Sales'],
    accuracy_df['Moving_Average_Forecast']
)

# Calculate RMSE
rmse = np.sqrt(mean_squared_error(
    accuracy_df['Actual_Sales'],
    accuracy_df['Moving_Average_Forecast']
))

# Calculate MAPE
mape = (
    np.abs(
        (accuracy_df['Actual_Sales'] -
         accuracy_df['Moving_Average_Forecast']) /
        accuracy_df['Actual_Sales'].replace(0, np.nan)
    ).mean() * 100
)

print("\nForecast Accuracy Results:")
print("MAE:", round(mae, 2))
print("RMSE:", round(rmse, 2))
print("MAPE:", round(mape, 2), "%")


# 7. Demand Forecasting Visualization

plt.figure(figsize=(12, 6))

plt.plot(
    forecast_df.index,
    forecast_df['Actual_Sales'],
    label='Actual Sales'
)

plt.plot(
    forecast_df.index,
    forecast_df['Moving_Average_Forecast'],
    label='7-Day Moving Average Forecast'
)

plt.title('Actual Sales vs Demand Forecast')
plt.xlabel('Date')
plt.ylabel('Units Sold')

plt.legend()
plt.xticks(rotation=45)
plt.tight_layout()

plt.savefig('demand_forecasting_chart.png')
plt.show()

print("\nDemand Forecasting Chart Saved Successfully!")
