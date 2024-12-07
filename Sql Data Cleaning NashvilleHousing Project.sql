/* Cleaning Data */

select *
from Dataexplorationproject.dbo.[NashvilleHousing ]

--Standardize Date Format 

select SaleDate2 , CONVERT (Date,SaleDate)
from Dataexplorationproject.dbo.[NashvilleHousing ]

UPDATE [NashvilleHousing ]
SET SaleDate = CONVERT (Date,SaleDate)

ALTER TABLE [NashvilleHousing ]
Add SaleDate2 Date;

UPDATE [NashvilleHousing ]
SET SaleDate2 = CONVERT (Date,SaleDate)

--Populate Property Address data

select *
from Dataexplorationproject.dbo.[NashvilleHousing ]
--where PropertyAddress is NULL
Order by ParcelID

select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from Dataexplorationproject.dbo.[NashvilleHousing ] a
JOIN Dataexplorationproject.dbo.[NashvilleHousing ] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

UPDATE a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Dataexplorationproject.dbo.[NashvilleHousing ] a
JOIN Dataexplorationproject.dbo.[NashvilleHousing ] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

--Breaking out address into individual columnns(Address,city,state)

select 
SUBSTRING (PropertyAddress,1,CHARINDEX (',',PropertyAddress)-1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) +1,LEN(PropertyAddress)) as Address

from Dataexplorationproject.dbo.[NashvilleHousing ]


ALTER TABLE Dataexplorationproject.dbo.[NashvilleHousing ]
Add PropertySplitAddress Nvarchar(255);

UPDATE Dataexplorationproject.dbo.[NashvilleHousing ]
SET PropertySplitAddress = SUBSTRING (PropertyAddress,1,CHARINDEX (',',PropertyAddress)-1)

ALTER TABLE Dataexplorationproject.dbo.[NashvilleHousing ]
Add PropertySplitCity Nvarchar(255);

UPDATE Dataexplorationproject.dbo.[NashvilleHousing ]
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) +1,LEN(PropertyAddress))

select*
from Dataexplorationproject.dbo.[NashvilleHousing ]


select OwnerAddress
from Dataexplorationproject.dbo.[NashvilleHousing ]

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
from Dataexplorationproject.dbo.[NashvilleHousing ]
order by OwnerAddress desc

ALTER TABLE Dataexplorationproject.dbo.[NashvilleHousing ]
Add OwnerSplitAddress Nvarchar(255);

UPDATE Dataexplorationproject.dbo.[NashvilleHousing ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Dataexplorationproject.dbo.[NashvilleHousing ]
Add OwnerSplitCity Nvarchar(255);

UPDATE Dataexplorationproject.dbo.[NashvilleHousing ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Dataexplorationproject.dbo.[NashvilleHousing ]
Add OwnerSplitState Nvarchar(255);

UPDATE Dataexplorationproject.dbo.[NashvilleHousing ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--Change Y and N to YES and NO iN Sold as Vacant Field

select distinct (SoldAsVacant),COUNT(SoldAsVacant)
from Dataexplorationproject.dbo.[NashvilleHousing ]
Group by SoldAsVacant
Order by 2

select SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
 WHEN SoldAsVacant = 'N' THEN 'NO'
 ELSE SoldAsVacant
 END
from Dataexplorationproject.dbo.[NashvilleHousing ]
 
 UPDATE Dataexplorationproject.dbo.[NashvilleHousing ]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
 WHEN SoldAsVacant = 'N' THEN 'NO'
 ELSE SoldAsVacant
 END

 --Remove Duplicate
 WITH RownumCte AS(
 select*,
	ROW_NUMBER()OVER(
			PARTITION BY ParcelID,
			PropertyAddress,SaleDate,SalePrice,LegalReference
			ORDER BY UniqueID
				) row_num
from Dataexplorationproject.dbo.[NashvilleHousing ]

)	
DELETE
--Select*
from RownumCte
where row_num > 1


--Delete Unused Column

select*
from Dataexplorationproject.dbo.[NashvilleHousing ]


ALTER TABLE Dataexplorationproject.dbo.[NashvilleHousing ]
DROP COLUMN OwnerAddress,PropertyAddress,TaxDistrict

ALTER TABLE Dataexplorationproject.dbo.[NashvilleHousing ]
DROP COLUMN SaleDate