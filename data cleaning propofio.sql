/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProject..[Nashville Housing Data for Data Cleaning]


-- Standardize Date Format


Select SaleDateConverted ,convert(date,saledate)
From PortfolioProject..[Nashville Housing Data for Data Cleaning]

update [Nashville Housing Data for Data Cleaning]
set SaleDate = convert(date,saledate)


-- If it doesn't Update properly

ALTER TABLE [Nashville Housing Data for Data Cleaning]
Add SaleDateConverted Date;

Update [Nashville Housing Data for Data Cleaning]
SET SaleDateConverted = CONVERT(Date,SaleDate)


--populate property address



Select *
From PortfolioProject..[Nashville Housing Data for Data Cleaning]
--where PropertyAddress is null
order by  ParcelID




Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..[Nashville Housing Data for Data Cleaning] a

join PortfolioProject..[Nashville Housing Data for Data Cleaning]  b

   on a.ParcelID = b.ParcelID
   and a.UniqueID  <> b.UniqueID
   where a.PropertyAddress is null


 update a
 set PropertyAddress = ISNULL(a.propertyaddress,b.PropertyAddress)

From PortfolioProject..[Nashville Housing Data for Data Cleaning] a

join PortfolioProject..[Nashville Housing Data for Data Cleaning]  b

   on a.ParcelID = b.ParcelID
   and a.UniqueID  <> b.UniqueID
   where a.PropertyAddress is null


   --breaking out address into individual columns ( address, city , state)



   

Select PropertyAddress
From PortfolioProject..[Nashville Housing Data for Data Cleaning]
--where PropertyAddress is null
order by  ParcelID

select 
SUBSTRING ( PropertyAddress	,1,CHARINDEX(',',PropertyAddress)-1) as address
, SUBSTRING ( PropertyAddress,CHARINDEX(',',PropertyAddress)+1 ,len(propertyaddress)) as address

From PortfolioProject..[Nashville Housing Data for Data Cleaning]


alter table [Nashville Housing Data for Data Cleaning]
add PropertySplitAddress Nvarchar(255);

update [Nashville Housing Data for Data Cleaning]
set PropertySplitAddress =SUBSTRING ( PropertyAddress	,1,CHARINDEX(',',PropertyAddress)-1)




alter table [Nashville Housing Data for Data Cleaning]
add PropertySplitcity Nvarchar(255);

update [Nashville Housing Data for Data Cleaning]
set PropertySplitcity =  SUBSTRING ( PropertyAddress,CHARINDEX(',',PropertyAddress)+1 ,len(propertyaddress))

select *From PortfolioProject..[Nashville Housing Data for Data Cleaning]


select OwnerAddress
From PortfolioProject..[Nashville Housing Data for Data Cleaning]



select 
PARSENAME(replace(OwnerAddress ,',','.'), 3),
PARSENAME(replace(OwnerAddress ,',','.'), 2),
PARSENAME(replace(OwnerAddress ,',','.'), 1)
From PortfolioProject..[Nashville Housing Data for Data Cleaning]


alter table [Nashville Housing Data for Data Cleaning]
add OwnerSplitAddress Nvarchar(255);

update [Nashville Housing Data for Data Cleaning]
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress ,',','.'), 3)




alter table [Nashville Housing Data for Data Cleaning]
add  OwnerSplitcity Nvarchar(255);

update [Nashville Housing Data for Data Cleaning]
set  OwnerSplitcity =  PARSENAME(replace(OwnerAddress ,',','.'), 2)

alter table [Nashville Housing Data for Data Cleaning]
add  OwnerSplitState Nvarchar(255);

update [Nashville Housing Data for Data Cleaning]
set  OwnerSplitState =  PARSENAME(replace(OwnerAddress ,',','.'), 1)




select * from PortfolioProject..[Nashville Housing Data for Data Cleaning]



---- Change Y and N to Yes and No in "Sold as Vacant" field



select distinct(SoldAsVacant)
from PortfolioProject..[Nashville Housing Data for Data Cleaning]




Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..[Nashville Housing Data for Data Cleaning]
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, CASE When SoldAsVacant = '0' THEN 'Yes'
	   When SoldAsVacant = '1' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject..[Nashville Housing Data for Data Cleaning]



Update [Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


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

From PortfolioProject..[Nashville Housing Data for Data Cleaning]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-- Delete Unused Columns

Select *
From PortfolioProject..[Nashville Housing Data for Data Cleaning]


ALTER TABLE PortfolioProject..[Nashville Housing Data for Data Cleaning]
DROP COLUMN  OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



