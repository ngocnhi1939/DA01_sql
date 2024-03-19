/*1*/
alter table sales_dataset_rfm_prj
alter column ordernumber type numeric using (trim(ordernumber)::numeric),
alter column quantityordered type numeric using (trim(quantityordered)::numeric),
alter column orderlinenumber type numeric using (trim(orderlinenumber)::numeric),
alter column sales type numeric using (trim(sales)::numeric),
alter column orderdate type timestamp using to_timestamp(orderdate,'MM/DD/YYYY HH24:MI'),
alter column status type text,
alter column productline type text,
alter column msrp type numeric using (trim(msrp)::numeric),
alter column productcode type VARCHAR(10),
alter column customername type Text,
alter column phone type VARCHAR(40),
alter column addressline1 type VARCHAR (200),
alter column addressline2 type VARCHAR (100),
alter column city type VARCHAR (100),
alter column state type VARCHAR (30),
alter column postalcode type VARCHAR (50),
alter column country type VARCHAR (50),
alter column territory type VARCHAR (50),
alter column contactfullname type VARCHAR (100),
alter column dealsize type VARCHAR (100);

/*2*/
Select *
From sales_dataset_rfm_prj
Where 
    COALESCE(ORDERNUMBER::text, '') = '' OR
    COALESCE(QUANTITYORDERED::text, '') = '' OR
    COALESCE(PRICEEACH::text, '') = '' OR
    COALESCE(ORDERLINENUMBER::text, '') = '' OR
    COALESCE(SALES::text, '') = '' OR
    COALESCE(ORDERDATE::text, '') = '';

/*3*/
Alter table sales_dataset_rfm_prj
Add column CONTACTLASTNAME VARCHAR,
Add column CONTACTFIRSTNAME VARCHAR;

UPDATE sales_dataset_rfm_prj
SET 
CONTACTLASTNAME = CASE 
                  WHEN POSITION(' ' IN CONTACTFULLNAME) > 0 
						THEN INITCAP(SUBSTRING(CONTACTFULLNAME FROM 1 FOR POSITION(' ' IN CONTACTFULLNAME) - 1))
                        ELSE INITCAP(CONTACTFULLNAME)
                     END,
CONTACTFIRSTNAME = CASE 
                  WHEN POSITION(' ' IN CONTACTFULLNAME) > 0 
						 THEN INITCAP(SUBSTRING(CONTACTFULLNAME FROM POSITION(' ' IN CONTACTFULLNAME) + 1))
                         ELSE ''
                      END;
UPDATE sales_dataset_rfm_prj
SET 
    CONTACTLASTNAME = INITCAP(CONTACTLASTNAME),
    CONTACTFIRSTNAME = INITCAP(CONTACTFIRSTNAME);

/*4*/
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID INTEGER,
ADD COLUMN MONTH_ID INTEGER,
ADD COLUMN YEAR_ID INTEGER;

UPDATE sales_dataset_rfm_prj
SET 
    QTR_ID = EXTRACT(QUARTER FROM ORDERDATE),
    MONTH_ID = EXTRACT(MONTH FROM ORDERDATE),
    YEAR_ID = EXTRACT(YEAR FROM ORDERDATE);

/*5*/
WITH Quartiles AS (
  SELECT
    QUANTILE(QUANTITYORDERED, 0.25) AS Q1,
    QUANTILE(QUANTITYORDERED, 0.75) AS Q3
  FROM
    your_table
)
, IQR AS (
  SELECT
    Q1,
    Q3,
    Q3 - Q1 AS IQR
  FROM
    sales_dataset_rfm_prj
)
SELECT
  *,
  CASE 
    WHEN QUANTITYORDERED < Q1 - 1.5 * IQR OR QUANTITYORDERED > Q3 + 1.5 * IQR THEN 'Outlier'
    ELSE 'Normal'
  END AS Outlier_Status
FROM
  sales_dataset_rfm_prj, IQR;

/*6*/
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
SELECT *
FROM sales_dataset_rfm_prj
WHERE QUANTITYORDERED BETWEEN Q1 - 1.5 * IQR AND Q3 + 1.5 * IQR;
