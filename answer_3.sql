---- The 'Total Revenue' in the US, per postal code 
 
 /* 'Total Revenue' is generated based on the following defnition: Total revenue is the total receipts of a firm from the sale of any given quantity of a product.
It can be calculated as the selling price of the firm's product times the quantity sold, i.e. total revenue = price × quantity, or letting TR be the total revenue function: 
where Q is the quantity of output sold, and P(Q) is the inverse demand function (the demand function solved out for price in terms of quantity demanded)

Net and Gross Income will eventually be calculated from Total Revenue after subtracting all the production costs or expenses incurred and the tax amount.
 */

 
/*
Hence excluding all the costs or expenses involved, the following query simply returns the 'Total Revenue' in the US, per postal code using the following relationships:
- 'SalesOrderID' between [Sales].[SalesOrderHeader]  and [Sales].[SalesOrderDetail] 
- 'TerritoryId' between [Sales].[SalesOrderHeader] and [Person].[StateProvince]
- 'StateProvinceCode' between [Person].[StateProvince] and dbo.DimGeography
*/

select 
(SOD.OrderQty * SOD.UnitPrice) as "Total Revenue"
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

/*
---- Another table to consider: 
FactInternetSales has 'UnitPrice', 'OrderQuantity' and 'SalesAmount' (which is actually the result of (UnitPrice * OrderQuantity) in that table) columns as well. 
But then, FactInternetSales cannot contribute to TotalRevenue and also, 'SalesOrderDetail' contains the superset of all the salesorders and the related information. 
*/