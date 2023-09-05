use housing_data_cleaning;
LOAD DATA LOCAL INFILE
'File Path'
INTO TABLE housing_data_cleaning.housing_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from housing_data;

-- Standardizing The Date Format

SELECT SaleDate, CONVERT(SaleDate,DATE)
FROM housing_data;

UPDATE housing_data
SET SaleDate = CONVERT(SaleDate,DATE);

-- Populating Property Address Data
SELECT PropertyAddress
FROM housing_data;

SELECT PropertyAddress
FROM housing_data
WHERE PropertyAddress IS NULL;

SELECT *
FROM housing_data s1
JOIN housing_data s2
	ON s1.ParcelID = s2.ParcelID
	AND s1.UniqueID <> s2.UniqueID;

SELECT s1.ParcelID, s1.PropertyAddress, s2.ParcelID, s2.PropertyAddress, IFNULL(s1.PropertyAddress,s2.PropertyAddress)
FROM housing_data s1
JOIN housing_data s2
	ON s1.ParcelID = s2.ParcelID
	AND s1.UniqueID <> s2.UniqueID
WHERE s1.PropertyAddress is NULL;

UPDATE housing_data_cleaning.housing_data s1
JOIN (SELECT ParcelID, PropertyAddress
	FROM housing_data_cleaning.housing_data
    WHERE PropertyAddress is NOT NULL) s2
SET s1.PropertyAddress = s2.PropertyAddress
WHERE s1.PropertyAddress IS NULL;


-- Breaking The Address Into Individual Columns (Address,City,State)

SELECT PropertyAddress
FROM housing_data
ORDER BY ParcelID;

SELECT
SUBSTRING(PropertyAddress,1,LOCATE(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,LOCATE(',',PropertyAddress)+1,LENGTH(PropertyAddress)) AS City
FROM housing_data;
 
ALTER TABLE housing_data
ADD Address_Extracted NVARCHAR(255);
 
UPDATE housing_data
SET Address_Extracted = SUBSTRING(PropertyAddress,1,LOCATE(',',PropertyAddress)-1);

ALTER TABLE housing_data
ADD City_Extracted NVARCHAR(255);
 
UPDATE housing_data
SET City_Extracted = SUBSTRING(PropertyAddress,LOCATE(',',PropertyAddress)+1,LENGTH(PropertyAddress));

SELECT * FROM housing_data;

SELECT SUBSTRING_INDEX(OwnerAddress,',',1)
FROM housing_data;

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,',',2),',',-1)
FROM housing_data;

SELECT SUBSTRING_INDEX(OwnerAddress,',',-1)
FROM housing_data;

SELECT SUBSTRING_INDEX(OwnerAddress,',',1) AS Owner_Address,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,',',2),',',-1) AS Owner_City,
SUBSTRING_INDEX(OwnerAddress,',',-1) AS Owner_State
FROM housing_data;

ALTER TABLE housing_data
ADD Owner_Address_Extracted NVARCHAR(255);
 
UPDATE housing_data
SET Owner_Address_Extracted = SUBSTRING_INDEX(OwnerAddress,',',1);

ALTER TABLE housing_data
ADD Owner_City_Extracted NVARCHAR(255);
 
UPDATE housing_data
SET Owner_City_Extracted = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,',',2),',',-1);

ALTER TABLE housing_data
ADD Owner_State_Extracted NVARCHAR(255);
 
UPDATE housing_data
SET Owner_State_Extracted = SUBSTRING_INDEX(OwnerAddress,',',-1);

SELECT * FROM housing_data;

-- Change 'Y' To 'Yes And 'N' To 'No' In 'SoldASVacant' Column

SELECT DISTINCT(SoldAsVacant), Count(*)
FROM housing_data
GROUP BY 1;

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
	END AS Updated
FROM housing_data;

UPDATE housing_data
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
	END;
    
-- Remove Duplicates
WITH cte1 AS(
SELECT *,
	ROW_NUMBER() OVER(
    PARTITION BY ParcelID, PropertyAddress, SaleDate,SalePrice, LegalReference
    ORDER BY UniqueID) row_num
FROM housing_data)

SELECT * 
FROM cte1
WHERE row_num > 1;

DELETE FROM housing_data
WHERE UniqueID NOT IN (
    SELECT UniqueID
    FROM (
        SELECT UniqueID,
            ROW_NUMBER() OVER (
                PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
                ORDER BY UniqueID) AS row_num
        FROM housing_data) AS subquery
WHERE row_num = 1);


-- Delete Unused Columns

ALTER TABLE housing_data
DROP COLUMN OwnerAddress, 
DROP COLUMN PropertyAddress;

SELECT * FROM housing_data;