/*
ANALYSIS:
---------

- DimCustomer table in AdventureWorksDW2008 relates to FactInternetSales through 'CustomerKey'. 
  Thus, this population is not part of the current actual customers. 
  It has about 7819 distinct customers in the US

- The "Customer" table in AdventureWorks2008 schema is related to the "StateTerritory", "SalesOrderHeader" and "StateProvince" tables directly through TerritoryID.
  It has the maximum number of distinct customers, being directly related to sales

OBSERVATIONS:
------------  
-- # Total number of actual distinct customers
select count(distinct(C.CustomerID)) as "Distinct buyers"
From AdventureWorks2008R2.Sales.Customer as C; --19820

-- # Total distinct customer records in the US 
select count(distinct(C.CustomerID)) as "Distinct buyers"
From AdventureWorks2008R2.Sales.Customer as C
JOIN AdventureWorks2008R2.Person.StateProvince as SP
ON C.TerritoryID = SP.TerritoryID AND SP.CountryRegionCode='US'--8637 
JOIN AdventureWorksDW2008R2.dbo.DimGeography as DG
ON DG.StateProvinceCode = SP.StateProvinceCode ;-- 8637


-- # Total Distinct Postal codes
select count(distinct(DG.postalCode))
from AdventureWorksDW2008R2.dbo.DimGeography as DG
JOIN AdventureWorks2008R2.Person.StateProvince as SP
ON DG.StateProvinceCode = SP.StateProvinceCode and DG.CountryRegionCode='US'; -- 373

*/



Select 
  DG.PostalCode
, count(distinct(C.CustomerID)) as "Distinct buyers"
From AdventureWorks2008R2.Sales.Customer as C
JOIN AdventureWorks2008R2.Person.StateProvince as SP
ON SP.TerritoryID = C.TerritoryID AND SP.CountryRegionCode='US'
JOIN AdventureWorksDW2008R2.dbo.DimGeography as DG
ON DG.StateProvinceCode = SP.StateProvinceCode
group by
DG.PostalCode
order by 
count(distinct(C.CustomerID)) desc; -- 902919 (Customer IDs) 


/*

REASON FOR THE INCREASE IN COUNT:
--------------------------------
On analyzing the reason for the count of customer records increasing to '902919' from '8637' spead over 373 distinct postal codes, 
I found that most of the postal codes have multiple customer IDs. Meaning, the Customers are not unique per postal code.


-- # Customer IDs repeated over postal codes
select DG.PostalCode, C.CustomerID as "Customer ID"
From AdventureWorks2008R2.Sales.Customer as C
JOIN AdventureWorks2008R2.Person.StateProvince as SP
ON SP.TerritoryID = C.TerritoryID AND SP.CountryRegionCode='US'
JOIN AdventureWorksDW2008R2.dbo.DimGeography as DG
ON DG.StateProvinceCode = SP.StateProvinceCode


-- # Samples from theresult set of the previous query
PostalCode	Customer ID
83402	1
83501	1
83864	1
59101	1
59401	1
59801	1
98072	1
98901	1
82601	1
82001	1
89431	19551
97321	19551
83402	19552
83501	19552
89431	20703
97321	20703
83402	20704
83501	20704
89431	24758
97321	24758
83402	24760
83501	24760
*/