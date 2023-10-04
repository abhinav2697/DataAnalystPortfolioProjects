/*

Cleaning Data in SQL Queries

*/

select count(*) from projectportfolio.nashville_housing_data_for_data_cleaning nhdfdc 

Select *
From projectportfolio.nashville_housing_data_for_data_cleaning nhdfdc 

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDate ,CONVERT(SaleDate,Date)
From projectportfolio.nashville_housing_data_for_data_cleaning nhdfdc 


Update projectportfolio.nashville_housing_data_for_data_cleaning nhdfdc 
SET SaleDate = CONVERT(SaleDate,Date)

-- If it doesn't Update properly

ALTER TABLE projectportfolio.nashville_housing_data_for_data_cleaning nhdfdc 
Add SaleDateConverted Date;

Update projectportfolio.nashville_housing_data_for_data_cleaning nhdfdc 
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From projectportfolio.nashville_housing_data_for_data_cleaning nhdfdc 
#Where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,IFNULL(a.PropertyAddress,b.PropertyAddress)
from projectportfolio.nashville_housing_data_for_data_cleaning a 
join projectportfolio.nashville_housing_data_for_data_cleaning b
on a.ParcelID =b.ParcelID 
and a.UniqueID <>b.UniqueID 
where a.PropertyAddress  is null



Update projectportfolio.nashville_housing_data_for_data_cleaning a 
JOIN projectportfolio.nashville_housing_data_for_data_cleaning b
on a.ParcelID =b.ParcelID 
and a.UniqueID <>b.UniqueID 
SET a.PropertyAddress = IFNULL(a.PropertyAddress,b.PropertyAddress)
where a.PropertyAddress  is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From projectportfolio.nashville_housing_data_for_data_cleaning 
#Where PropertyAddress is null
#order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, locate(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, locate(',', PropertyAddress) + 1 , LENgth(PropertyAddress)) as Address

From projectportfolio.nashville_housing_data_for_data_cleaning 


SELECT
SUBSTRING(PropertyAddress, 1, locate(',', PropertyAddress)) as Address,
locate(',',PropertyAddress)

From projectportfolio.nashville_housing_data_for_data_cleaning 


ALTER TABLE projectportfolio.nashville_housing_data_for_data_cleaning 
Add PropertySplitAddress Nvarchar(255);

Update projectportfolio.nashville_housing_data_for_data_cleaning 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, locate(',', PropertyAddress) -1 )


ALTER TABLE projectportfolio.nashville_housing_data_for_data_cleaning 
Add PropertySplitCity Nvarchar(255);

Update projectportfolio.nashville_housing_data_for_data_cleaning 
SET PropertySplitCity = SUBSTRING(PropertyAddress, locate(',', PropertyAddress) + 1 , LENgth(PropertyAddress))




Select *
From projectportfolio.nashville_housing_data_for_data_cleaning 





Select OwnerAddress
From  projectportfolio.nashville_housing_data_for_data_cleaning 


select
substring_index(OwnerAddress,',', 1),
substring_index(substring_index( OwnerAddress,',', 2),',',-1),
substring_index(substring_index(OwnerAddress,',',3),',', -1)
From projectportfolio.nashville_housing_data_for_data_cleaning 



ALTER TABLE projectportfolio.nashville_housing_data_for_data_cleaning
Add OwnerSplitAddress Nvarchar(255);

Update projectportfolio.nashville_housing_data_for_data_cleaning
SET OwnerSplitAddress = substring_index(substring_index(OwnerAddress,',',3),',', -1)


ALTER TABLE projectportfolio.nashville_housing_data_for_data_cleaning
Add OwnerSplitCity Nvarchar(255);

Update projectportfolio.nashville_housing_data_for_data_cleaning
SET OwnerSplitCity = substring_index(substring_index( OwnerAddress,',', 2),',',-1)



ALTER TABLE projectportfolio.nashville_housing_data_for_data_cleaning
Add OwnerSplitState Nvarchar(255);

Update projectportfolio.nashville_housing_data_for_data_cleaning
SET OwnerSplitState = substring_index(OwnerAddress,',', 1)



Select *
From projectportfolio.nashville_housing_data_for_data_cleaning




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From projectportfolio.nashville_housing_data_for_data_cleaning
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From projectportfolio.nashville_housing_data_for_data_cleaning


update projectportfolio.nashville_housing_data_for_data_cleaning
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From projectportfolio.nashville_housing_data_for_data_cleaning
#order by ParcelID
)
select * 
From RowNumCTE
Where row_num > 1
#Order by PropertyAddress



Select *
From projectportfolio.nashville_housing_data_for_data_cleaning




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From projectportfolio.nashville_housing_data_for_data_cleaning


ALTER TABLE projectportfolio.nashville_housing_data_for_data_cleaning
DROP COLUMN OwnerAddress, 
DROP column TaxDistrict,
DROP column PropertyAddress,
DROP column SaleDate

































