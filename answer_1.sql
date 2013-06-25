---- The number of distinct buyers in the US, per postal code 
---- Answer: 
SELECT count(distinct(pb.ProspectAlternateKey)) as "Distinct buyers", pb.PostalCode 
FROM [AdventureWorksDW2008R2].[dbo].[ProspectiveBuyer] as pb
where 1=1 and exists 
(
select 1 from [AdventureWorksDW2008R2].[dbo].DimGeography as dg 
where dg.StateProvinceCode = pb.StateProvinceCode AND dg.CountryRegionCode='US'
)
group by pb.PostalCode; ---- A total of 2051 records (exclusing the duplicates in the ProspectiveBuyers table and the ones that are not in the US)

/* 
- The above query returns the actual number of distinct buyers in the US per postal code identified using 'ProspectAlternateKey' instead of 'ProspectBuyerKey' because 'ProspectBuyerKey' is unique and can't be used to identify distinct records 
- Also, the reason for using 'StateProvinceCode' instead of 'PostalCode' (as in Exhibit A, below) to  find the distinct buyers is because, the postalcodes were found NOT to be unique to the US (refer Exhibit B)
- Made use of 'Exists' instead of 'IN/NOT IN' because Exists performs better than IN/Not IN

*/


---- Alternative solution: Not considered
---- Exhibit A: Distinct Buyers based on postal code
SELECT count(distinct [ProspectAlternateKey]) as "Total Distinct Buyers" , pb.PostalCode
FROM [AdventureWorksDW2008R2].[dbo].[ProspectiveBuyer] as pb 
where 1=1 
and exists 
(
select null from [AdventureWorksDW2008R2].[dbo].DimGeography as dg 
where dg.PostalCode = pb.PostalCode
AND dg.CountryRegionCode='US'
)
group by 
pb.PostalCode; -- A total of 1977 records


---- Exhibit B: Postal codes common between countries
SELECT pb.StateProvinceCode as "PB_StateProvinceCode"
, pb.PostalCode as "PB_PostalCode"
, dg.StateProvinceCode as "DG_StateProvinceCode"
, dg.PostalCode  as "DG_PostalCode" 
FROM [AdventureWorksDW2008R2].[dbo].[ProspectiveBuyer] as pb 
join [AdventureWorksDW2008R2].[dbo].DimGeography as dg 
on pb.PostalCode =dg.PostalCode AND dg.CountryRegionCode!='US';

/* ---- Output to Exhibit B
PB_StateProvinceCode   PB_PostalCode    DG_StateProvinceCode  DG_PostalCode
MA                       2113             NSW                  2113
TX                       75006             75                  75006
TX                       75006             75                  75006
*/