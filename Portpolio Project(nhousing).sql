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
--Breaking out address into individual coloumns(address, city, date)
select PropertyAddress from [portfolio projects].dbo.nhousing

select 
substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) as address,
substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1  ,len(propertyaddress)) as address
from [portfolio projects].dbo.nhousing

alter table [portfolio projects].dbo.nhousing
add propertysplitaddress nvarchar(255)

update [portfolio projects].dbo.nhousing set
 propertysplitaddress =substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) 

 alter table [portfolio projects].dbo.nhousing
add propertysplitcity nvarchar(255)

update [portfolio projects].dbo.nhousing set
 propertysplitcity =substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1  ,len(propertyaddress))

 select owneraddress from [portfolio projects].dbo.nhousing
 --breaking out tthe owner address into coloumns(address, city,area)

 select 
PARSENAME(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from [portfolio projects].dbo.nhousing

alter table  [portfolio projects].dbo.nhousing
add ownersplitaddress nvarchar(255)
update [portfolio projects].dbo.nhousing set
ownersplitaddress = PARSENAME(replace(owneraddress,',','.'),3)


alter table[portfolio projects].dbo.nhousing
add ownersplitcity nvarchar(255)
update [portfolio projects].dbo.nhousing
set ownersplitcity = PARSENAME(replace(owneraddress,',','.'),2)

alter table[portfolio projects].dbo.nhousing
add ownersplitstate nvarchar(255)
update [portfolio projects].dbo.nhousing
set ownersplitstate = PARSENAME(replace(owneraddress,',','.'),1)


select * from [portfolio projects].dbo.nhousing

---change Y and N to YES and NO in "Sold as vacant" field

 select  distinct('soldasvacent') , count ('soldasvacent')from [portfolio projects].dbo.nhousing
 group by SoldAsVacant
 order by 2


 select 'soldasvacent',
 case when 'soldasvacent' = 'Y' then 'yes'
 when 'soldasvacent'= 'N' then 'No'
 else 'soldasvacent'
 end
 from [portfolio projects].dbo.nhousing


 update [portfolio projects].dbo.nhousing
 set 'soldasvacent' = case when 'soldasvacent' = 'Y' then 'yes'
 when 'soldasvacent'= 'N' then 'No'
 else 'soldasvacent'
 end


 --remove duplicates
 with rownumCTE as (
 select *, 
 ROW_NUMBER() over(
 partition by parcelid,propertyaddress,saleprice,saledate,legalreference order by uniqueid)row_num
 from [portfolio projects].dbo.nhousing
 )
 select * from rownumCTE where row_num>1
 order by PropertyAddress


-- delete unused coloumns

select * from [portfolio projects].dbo.nhousing
alter table [portfolio projects].dbo.nhousing
drop column  owneraddress, taxdistrict, propertyaddress



  
