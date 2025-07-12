--Ceaning Data--

Select SaleDateConverted, CONVERT(Date,SaleDate)
from NashvielHousing..NashvielHouse

update NashvielHouse
Set SaleDate = CONVERT(Date,SaleDate)

Alter table NashvielHouse
Add SaleDateConverted Date

update NashvielHouse
SET SaleDateConverted = CONVERT(Date, SaleDate)


---Populate Property Address data

Select *
from NashvielHousing..NashvielHouse
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)--If a. property address is empty, then reblace with b.property
from NashvielHousing..NashvielHouse a
Join NashvielHousing..NashvielHouse b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvielHousing..NashvielHouse a
Join NashvielHousing..NashvielHouse b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null


--Breaking out Address Into Individual Columns(Address, City, State)

Select PropertyAddress
from NashvielHousing..NashvielHouse
--where PropertyAddress is null
--order by ParcelID

Select Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
from NashvielHousing..NashvielHouse


Alter table NashvielHousing..NashvielHouse
Add PropertySplitAddress Nvarchar(255)

update NashvielHousing..NashvielHouse
SET PropertySplitAddress = Substring(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) 


Alter table NashvielHousing..NashvielHouse
Add PropertySplitCity Nvarchar(255)

update NashvielHousing..NashvielHouse
SET PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 








Select
PARSENAME(Replace(OwnerAddress,',','.'),1),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),3)
from NashvielHousing..NashvielHouse


Alter table NashvielHousing..NashvielHouse
Add OwnerSplitAddress Nvarchar(255)

update NashvielHousing..NashvielHouse
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3) 



Alter table NashvielHousing..NashvielHouse
Add OwnerSplitCity Nvarchar(255)

update NashvielHousing..NashvielHouse
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2) 



Alter table NashvielHousing..NashvielHouse
Add OwnerSplitState Nvarchar(255)

update NashvielHousing..NashvielHouse
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)



--Change Y and N to Yes And No in Sold as Vacant field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
from NashvielHousing..NashvielHouse
group by SoldAsVacant
order by SoldAsVacant

Select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from NashvielHousing..NashvielHouse

update NashvielHousing..NashvielHouse
Set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end



--Remove Duplicates
With ROWNUMCTE AS ( 

Select *,
	ROW_NUMBER() OVER(
	Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
				ORDER BY
					UniqueID
				) row_num
from NashvielHousing..NashvielHouse
--order by ParcelID
)

--DELETE
--from ROWNUMCTE
--WHERE row_num > 1

Select *
from ROWNUMCTE
WHERE row_num > 1
order by PropertyAddress




--Delete Unused Columns

Select * 
from NashvielHousing..NashvielHouse


Alter table NashvielHousing..NashvielHouse
Drop column OwnerAddress, TaxDistrict, PropertyAddress


Alter table NashvielHousing..NashvielHouse
Drop column SaleDate






 


