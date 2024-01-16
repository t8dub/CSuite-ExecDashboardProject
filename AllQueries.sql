/* Source data is a .csv flow output of what has already been cleaned in Tableau Prep. I'm bringing
it into SSMS because pivoting salary/commission/bonus by year in Tableau Prep would create significant
data duplication. I anticipate reshaping into a relational database here will mitigate duplication
and ease the processing burden while building visualizations. 
*/


-- Checking for NULLs
 SELECT * --COUNT(*)
  FROM [HR And Exec KPI Dashboard].[dbo].[Clean5_PrepOutput]
  WHERE [Source_Salary] IS NULL OR
		[Age] IS NULL OR
		[DOB_corrected] IS NULL OR
		[birthdate] IS NULL OR
		[Age_at_Hire] IS NULL OR
		[LOD_Tenure_Decile] IS NULL OR
		[Tenure] IS NULL OR
		[ID] IS NULL OR
		[FName] IS NULL OR
		[LName] IS NULL OR
		[Gender] IS NULL OR
		[Ethnicity] IS NULL OR
		[Work_Location_Type] IS NULL OR
		[DOH] IS NULL OR
		[City] IS NULL OR
		[location_state] IS NULL OR
		[Dept] IS NULL OR
		[Title] IS NULL OR
		[Base_Salary] IS NULL OR
		[Source_Commission_Pool] IS NULL OR
		[Source_Bonus_Pool]  IS NULL



-- Populate missing Lnames
UPDATE [HR And Exec KPI Dashboard].[dbo].[Clean8_PrepOutput]
	SET [LName] = 'Doe'
  WHERE [LName] IS NULL
--(2 rows affected)



-- Pivoting base/commissions/bonus fields from columns to rows (requires UNPIVOT)
SELECT ID, Yr, Val
FROM 
(	   SELECT ID, _2000_Base,_2001_Base,_2002_Base,_2003_Base,_2004_Base,_2005_Base
      ,_2006_Base,_2007_Base,_2008_Base,_2009_Base,_2010_Base,_2011_Base,_2012_Base
      ,_2013_Base,_2014_Base,_2015_Base,_2016_Base,_2017_Base,_2018_Base,_2019_Base
      ,_2020_Base,_2000_Comms,_2001_Comms,_2002_Comms,_2003_Comms,_2004_Comms,_2005_Comms
      ,_2006_Comms,_2007_Comms,_2008_Comms,_2009_Comms,_2010_Comms,_2011_Comms,_2012_Comms
      ,_2013_Comms,_2014_Comms,_2015_Comms,_2016_Comms,_2017_Comms,_2018_Comms,_2019_Comms
      ,_2020_Comms,_2000_Bonus,_2001_Bonus,_2002_Bonus,_2003_Bonus,_2004_Bonus,_2005_Bonus
      ,_2006_Bonus,_2007_Bonus,_2008_Bonus,_2009_Bonus,_2010_Bonus,_2011_Bonus,_2012_Bonus
      ,_2013_Bonus,_2014_Bonus,_2015_Bonus,_2016_Bonus,_2017_Bonus,_2018_Bonus,_2019_Bonus
      ,_2020_Bonus
FROM [HR And Exec KPI Dashboard].[dbo].[Clean5_PrepOutput]
) p
UNPIVOT
( Val FOR Yr IN ([_2000_Base],[_2001_Base],[_2002_Base],[_2003_Base],[_2004_Base],[_2005_Base]
      ,[_2006_Base],[_2007_Base],[_2008_Base],[_2009_Base],[_2010_Base],[_2011_Base],[_2012_Base]
      ,[_2013_Base],[_2014_Base],[_2015_Base],[_2016_Base],[_2017_Base],[_2018_Base],[_2019_Base]
      ,[_2020_Base],[_2000_Comms],[_2001_Comms],[_2002_Comms],[_2003_Comms],[_2004_Comms],[_2005_Comms]
      ,[_2006_Comms],[_2007_Comms],[_2008_Comms],[_2009_Comms],[_2010_Comms],[_2011_Comms],[_2012_Comms]
      ,[_2013_Comms],[_2014_Comms],[_2015_Comms],[_2016_Comms],[_2017_Comms],[_2018_Comms],[_2019_Comms]
      ,[_2020_Comms],[_2000_Bonus],[_2001_Bonus],[_2002_Bonus],[_2003_Bonus],[_2004_Bonus],[_2005_Bonus]
      ,[_2006_Bonus],[_2007_Bonus],[_2008_Bonus],[_2009_Bonus],[_2010_Bonus],[_2011_Bonus],[_2012_Bonus]
      ,[_2013_Bonus],[_2014_Bonus],[_2015_Bonus],[_2016_Bonus],[_2017_Bonus],[_2018_Bonus],[_2019_Bonus]
      ,[_2020_Bonus])
  ) AS up
  ORDER BY ID, Yr; 
-- looks good, but omits nulls - only 490,082 rows



-- Pivoting using CROSS JOIN... CASE to preserve nulls, populating temp new table with results
SELECT a.ID, b.Yr, 
		Val = CASE b.Yr
			WHEN '_2000_Base' THEN a._2000_Base WHEN '_2001_Base' THEN a._2001_Base WHEN '_2002_Base' THEN a._2002_Base
			WHEN '_2003_Base' THEN a._2003_Base WHEN '_2004_Base' THEN a._2004_Base WHEN '_2005_Base' THEN a._2005_Base
			WHEN '_2006_Base' THEN a._2006_Base WHEN '_2007_Base' THEN a._2007_Base WHEN '_2008_Base' THEN a._2008_Base
			WHEN '_2009_Base' THEN a._2009_Base WHEN '_2010_Base' THEN a._2010_Base WHEN '_2011_Base' THEN a._2011_Base
			WHEN '_2012_Base' THEN a._2012_Base WHEN '_2013_Base' THEN a._2013_Base WHEN '_2014_Base' THEN a._2014_Base
			WHEN '_2015_Base' THEN a._2015_Base WHEN '_2016_Base' THEN a._2016_Base WHEN '_2017_Base' THEN a._2017_Base
			WHEN '_2018_Base' THEN a._2018_Base WHEN '_2019_Base' THEN a._2019_Base WHEN '_2020_Base' THEN a._2020_Base
			WHEN '_2000_Comms' THEN a._2000_Comms WHEN '_2001_Comms' THEN a._2001_Comms WHEN '_2002_Comms' THEN a._2002_Comms
			WHEN '_2003_Comms' THEN a._2003_Comms WHEN '_2004_Comms' THEN a._2004_Comms WHEN '_2005_Comms' THEN a._2005_Comms
			WHEN '_2006_Comms' THEN a._2006_Comms WHEN '_2007_Comms' THEN a._2007_Comms WHEN '_2008_Comms' THEN a._2008_Comms
			WHEN '_2009_Comms' THEN a._2009_Comms WHEN '_2010_Comms' THEN a._2010_Comms WHEN '_2011_Comms' THEN a._2011_Comms
			WHEN '_2012_Comms' THEN a._2012_Comms WHEN '_2013_Comms' THEN a._2013_Comms WHEN '_2014_Comms' THEN a._2014_Comms
			WHEN '_2015_Comms' THEN a._2015_Comms WHEN '_2016_Comms' THEN a._2016_Comms WHEN '_2017_Comms' THEN a._2017_Comms
			WHEN '_2018_Comms' THEN a._2018_Comms WHEN '_2019_Comms' THEN a._2019_Comms WHEN '_2020_Comms' THEN a._2020_Comms
			WHEN '_2000_Bonus' THEN a._2000_Bonus WHEN '_2001_Bonus' THEN a._2001_Bonus WHEN '_2002_Bonus' THEN a._2002_Bonus
			WHEN '_2003_Bonus' THEN a._2003_Bonus WHEN '_2004_Bonus' THEN a._2004_Bonus WHEN '_2005_Bonus' THEN a._2005_Bonus
			WHEN '_2006_Bonus' THEN a._2006_Bonus WHEN '_2007_Bonus' THEN a._2007_Bonus WHEN '_2008_Bonus' THEN a._2008_Bonus
			WHEN '_2009_Bonus' THEN a._2009_Bonus WHEN '_2010_Bonus' THEN a._2010_Bonus WHEN '_2011_Bonus' THEN a._2011_Bonus
			WHEN '_2012_Bonus' THEN a._2012_Bonus WHEN '_2013_Bonus' THEN a._2013_Bonus WHEN '_2014_Bonus' THEN a._2014_Bonus
			WHEN '_2015_Bonus' THEN a._2015_Bonus WHEN '_2016_Bonus' THEN a._2016_Bonus WHEN '_2017_Bonus' THEN a._2017_Bonus
			WHEN '_2018_Bonus' THEN a._2018_Bonus WHEN '_2019_Bonus' THEN a._2019_Bonus WHEN '_2020_Bonus' THEN a._2020_Bonus
			END
			INTO TempCompByIDByYr
FROM 
(	   SELECT ID, _2000_Base,_2001_Base,_2002_Base,_2003_Base,_2004_Base,_2005_Base,_2006_Base,_2007_Base,
				  _2008_Base,_2009_Base,_2010_Base,_2011_Base,_2012_Base,_2013_Base,_2014_Base,_2015_Base,
				  _2016_Base,_2017_Base,_2018_Base,_2019_Base,_2020_Base,
				  _2000_Comms,_2001_Comms,_2002_Comms,_2003_Comms,_2004_Comms,_2005_Comms,_2006_Comms,_2007_Comms,
				  _2008_Comms,_2009_Comms,_2010_Comms,_2011_Comms,_2012_Comms,_2013_Comms,_2014_Comms,_2015_Comms,
				  _2016_Comms,_2017_Comms,_2018_Comms,_2019_Comms,_2020_Comms,
				  _2000_Bonus,_2001_Bonus,_2002_Bonus,_2003_Bonus,_2004_Bonus,_2005_Bonus,_2006_Bonus,_2007_Bonus,
				  _2008_Bonus,_2009_Bonus,_2010_Bonus,_2011_Bonus,_2012_Bonus,_2013_Bonus,_2014_Bonus,_2015_Bonus,
				  _2016_Bonus,_2017_Bonus,_2018_Bonus,_2019_Bonus,_2020_Bonus
		FROM [HR And Exec KPI Dashboard].[dbo].[Clean5_PrepOutput]
) a
CROSS JOIN
(		SELECT '_2000_Base' UNION ALL  SELECT '_2001_Base' UNION ALL  SELECT '_2002_Base' UNION ALL 
		SELECT '_2003_Base' UNION ALL  SELECT '_2004_Base' UNION ALL  SELECT '_2005_Base' UNION ALL 
		SELECT '_2006_Base' UNION ALL  SELECT '_2007_Base' UNION ALL  SELECT '_2008_Base' UNION ALL 
		SELECT '_2009_Base' UNION ALL  SELECT '_2010_Base' UNION ALL  SELECT '_2011_Base' UNION ALL 
		SELECT '_2012_Base' UNION ALL  SELECT '_2013_Base' UNION ALL  SELECT '_2014_Base' UNION ALL 
		SELECT '_2015_Base' UNION ALL  SELECT '_2016_Base' UNION ALL  SELECT '_2017_Base' UNION ALL 
		SELECT '_2018_Base' UNION ALL  SELECT '_2019_Base' UNION ALL  SELECT '_2020_Base' UNION ALL 
		SELECT '_2000_Comms' UNION ALL  SELECT '_2001_Comms' UNION ALL  SELECT '_2002_Comms' UNION ALL 
		SELECT '_2003_Comms' UNION ALL  SELECT '_2004_Comms' UNION ALL  SELECT '_2005_Comms' UNION ALL 
		SELECT '_2006_Comms' UNION ALL  SELECT '_2007_Comms' UNION ALL  SELECT '_2008_Comms' UNION ALL 
		SELECT '_2009_Comms' UNION ALL  SELECT '_2010_Comms' UNION ALL  SELECT '_2011_Comms' UNION ALL 
		SELECT '_2012_Comms' UNION ALL  SELECT '_2013_Comms' UNION ALL  SELECT '_2014_Comms' UNION ALL 
		SELECT '_2015_Comms' UNION ALL  SELECT '_2016_Comms' UNION ALL  SELECT '_2017_Comms' UNION ALL 
		SELECT '_2018_Comms' UNION ALL  SELECT '_2019_Comms' UNION ALL  SELECT '_2020_Comms' UNION ALL 
		SELECT '_2000_Bonus' UNION ALL  SELECT '_2001_Bonus' UNION ALL  SELECT '_2002_Bonus' UNION ALL 
		SELECT '_2003_Bonus' UNION ALL  SELECT '_2004_Bonus' UNION ALL  SELECT '_2005_Bonus' UNION ALL 
		SELECT '_2006_Bonus' UNION ALL  SELECT '_2007_Bonus' UNION ALL  SELECT '_2008_Bonus' UNION ALL 
		SELECT '_2009_Bonus' UNION ALL  SELECT '_2010_Bonus' UNION ALL  SELECT '_2011_Bonus' UNION ALL 
		SELECT '_2012_Bonus' UNION ALL  SELECT '_2013_Bonus' UNION ALL  SELECT '_2014_Bonus' UNION ALL 
		SELECT '_2015_Bonus' UNION ALL  SELECT '_2016_Bonus' UNION ALL  SELECT '_2017_Bonus' UNION ALL 
		SELECT '_2018_Bonus' UNION ALL  SELECT '_2019_Bonus' UNION ALL  SELECT '_2020_Bonus'
  ) b (Yr)
  ORDER BY ID, Yr;
-- looks good! 1,399,482 rows (=22,214*63)



-- Using CTE to split Yr column into year and comp type, then reshape and write into new table
WITH TempCompCTE AS
	(
		SELECT ID,Yr,
		--recall PARSENAME works backwards, hence the counter-intuitive 1/2
		PARSENAME(REPLACE(Yr, '_', '.'), 1) AS TempCompType, 
		PARSENAME(REPLACE(Yr, '_', '.'), 2) AS TempYr,		 
		Val
		FROM [HR And Exec KPI Dashboard].[dbo].[TempCompByIDByYr]
	)
--SELECT ID,Yr,TempCompType,TempYr,Val,
SELECT ID,TempYr AS CompYear,
	CASE WHEN TempCompType = 'Base' THEN Val END AS BaseSalary,
    CASE WHEN TempCompType = 'Comms' THEN Val END AS Commissions,
    CASE WHEN TempCompType = 'Bonus' THEN Val END AS Bonus
	INTO Comp
FROM TempCompCTE
ORDER BY ID, CompYear
-- looks good! 1,399,482 rows (=22,214*63)



-- Cleaning up; deleting temporary table used in previous 2 steps
DROP TABLE [HR And Exec KPI Dashboard].[dbo].[TempCompByIDByYr]



/* I wanted to artificially 'age' the working population in the dataset, applying the 'aging' at different
frequencies by department.  For example, I wanted to increase the age of a third of the Sales and Finance departments,
but only an eighth of the Business Intelligence and Marketing Departments. The magnitude of the aging per person was 
setting the year of birth back by the number of the month of birth (1976-10-22 becomes 1966-10-22). I used nested CTEs
to accomplish this and saved results in a new table...
*/
WITH frstCTE AS
(
	SELECT ID,DOB,DOH,Dept,
    ROW_NUMBER() OVER(PARTITION BY Dept ORDER BY Dept) rn
	FROM [HR And Exec KPI Dashboard].[dbo].[Clean8_PrepOutput]
), tweakDOBCTE AS
	(
	SELECT ID,DOB,DOH,Dept,rn,
	DATEADD(YEAR,-MONTH(DOB),DOB) AS ChgdDOB
	FROM frstCTE
	WHERE ((Dept = 'Finance' OR Dept = 'Sales') AND rn % 3 = 0) OR
	  ((Dept = 'Operations' OR Dept = 'IT' OR Dept = 'Management' OR Dept = 'Legal') AND rn % 4 = 0) OR
	  ((Dept = 'Product Innovation' OR Dept = 'Human Resources') AND rn % 6 = 0) OR
	  ((Dept = 'Business Intelligence' OR Dept = 'Marketing') AND rn % 8 = 0) OR
	  ((Dept = 'Maintenance/Custodial' OR Dept = 'Office/Administrative') AND rn % 10 = 0)
	)
SELECT ID,DOH,Dept,DOB,ChgdDOB,
	DATEDIFF(YEAR,ChgdDOB,DOB) AS Chg
	INTO NewDOBs
FROM tweakDOBCTE
ORDER BY Dept,ChgdDOB
-- looks good, (4697 rows affected); previewing in Tableau... 



-- Did further cleaning in Tableau Prep, ran flow and imported as 'Clean8_PrepOutput'. Looking at DOB mismatches...
SELECT *
FROM [dbo].[Clean8_PrepOutput] tc, [dbo].[NewDOBs] tn
  WHERE tc.[DOB] <> tn.[ChgdDOB] AND
        tc.[ID] = tn.[ID]



-- Replacing old DOBs with updated
UPDATE [dbo].[Clean8_PrepOutput]
SET DOB = t2.ChgdDOB 
From [dbo].[Clean8_PrepOutput] t1
INNER JOIN [dbo].[NewDOBs] AS t2
    ON t1.ID = t2.ID
WHERE t1.[DOB] <> t2.[ChgdDOB]



-- Checking result
SELECT *
FROM [dbo].[Clean8_PrepOutput] tc, [dbo].[NewDOBs] tn
  WHERE tc.[DOB] <> tn.[ChgdDOB] AND
        tc.[ID] = tn.[ID]
-- looks good


-- Checking counts
SELECT COUNT([DOB])
FROM [dbo].[Clean8_PrepOutput]
--looks good (22,214)



/* I like the effect of the artificial 'aging' done above, but I think even more would help the 
Tableau view. Previewing more 'aging' of workers in Sales department...*/
SELECT *
FROM [HR And Exec KPI Dashboard].[dbo].[Clean8_PrepOutput]
  WHERE Dept = 'Sales' AND
		DOB >= '1968-01-01' AND DOB < '1978-01-01' AND
		DOT IS NULL AND
		MONTH(DOB) % 2 = 0
-- 'MONTH(DOB) % 2 = 0' would modify 727 of a possible 1418, or 20% of total Sales dept. Looks good



-- ... now updating effected DOBs
UPDATE [HR And Exec KPI Dashboard].[dbo].[Clean8_PrepOutput]
	SET [DOB] = DATEADD(YEAR,-9,DOB)
  WHERE Dept = 'Sales' AND
		DOB >= '1968-01-01' AND DOB < '1978-01-01' AND
		DOT IS NULL AND
		MONTH(DOB) % 2 = 0
--(727 rows affected)



/* The dataset is a little stale (2020 latest), so I'm bringing up-to-date. Adding 3 years to every
date should do the trick.*/
UPDATE [HR And Exec KPI Dashboard].[dbo].[Clean8_PrepOutput]
	SET [DOB] = DATEADD(YEAR,3,DOB),
		[DOH] = DATEADD(YEAR,3,DOH),
		[DOT] = DATEADD(YEAR,3,DOT)
-- (22214 rows affected)



--... same for Comp table
UPDATE [HR And Exec KPI Dashboard].[dbo].[Comp]
	SET [CompYear] = CompYear + 3
-- (1399482 rows affected)



/* let's pretend there's a culture problem in the IT department and it has resulted in excess
and increasing turnover of women over the past 3 years...*/
	DECLARE @start DATE = '2020-01-01'
	DECLARE @end DATE = '2023-12-01';
WITH frstCTE AS
(
	SELECT ID,DOB,DOH,DOT,Dept,Gender,
    ROW_NUMBER() OVER(ORDER BY DOH DESC) rn
	FROM [HR And Exec KPI Dashboard].[dbo].[Clean8_PrepOutput]
	WHERE Dept = 'IT' AND Gender = 'Female' AND DOT IS NULL
), newDOTCTE AS
	(
	SELECT ID,DOB,DOH,DOT,Dept,Gender,rn,
	DATEADD(DAY,ABS(CHECKSUM(NEWID())) % ( 1 + DATEDIFF(DAY,@start,@end)),@start) AS newDOT
	FROM frstCTE
	WHERE rn % 9 = 0
	)
SELECT ID,DOB,DOH,DOT,Dept,Gender,newDOT
INTO NewDOTs
FROM newDOTCTE
WHERE newDOT > DOH
ORDER BY newDOT DESC
--looks good (124 rows affected)



-- using above to update DOTs
UPDATE [dbo].[Clean8_PrepOutput]
SET DOT = t2.newDOT 
From [dbo].[Clean8_PrepOutput] t1
INNER JOIN [dbo].[NewDOTs] AS t2
    ON t1.ID = t2.ID
-- (125 rows affected)



-- if needed, this will RESET/UNDO what was done above
UPDATE [dbo].[Clean8_PrepOutput]
SET DOT = NULL 
WHERE Dept = 'IT' AND Gender = 'Female' AND YEAR(DOT)>2018



/* added even more turnover (DOTs) to approximate reality...*/
	DECLARE @start DATE = '2003-10-18'
	DECLARE @end DATE = '2023-12-31';
WITH frstCTE AS
(
	SELECT ID,DOB,DOH,DOT,Dept,Gender,
    ROW_NUMBER() OVER(ORDER BY DOH DESC) rn
	FROM [HR And Exec KPI Dashboard].[dbo].[Clean8_PrepOutput]
	WHERE DOT IS NULL
), newDOTCTE AS
	(
	SELECT ID,DOB,DOH,DOT,Dept,Gender,rn,
	DATEADD(DAY,ABS(CHECKSUM(NEWID())) % ( 1 + DATEDIFF(DAY,@start,@end)),@start) AS newDOT
	FROM frstCTE
	WHERE rn % 10 = 0
	)
SELECT ID,DOB,DOH,DOT,Dept,Gender,newDOT
INTO NewDOTs
FROM newDOTCTE
WHERE newDOT > DOH
ORDER BY newDOT DESC
--looks good (985 rows affected)



-- using above to update DOTs
UPDATE [dbo].[Clean8_PrepOutput]
SET DOT = t2.newDOT 
From [dbo].[Clean8_PrepOutput] t1
INNER JOIN [dbo].[NewDOTs] AS t2
    ON t1.ID = t2.ID
-- (985 rows affected)



-- if needed, this will RESET/UNDO what was done above
UPDATE [dbo].[Clean8_PrepOutput]
SET DOT = NULL 
WHERE Dept = 'C-Suite' OR Dept = 'Upper Management'



-- All maintenance/custodial needs to have on-site (headquarters) work location 
UPDATE [dbo].[Clean8_PrepOutput]
SET [Work_Location_Type] = 'Headquarters' 
WHERE Dept = 'Maintenance/Custodial'



-- Increasing remote work for sales and business intelligence depts 
WITH frstCTE AS
(
	SELECT ID,Dept,Work_Location_Type,
    ROW_NUMBER() OVER(ORDER BY DOH DESC) rn
	FROM [HR And Exec KPI Dashboard].[dbo].[Clean8_PrepOutput]
	WHERE (Dept = 'Sales' OR Dept = 'Business Intelligence' OR Dept = 'Product Innovation') AND
			Work_Location_Type = 'Headquarters'
), newWkTypeCTE AS
	(
	SELECT ID,Dept,Work_Location_Type,rn
	FROM frstCTE
	WHERE rn % 6 = 0  --1/6th to be changed
	)
SELECT ID,Dept,Work_Location_Type
INTO temptable
FROM newWkTypeCTE
--looks good (1134 rows affected)



-- using above to update DOTs
UPDATE [dbo].[Clean8_PrepOutput]
SET [Work_Location_Type] = 'Remote' 
From [dbo].[Clean8_PrepOutput] t1
INNER JOIN [dbo].[temptable] AS t2
    ON t1.ID = t2.ID
-- (1134 rows affected)



	