CREATE DATABASE Supply_Chain_Analysis;
USE Supply_Chain_Analysis;
SELECT COUNT(*) AS Total_Rows
FROM supply_chain;
DESCRIBE supply_chain;
SELECT *
FROM supply_chain
LIMIT 10;

SELECT
    Date, SKU_ID, Warehouse_ID, Supplier_ID,
    Region, Units_Sold, Inventory_Level,
    Supplier_Lead_Time_Days, Reorder_Point,
    Order_Quantity, Unit_Cost, Unit_Price,
    Promotion_Flag, Stockout_Flag, Demand_Forecast,
    COUNT(*) AS Duplicate_Count
FROM supply_chain
GROUP BY
    Date, SKU_ID, Warehouse_ID, Supplier_ID,
    Region, Units_Sold, Inventory_Level,
    Supplier_Lead_Time_Days, Reorder_Point,
    Order_Quantity, Unit_Cost, Unit_Price,
    Promotion_Flag, Stockout_Flag, Demand_Forecast
HAVING COUNT(*) > 1;

USE Supply_Chain_Analysis;
DESCRIBE supply_chain;

ALTER TABLE supply_chain
CHANGE COLUMN `ï»¿Date` `Date` TEXT;

DESCRIBE supply_chain;

SELECT
    Date, SKU_ID, Warehouse_ID, Supplier_ID,
    Region, Units_Sold, Inventory_Level,
    Supplier_Lead_Time_Days, Reorder_Point,
    Order_Quantity, Unit_Cost, Unit_Price,
    Promotion_Flag, Stockout_Flag, Demand_Forecast,
    COUNT(*) AS Duplicate_Count
FROM supply_chain
GROUP BY
    Date, SKU_ID, Warehouse_ID, Supplier_ID,
    Region, Units_Sold, Inventory_Level,
    Supplier_Lead_Time_Days, Reorder_Point,
    Order_Quantity, Unit_Cost, Unit_Price,
    Promotion_Flag, Stockout_Flag, Demand_Forecast
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) - COUNT(Date) AS Missing_Date,
    COUNT(*) - COUNT(SKU_ID) AS Missing_SKU,
    COUNT(*) - COUNT(Warehouse_ID) AS Missing_Warehouse,
    COUNT(*) - COUNT(Supplier_ID) AS Missing_Supplier,
    COUNT(*) - COUNT(Region) AS Missing_Region,
    COUNT(*) - COUNT(Units_Sold) AS Missing_Units_Sold,
    COUNT(*) - COUNT(Inventory_Level) AS Missing_Inventory,
    COUNT(*) - COUNT(Supplier_Lead_Time_Days) AS Missing_Lead_Time,
    COUNT(*) - COUNT(Reorder_Point) AS Missing_Reorder_Point,
    COUNT(*) - COUNT(Order_Quantity) AS Missing_Order_Quantity,
    COUNT(*) - COUNT(Unit_Cost) AS Missing_Unit_Cost,
    COUNT(*) - COUNT(Unit_Price) AS Missing_Unit_Price,
    COUNT(*) - COUNT(Promotion_Flag) AS Missing_Promotion,
    COUNT(*) - COUNT(Stockout_Flag) AS Missing_Stockout,
    COUNT(*) - COUNT(Demand_Forecast) AS Missing_Forecast
FROM supply_chain;

SELECT
    MIN(STR_TO_DATE(Date, '%Y-%m-%d')) AS Start_Date,
    MAX(STR_TO_DATE(Date, '%Y-%m-%d')) AS End_Date,
    COUNT(DISTINCT SKU_ID) AS Total_SKUs,
    COUNT(DISTINCT Supplier_ID) AS Total_Suppliers,
    COUNT(DISTINCT Warehouse_ID) AS Total_Warehouses,
    COUNT(DISTINCT Region) AS Total_Regions
FROM supply_chain;

SELECT
    Supplier_ID,
    COUNT(*) AS Total_Records,
    SUM(Order_Quantity) AS Total_Order_Quantity,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS Avg_Lead_Time,
    ROUND(STDDEV_SAMP(Supplier_Lead_Time_Days), 2) AS Lead_Time_Variability,
    ROUND(AVG(Unit_Cost), 2) AS Avg_Unit_Cost
FROM supply_chain
GROUP BY Supplier_ID
ORDER BY Avg_Lead_Time ASC;

SELECT
    Supplier_ID,
    MIN(Supplier_Lead_Time_Days) AS Minimum_Lead_Time,
    MAX(Supplier_Lead_Time_Days) AS Maximum_Lead_Time,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS Average_Lead_Time
FROM supply_chain
GROUP BY Supplier_ID
ORDER BY Average_Lead_Time ASC;

SELECT
    SUM(Inventory_Level) AS Total_Inventory,
    ROUND(AVG(Inventory_Level), 2) AS Average_Inventory,
    MIN(Inventory_Level) AS Minimum_Inventory,
    MAX(Inventory_Level) AS Maximum_Inventory
FROM supply_chain;

SELECT
    SKU_ID,
    Warehouse_ID,
    Inventory_Level,
    Reorder_Point
FROM supply_chain
WHERE Inventory_Level <= Reorder_Point
ORDER BY Inventory_Level ASC;

SELECT
    SKU_ID,
    COUNT(*) AS Total_Records,
    SUM(Stockout_Flag) AS Stockout_Count
FROM supply_chain
GROUP BY SKU_ID
ORDER BY Stockout_Count DESC;

SELECT
    SKU_ID,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(AVG(Inventory_Level), 2) AS Average_Inventory,
    ROUND(
        SUM(Units_Sold) / NULLIF(AVG(Inventory_Level), 0),
        2
    ) AS Inventory_Turnover_Ratio
FROM supply_chain
GROUP BY SKU_ID
ORDER BY Inventory_Turnover_Ratio DESC;

SELECT
    Warehouse_ID,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Inventory_Level) AS Total_Inventory,
    SUM(Stockout_Flag) AS Total_Stockouts,
    COUNT(*) AS Total_Records
FROM supply_chain
GROUP BY Warehouse_ID
ORDER BY Total_Units_Sold DESC;

SELECT
    Region,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Inventory_Level) AS Total_Inventory,
    SUM(Order_Quantity) AS Total_Order_Quantity,
    SUM(Stockout_Flag) AS Total_Stockouts
FROM supply_chain
GROUP BY Region
ORDER BY Total_Units_Sold DESC;

SELECT
    DATE_FORMAT(
        STR_TO_DATE(Date, '%Y-%m-%d'), '%Y-%m'
    ) AS Month,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(Demand_Forecast), 2) AS Total_Forecast
FROM supply_chain
GROUP BY Month
ORDER BY Month;

SELECT
    SKU_ID,
    SUM(Units_Sold) AS Actual_Demand,
    ROUND(SUM(Demand_Forecast), 2) AS Forecast_Demand,
    ROUND(
        SUM(Units_Sold) - SUM(Demand_Forecast), 2
    ) AS Demand_Variance
FROM supply_chain
GROUP BY SKU_ID
ORDER BY ABS(Demand_Variance) DESC;

SELECT
    Promotion_Flag,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(AVG(Units_Sold), 2) AS Average_Units_Sold,
    COUNT(*) AS Total_Records
FROM supply_chain
GROUP BY Promotion_Flag;

SELECT
    Supplier_ID,
    SUM(Order_Quantity) AS Total_Order_Quantity,
    ROUND(
        SUM(Order_Quantity * Unit_Cost), 2
    ) AS Total_Procurement_Cost,
    ROUND(AVG(Unit_Cost), 2) AS Average_Unit_Cost
FROM supply_chain
GROUP BY Supplier_ID
ORDER BY Total_Procurement_Cost DESC;

SELECT
    SKU_ID,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(
        SUM(Units_Sold * Unit_Price), 2
    ) AS Total_Revenue
FROM supply_chain
GROUP BY SKU_ID
ORDER BY Total_Revenue DESC;

SELECT
    SKU_ID,
    ROUND(
        SUM(Units_Sold * Unit_Price), 2
    ) AS Sales_Value,
    ROUND(
        SUM(Units_Sold * Unit_Cost), 2
    ) AS Estimated_Cost,
    ROUND(
        SUM(Units_Sold * (Unit_Price - Unit_Cost)), 2
    ) AS Estimated_Gross_Profit
FROM supply_chain
GROUP BY SKU_ID
ORDER BY Estimated_Gross_Profit DESC;

















