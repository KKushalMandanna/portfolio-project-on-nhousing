select * from [portfolio projects].dbo.nhousing


--standartize the date format------------------------------------
select SaleDate, convert(date,saledate) as actualdate from [portfolio projects].dbo.nhousing

--populate the property address----------------------------------
select a.parcelID, a.propertyaddress,b.parcelID,b.propertyaddress from [portfolio projects]..nhousing a join
[portfolio projects]..nhousing b
on a.ParcelID = b.ParcelID 
and a.uniqueID <> b.UniqueID
--where a.propertyaddress = null
order by a.parcelid
 update a set  propertyaddress= ISnull(a.propertyaddress,b.propertyaddress) 
 from [portfolio projects]..nhousing a join
[portfolio projects]..nhousing b
on a.ParcelID = b.ParcelID 
and a.uniqueID <> b.UniqueID



  
