select TOP 1 
  PCAT.EnglishProductCategoryName
, DG.PostalCode
, COUNT(SOD.OrderQty) as orderqty
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
order by 
count(SOD.OrderQty) desc;
