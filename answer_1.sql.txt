SELECT 
  count(distinct(PB.ProspectAlternateKey)) "Distinct buyers"
, PB.PostalCode 
FROM [AdventureWorksDW2008R2].[dbo].[ProspectiveBuyer] as PB 
where exists 
(
	select 1 from [AdventureWorksDW2008R2].[dbo].DimGeography as DG 
	where DG.StateProvinceCode = PB.StateProvinceCode AND DG.CountryRegionCode='US'
)
group by PB.PostalCode;
