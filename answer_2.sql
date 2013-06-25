---- The average amount of transactions in the US, per postal code

/*
The following query returns the average number and amount of transactions in the US, per postal code using the following relationships:
- 'StateProvinceCode' between dbo.DimGeography and [Person].[StateProvince] 
- 'TerritoryId' between [Person].[StateProvince] and [Sales].[SalesOrderHeader] 
- 'SalesOrderID' between [Sales].[SalesOrderHeader]  and [Sales].[SalesOrderDetail] 
- 'ProductID' between [Sales].[SalesOrderDetail]  and [Production].[Product] 
- 'ProductID' between  [Production].[Product] and [Production].[TransactionHistory]
*/

select DG.PostalCode
, AVG(TH.Quantity) as "Average number of transactions"
, AVG(TH.ActualCost) as "Average amount of transactions"
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


