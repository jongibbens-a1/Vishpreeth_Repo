select 
  DG.PostalCode
, AVG(TH.ActualCost) 
from [AdventureWorksDW2008R2].dbo.DimGeography as DG 
JOIN [AdventureWorks2008R2].[Person].[StateProvince] as SP 
ON DG.StateProvinceCode=SP.StateProvinceCode AND SP.CountryRegionCode='US'
JOIN [AdventureWorks2008R2].[Sales].[SalesOrderHeader] as SOH
ON SOH.TerritoryID=SP.TerritoryID 
JOIN [AdventureWorks2008R2].[Sales].[SalesOrderDetail] as SOD
ON SOD.SalesOrderDetailID = SOH.SalesOrderID
JOIN [AdventureWorks2008R2].[Production].[Product] as P
ON P.ProductID=SOD.ProductID
JOIN [AdventureWorks2008R2].[Production].[TransactionHistory] as TH
ON TH.ProductID = P.ProductID group by DG.PostalCode;
