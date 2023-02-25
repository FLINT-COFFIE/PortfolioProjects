
-- Cleaning Data in Sql 

Select *
From PortfolioProject..Nashville_Housing


--Changing SaleDatetime to SaleDate

Select SaleDateConverted
From PortfolioProject..Nashville_Housing

Alter Table Nashville_Housing
Add SaleDateConverted Date;

UPDATE Nashville_Housing
SET SaleDateConverted = CONVERT(Date,SaleDate);



--Populate Null Property Address Data With the same ParcelID 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..Nashville_Housing a
Join PortfolioProject..Nashville_Housing b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null
--Order By ParcelID


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..Nashville_Housing a
Join PortfolioProject..Nashville_Housing b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]


--Breaking Address into Separate Columns (City,State)

SELECT
SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',',PropertyAddress) - 1) as  Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as  Address

From PortfolioProject..Nashville_Housing 



Alter Table Nashville_Housing
Add PropertySplitAddress Nvarchar(255);

UPDATE Nashville_Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',',PropertyAddress) - 1)



Alter Table Nashville_Housing
Add PropertySplitCity Nvarchar(255);

UPDATE Nashville_Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))



SELECT PropertySplitAddress,PropertySplitCity

From PortfolioProject..Nashville_Housing 



SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,
PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject..Nashville_Housing 
--where OwnerAddress is not null





Alter Table Nashville_Housing
Add OwnerSplitAddress Nvarchar(255);

UPDATE Nashville_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


Alter Table Nashville_Housing
Add OwnerSplitCity Nvarchar(255);

UPDATE Nashville_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)



Alter Table Nashville_Housing
Add OwnerSplitState Nvarchar(255);

UPDATE Nashville_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)




--Changing Y and N to Yes and No in Sold as Vacant

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From Nashville_Housing
Group By SoldAsVacant
Order By 2




Select Distinct(SoldAsVacant)
,CASE When SoldAsVacant = 'N' Then 'No'
	  When SoldAsVacant = 'Y' Then 'Yes'
	  Else SoldAsVacant
	  End
From Nashville_Housing


Update Nashville_Housing
SET SoldAsVacant =
CASE When SoldAsVacant = 'N' Then 'No'
	  When SoldAsVacant = 'Y' Then 'Yes'
	  Else SoldAsVacant
	  End



--Remove Duplicates 


WITH ROW_NUMCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) row_num
From Nashville_Housing

)

DELETE 
FROM ROW_NUMCTE
WHERE row_num >1
--Order By PropertyAddress



--REMOVING OLD SPLIT COLUMNS


SELECT *
FROM PortfolioProject..Nashville_Housing


ALTER TABLE PortfolioProject..Nashville_Housing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress