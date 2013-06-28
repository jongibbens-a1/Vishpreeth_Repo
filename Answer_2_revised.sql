/*
ANALYSIS:
--------

1) "SalesOrderDetail" (SOD) table has=> 

- Distinct count(sales Order ID) = 31465,

- each salesorderID has multiple entries, 

- LineTotal of SOD is equal to sub total of SOH. (Explained later)


2) "SalesOrderHeader" (SOH) table has=> 

Count(*) = 31465 (Since SalesorderID here is the PK, all records are distinct, unique and not null)



3) 'AVERAGE TRANSACTION VALUE' (ATV) is calculated based on the references mentioned below:
   ---------------------------------------------------------------------------------------
Revenue = Unit Price * quantity

Transaction total = Revenue + Tax + shipping

ATV = Transaction total/no. of Transactions


4) REFERENCE:
  ----------

https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce

Revenue: An important metric for any ecommerce business. This specifies he total revenue associated with the transaction. This value should include any shipping and tax costs.
*/



-- Note: The "TotalDue" column of the SOH table is the sum of [SubTotal] + [TaxAmt] + [Freight]
-- The purpose of using SOH over SOD is because of the reason mentioned above. That is, SOD's "LineTotal" values are equal to just SOH's "SubTotal" and does not include the 'Tax' and 'Freight' charges

--ANSWER:
Select AVG(SOH.TotalDue) as "Average Txn Value"
, DG.PostalCode as "Postal Code" 
From AdventureWorks2008R2.Sales.SalesOrderHeader as SOH
Join AdventureWorks2008R2.Person.StateProvince as SP
On SOH.TerritoryID = SP.TerritoryID AND SP.CountryRegionCode='US'
Join AdventureWorksDW2008R2.dbo.DimGeography as DG
On DG.StateProvinceCode = SP.StateProvinceCode
Group By DG.PostalCode;
