use sample_sales;

--  Assigned Sales Territory: Maryland
--  Assigned Region: Northeast

SELECT * FROM inventory_categories;
SELECT * FROM inventory_subcategories;
SELECT * FROM management;
SELECT * FROM online_sales;
SELECT * FROM products;
SELECT * FROM shipper_list;
SELECT * FROM store_locations; 
SELECT * FROM store_sales;

SELECT Region FROM management WHERE State = 'Maryland';

-- 1. Total Revenue Collected from Maryland In-store and online orders shipped to Maryland.

SELECT 	MIN(StartDate) AS StartDate, 
		MAX(EndDate) AS EndDate, 
        SUM(TotalRevenue) AS TotalRevenue
FROM ( 
	SELECT 
		MIN(ss.Transaction_Date) AS StartDate, 
		MAX(ss.Transaction_Date) AS EndDate, 
		SUM(ss.Sale_Amount) AS TotalRevenue
	FROM store_sales ss
	WHERE ss.Store_ID IN (
		SELECT sl.StoreID
		FROM store_locations sl
		WHERE sl.State = 'Maryland')

	UNION ALL

	SELECT 	MIN(os.Date) AS StartDate,
			MAX(os.Date) AS EndDate,
			SUM(os.SalesTotal) AS TotalRevenue
	FROM online_sales os
	WHERE os.ShiptoState = 'Maryland') AS CombinedSales;


-- 2. What is the revenue breakdown by year and month for both the sales territory, along with online_orders shipped to that state?

SELECT 	Year,
		Month, 
        SUM(TotalRevenue) AS TotalRevenue
FROM (
	SELECT 	
		YEAR(ss.Transaction_Date) AS Year, 
		MONTH(ss.Transaction_Date) AS Month, 
        ss.Sale_Amount AS TotalRevenue
	FROM store_sales ss
	WHERE ss.Store_ID IN (
		SELECT sl.StoreID
		FROM store_locations sl
		WHERE sl.State = 'Maryland')
    
    UNION ALL 
	
    SELECT 	YEAR(os.Date) AS Year,
			MONTH(os.Date) AS Month,
            os.SalesTotal AS TotalRevenue
	FROM online_sales os
    WHERE os.ShiptoState = 'Maryland') AS CombinedRevenue
    
    GROUP BY Year, Month
    ORDER BY Year ASC, Month ASC;

SELECT * FROM management WHERE State = 'Maryland';
		


