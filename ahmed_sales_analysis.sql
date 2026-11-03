use sample_sales;

-- Sales Territory: Maryland

-- 1. What is total revenue overall for sales in the assigned territory, plus the start date and end date
-- that tell you what period the data covers?

SELECT 	MIN(StartDate) AS StartDate, 
		MAX(EndDate) AS EndDate, 
        SUM(TotalRevenue) AS TotalRevenue
FROM ( 
	SELECT 
		MIN(Transaction_Date) AS StartDate, 
		MAX(Transaction_Date) AS EndDate, 
		SUM(Sale_Amount) AS TotalRevenue
	FROM store_sales
	WHERE Store_ID IN (
		SELECT StoreID
		FROM store_locations
		WHERE State = 'Maryland')

	UNION ALL

	SELECT 	MIN(Date) AS StartDate,
			MAX(Date) AS EndDate,
			SUM(SalesTotal) AS TotalRevenue
	FROM online_sales
	WHERE ShiptoState = 'Maryland') AS CombinedSales;


-- 2. What is the revenue breakdown by year and month for the sales territory?
