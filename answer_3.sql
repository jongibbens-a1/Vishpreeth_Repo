select 
(SOD.OrderQty * SOD.UnitPrice) as 'Revenue per order'
, DG.PostalCode
from AdventureWorks2008R2.SALES.SalesOrderDetail SOD
JOIN [AdventureWorks2008R2].[Sales].[SalesOrderHeader] as SOH
ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN [AdventureWorks2008R2].[Person].[StateProvince] as SP
ON SP.TerritoryID=SOH.TerritoryID
JOIN [AdventureWorksDW2008R2].dbo.DimGeography as DG 
ON DG.StateProvinceCode=SP.StateProvinceCode AND SP.CountryRegionCode='US'
group by 
(SOD.OrderQty * SOD.UnitPrice)
, DG.PostalCode;