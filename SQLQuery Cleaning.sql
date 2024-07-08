Select * 
From Test..NashvilleHousingData



--Replace NULL PropertyAddress by same ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Test..NashvilleHousingData a
JOIN Test..NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is NULL

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Test..NashvilleHousingData a
JOIN Test..NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]



--Check PropetyAddress
Select * 
From Test..NashvilleHousingData
Where PropertyAddress is Null



--Spilt PropertyAddress
SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS PropertyAddress,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 ,LEN(PropertyAddress)) AS PropertyCity
FROM Test..NashvilleHousingData

ALTER Table Test..NashvilleHousingData
Add SplitPropertyAddress Nvarchar(255)

Update Test..NashvilleHousingData
Set SplitPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

-------------------------------------------------------------------

ALTER Table Test..NashvilleHousingData
Add PropertyCity Nvarchar(255)

Update Test..NashvilleHousingData
Set PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 ,LEN(PropertyAddress))

Select * 
From Test..NashvilleHousingData
Order by ParcelID


--Split OwnerAddress Use SUBSTRING

SELECT 
    SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress) - 1) AS OwnerQ,
    SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress) + 2, CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1) - CHARINDEX(',', OwnerAddress) - 2) AS OwnerR,
    SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1) + 2, LEN(OwnerAddress) - CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1) - 1) AS OwnerT
FROM Test..NashvilleHousingData


--Split OwnerAddress Use PARSENAME

SELECT PARSENAME(Replace(OwnerAddress, ',' ,'.'), 3),PARSENAME(Replace(OwnerAddress, ',' ,'.'), 2),PARSENAME(Replace(OwnerAddress, ',' ,'.'), 1)
FROM Test..NashvilleHousingData

ALTER Table Test..NashvilleHousingData
Add SplitOnwerAddress Nvarchar(255)

Update Test..NashvilleHousingData
Set SplitOnwerAddress = PARSENAME(Replace(OwnerAddress, ',' ,'.'), 3)

ALTER Table Test..NashvilleHousingData
Add OwnerCity Nvarchar(255)

Update Test..NashvilleHousingData
Set OwnerCity = PARSENAME(Replace(OwnerAddress, ',' ,'.'), 2)

ALTER Table Test..NashvilleHousingData
Add OwnerState Nvarchar(255)

Update Test..NashvilleHousingData
Set OwnerState = PARSENAME(Replace(OwnerAddress, ',' ,'.'), 1)

Select *
FROM Test..NashvilleHousingData


--Remove Duplicate
WITH CTE as(
Select *, ROW_NUMBER() OVER(Partition by ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference order by UniqueID)row_num
FROM Test..NashvilleHousingData
)
--Delete
--from CTE
--Where row_num >1

Select *
from CTE
Where row_num >1


--SELECT ParcelID, PropertyAddress, SaleDate, SalePrice,LegalReference, COUNT(*)
--FROM Test..NashvilleHousingData
--GROUP BY ParcelID, PropertyAddress, SaleDate, SalePrice,LegalReference
--Order by ParcelID
--HAVING COUNT(*) > 1

Select * 
From Test..NashvilleHousingData


--Update SaleDate and drop SaleDate
Select SaleDate, CONVERT(date,SaleDate) as SaleDate
From Test..NashvilleHousingData

ALTER Table Test..NashvilleHousingData
Add SaleDateShort date

Update Test..NashvilleHousingData
Set SaleDateShort = CONVERT(date,SaleDate)

ALTER TABLE Test..NashvilleHousingData
DROP COLUMN SaleDate

Select * 
From Test..NashvilleHousingData
Order by ParcelID

--Delete Column
ALTER TABLE Test..NashvilleHousingData
DROP COLUMN PropertyAddress,OwnerAddress


--Change Value in SoldAsVacant is y and n to Yes and No
Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Test..NashvilleHousingData
Group by SoldAsVacant

Select SoldAsVacant, case when SoldAsVacant = 'Y' then 'Yes' when SoldAsVacant = 'N' then 'No' else SoldAsVacant end
From Test..NashvilleHousingData

Update Test..NashvilleHousingData
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes' when SoldAsVacant = 'N' then 'No' else SoldAsVacant end