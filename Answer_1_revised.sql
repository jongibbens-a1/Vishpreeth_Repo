/*
ANALYSIS:
---------

- DimCustomer table in AdventureWorksDW2008 relates to FactInternetSales through 'CustomerKey'. 
  Thus, this population is not part of the current actual customers. 
  It has about 7819 distinct customers in the US

- The "Customer" table in AdventureWorks2008 schema is related to the "StateTerritory", "SalesOrderHeader" and "StateProvince" tables directly through TerritoryID.
  It has the maximum number of distinct customers, being directly related to sales


select count(distinct(C.CustomerID)) as "Distinct buyers"
From AdventureWorks2008R2.Sales.Customer as C; --19820


select count(distinct(C.CustomerID)) as "Distinct buyers"
From AdventureWorks2008R2.Sales.Customer as C
JOIN AdventureWorks2008R2.Person.StateProvince as SP
ON C.TerritoryID = SP.TerritoryID AND SP.CountryRegionCode='US'--8637 
JOIN AdventureWorksDW2008R2.dbo.DimGeography as DG
ON DG.StateProvinceCode = SP.StateProvinceCode ;-- 8637


select count(distinct(DG.postalCode))
from AdventureWorksDW2008R2.dbo.DimGeography as DG
JOIN AdventureWorks2008R2.Person.StateProvince as SP
ON DG.StateProvinceCode = SP.StateProvinceCode and DG.CountryRegionCode='US'; -- 373

*/




select count(distinct(C.CustomerID)) as "Distinct buyers"
, DG.PostalCode 
From AdventureWorks2008R2.Sales.Customer as C
JOIN AdventureWorks2008R2.Person.StateProvince as SP
ON SP.TerritoryID = C.TerritoryID AND SP.CountryRegionCode='US'
JOIN AdventureWorksDW2008R2.dbo.DimGeography as DG
ON DG.StateProvinceCode = SP.StateProvinceCode AND DG.CountryRegionCode='US'
group by
DG.PostalCode
order by
DG.PostalCode;