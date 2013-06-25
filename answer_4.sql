---- The most popular product category (the top level in the product hierarchy) in the US based on postal codes

/*
The following query returns the most popular (TOP 1) product category in the US based on postal codes using the following relationships:

- 'SalesOrderID' between [Sales].[SalesOrderDetail] and [Sales].[SalesOrderHeader]
- 'TerritoryId' between Sales].[SalesOrderHeader] and [Person].[StateProvince]
- 'StateProvinceCode' between Person].[StateProvince] and dbo.DimGeography
- 'ProductID' between [Sales].[SalesOrderDetail]  and [Production].[Product] 
- 'ProductSubcategoryID' between  [Production].[Product] and dbo.DimProductSubcategory
- 'ProductCategoryKey' between dbo.DimProductSubcategory and dbo.DimProductCategory
*/

select TOP 1 PCAT.EnglishProductCategoryName, DG.PostalCode, COUNT(SOD.OrderQty) as orderqty
from AdventureWorks2008R2.SALES.SalesOrderDetail as SOD 
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
order by 
count(SOD.OrderQty) desc;


