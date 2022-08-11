-- Cleaning the data
Select * 
From PortfolioProject2.dbo.Housing


-- Standardise Date 
Select SaleDate, CONVERT(date, SaleDate)
From PortfolioProject2.dbo.Housing

ALTER TABLE Housing
Add SaleDateFix date

Update Housing
Set SaleDateFix = CONVERT(date, SaleDate)

Select SaleDateFix
From PortfolioProject2.dbo.Housing


-- Fix Nulls in Property Address
Select * 
From PortfolioProject2.dbo.Housing
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress )
From PortfolioProject2.dbo.Housing a
Join PortfolioProject2.dbo.Housing b 
on a.ParcelID = b.ParcelID
And a.[UniqueID ] != b.[UniqueID ]

Where a.PropertyAddress is Null

Update a
Set PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress )
From PortfolioProject2.dbo.Housing a
Join PortfolioProject2.dbo.Housing b 
on a.ParcelID = b.ParcelID
And a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is Null

-- Breaking down address into columns(address, city , state)
Select PropertyAddress
From PortfolioProject2.dbo.Housing
-- using substring and Character address

Select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address2

ALTER TABLE Housing
Add PropertySplitAddress NVarchar(255);

Update Housing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) - 1) 

ALTER TABLE Housing
Add PropertyCity NVarchar(255);

Update Housing
Set PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) 

From PortfolioProject2.dbo.Housing


Select * 
From PortfolioProject2.dbo.Housing

-- Owner Address using Parsename

Select OwnerAddress
From PortfolioProject2.dbo.Housing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject2.dbo.Housing

ALTER TABLE Housing
Add OwnerAddressSplit NVarchar(255);

Update Housing
Set OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Housing
Add OwnerCity NVarchar(255);

Update Housing
Set OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Housing
Add OwnerState NVarchar(255);

Update Housing
Set OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject2.dbo.Housing

Select * 
From PortfolioProject2.dbo.Housing

-- Make SoldasVacant column Consistent

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject2.dbo.Housing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,

CASE When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant	
	 END

From PortfolioProject2.dbo.Housing

Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant	
	 END

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject2.dbo.Housing
Group by SoldAsVacant
Order by 2

--Removing Duplicates 


Select *
From PortfolioProject2.dbo.Housing

With RowNumCTE AS(
Select *, 
ROW_NUMBER() OVER(
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					) row_num

From PortfolioProject2.dbo.Housing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1

-- Deleting unused columns (old ones)

ALTER Table PortfolioProject2.dbo.Housing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


Select * 
From PortfolioProject2.dbo.Housing