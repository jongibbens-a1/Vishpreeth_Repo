/*
I have modified the original query by making use of:

-- Row_Number() Over (Partition by 'partition_column' order by 'order by clause') to rank the highest within each postal code
-- Subquery to pull out the final result set with the best product category for each and every zipcode

*/

--ANSWER:
select 
subQuery.PostalCode as "Postal Code"
, subQuery.EnglishProductCategoryName as "Product Category Name"
, subQuery.OrderQty as "Order Quantity"
from 
(Select
	 PCAT.EnglishProductCategoryName
	 , DG.PostalCode
	 , COUNT(SOD.OrderQty) as orderqty
	 , row_number() over (partition by DG.PostalCode order by COUNT(SOD.OrderQty) desc) as row_num
from AdventureWorks2008R2.SALES.SalesOrderDetail SOD
JOIN [AdventureWorks2008R2].[Sales].[SalesOrderHeader] as SOH
ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN [AdventureWorks2008R2].[Person].[StateProvince] as SP
ON SP.TerritoryID = SOH.TerritoryID
JOIN [AdventureWorksDW2008R2].dbo.DimGeography as DG 
ON DG.StateProvinceCode=SP.StateProvinceCode AND SP.CountryRegionCode='US'
JOIN AdventureWorks2008R2.Production.Product as P
ON SOD.ProductID = P.ProductID 
JOIN AdventureWorksDW2008R2.dbo.DimProductSubcategory as PSUB
ON PSUB.ProductSubcategoryKey = P.ProductSubcategoryID
JOIN AdventureWorksDW2008R2.dbo.DimProductCategory as PCAT
ON PCAT.ProductCategoryKey = PSUB.ProductCategoryKey
group by 
PCAT.EnglishProductCategoryName
,DG.PostalCode
) as subQuery 
JOIN [AdventureWorksDW2008R2].dbo.DimGeography as DG 
ON subQuery.PostalCode=DG.PostalCode 
where row_num=1 
order by subQuery.PostalCode;