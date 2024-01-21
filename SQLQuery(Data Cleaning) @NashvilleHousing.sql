/*

Cleaning Data in SQL Queries

*/

Select*
From PortfolioProject.dbo.NashvilleHousing


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

----------------------------------------------------------------------------------------------------------------------------------

--Populate Property Address data

Select*
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is Null
order by ParcelID

Select a.ParcelID , a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID<> b.UniqueID
  where a. PropertyAddress is null


  Update a
  SET PropertyAddress=  ISNULL(a.PropertyAddress,b.PropertyAddress)
  From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID<> b.UniqueID
   where a. PropertyAddress is null


   ----------------------------------------------------------------------------------------------------------------------------------------------------

   ---Breaking out Address into Individual Columns (Address,City,State)

   Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is Null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress,1 ,CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1 ,CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))


Select*
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select*
From PortfolioProject.dbo.NashvilleHousing


----------------------------------------------------------------------------------------------------------------------------------------------------------


---Change Y and N to Yes and No in Sold as Vacant Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
,Case  When SoldAsVacant ='Y' Then 'Yes'
       When SoldAsVacant ='N' Then 'No'
	   Else SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant= Case  When SoldAsVacant ='Y' Then 'Yes'
       When SoldAsVacant ='N' Then 'No'
	   Else SoldAsVacant
	   END


--------------------------------------------------------------------------------------------------------------------------------------	   ---------------

---Remove Duplicates

WITH RowNumCTE AS(
Select*,
ROW_NUMBER() OVER(
Partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
			    UniqueID
				)row_num

From PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
Select*
From RowNumCTE
Where row_num>1
--Order by PropertAddress


Select*
From PortfolioProject.dbo.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------------------------------------------------

---Delete Unused Columns

Select*
From PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate


