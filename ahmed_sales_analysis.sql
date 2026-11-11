use sample_sales;

--  Assigned Sales Territory: Maryland
--  Assigned Region: Northeast

-- 1. What is total revenue overall for sales in the assigned territory, plus the start date and end date
--    that tell you what period the data covers?

SELECT 	MIN(ss.Transaction_Date) AS StartDate,
		MAX(ss.Transaction_date) AS EndDate,
        FORMAT(SUM(ss.Sale_Amount), 2) AS TotalSales
FROM store_sales ss
WHERE ss.Store_ID IN (
	SELECT sl.StoreID
    FROM store_locations sl
	WHERE sl.State = 'Maryland');
    
-- 2. What is the revenue breakdown by year and month for the sales territory?

SELECT 	YEAR(ss.Transaction_Date) AS Year, 
		MONTH(ss.Transaction_Date) AS Month,
        FORMAT(SUM(ss.Sale_Amount), 2) AS TotalSales
FROM store_sales ss
WHERE ss.Store_ID IN (
	SELECT sl.StoreID
    FROM store_locations sl
    WHERE sl.State = 'Maryland')
    
    GROUP BY Year, Month 
    ORDER BY Year ASC, Month ASC;
    
-- 3. Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
--    Sales Territory: Maryland | Region: Northeast

SELECT 	FORMAT(SUM(ss.Sale_Amount), 2) AS NortheastSales,
		FORMAT(SUM(
			CASE 
				WHEN m.State = 'Maryland'
				THEN ss.Sale_Amount
				ELSE 0
			END), 2) AS MarylandSales
        
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreID
JOIN management m
	ON m.State = sl.State
WHERE m.Region = 'Northeast';

-- 4. What is the number of transactions per month and average transaction amount by product
--    category for the sales territory?

SELECT 	Year(ss.Transaction_Date) AS Year, 
        Month(ss.Transaction_Date) AS Month, 
        c.Category AS Category,
        Count(ss.id) AS TransactionsPerMonth,
        AVG(ss.Sale_Amount) AS AvgTransaction
        
FROM store_sales ss
JOIN store_locations sl
	ON sl.StoreID = ss.Store_ID
JOIN products p
	ON p.ProdNum = ss.Prod_Num
JOIN inventory_categories c
	ON c.Categoryid = p.Categoryid
WHERE sl.State = 'Maryland'
GROUP BY Year, Month, Category
ORDER BY Year ASC, Month ASC
LIMIT 1000;

-- 5. Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
--    ranking of online sales performance by state within an online sales territory?

SELECT 	ROW_NUMBER() OVER (ORDER BY SUM(ss.Sale_Amount) DESC) AS StoreRank,
		sl.StoreLocation AS Store,
        SUM(ss.Sale_Amount) AS TotalSales
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maryland'

GROUP BY Store
ORDER BY StoreRank ASC;
        
-- 6. What is your recommendation for where to focus sales attention in the next quarter?

-- Answer: 	My recommendation would be to focus the sales attention towards North Harford as this store is leading in TotalSales by a significant amount.
-- 			North Harford has $8.7 million TotalSales, with the second highest being around $580,000. This is a substantial difference so I would focus
-- 			on understanding what caused the high amount of sales in North Harford so we can potentially implement the same strategies to the rest of the Maryland stores.	
		







