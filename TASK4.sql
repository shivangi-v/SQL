use demo;

create table demo4 ( isu int, move_in date, move_out date, start_date date, end_date date, contract varchar(255));

insert into demo4 values
(778 ,	'12-4-2005',	'1-6-2012',	'12-4-2005',	'1-3-2006',	'CON'),
(778,   '12-4-2005',	'1-6-2012',	'2-4-2006',	'1-6-2012',	'TAR'),

(1109,	'9-4-2001',	'1-6-2002',	'9-4-2001',	'9-12-2001',	'TRY'),
(1109,	'9-4-2001',	'1-6-2002',	'9-12-2001',	'10-1-2001',	'TRY'),
(1109,	'9-4-2001',	'1-6-2002',	'10-12-2001',	'11-3-2002',	'HAL'),
(1109,	'9-4-2001',	'1-6-2002',	'11-4-2001',	'12-12-2001',	'CON'),
(1109,	'9-4-2001',	'1-6-2002',	'12-12-2001',	'1-6-2002',	'TAR'),
(1109,	'9-4-2001',	'1-6-2002',	'12-12-2001',	'1-7-2002',	'YUT'),

(2345,	'12-4-2005',	'1-6-2012',	'12-4-2005',	'12-4-2005',	'DF'),
(2345,	'12-4-2005',	'1-6-2012',	'12-4-2005',	'1-6-2012',	'BHI'),
(2345,	'12-4-2005',	'1-6-2012',	'12-4-2005',	'12-4-2005',	'HAL'),
(2345,	'12-4-2005',	'1-6-2012',	'1-5-2011',	'12-12-2011',	'BHI'),
(2345,	'12-4-2005',	'1-6-2012',	'1-5-2011',	'12-8-2011',	'UYT'),
(2345,	'12-4-2005',	'1-6-2012',	'1-5-2011',	'12-9-2011',	'HUI'),
(2345,	'12-4-2005',	'1-6-2012',	'1-5-2012',	'1-6-2012',	'HUI'),

(7879,	'3-5-2007',	'4-10-2011',	'3-5-2007',	'3-12-2007',	'BHI'),
(7879,	'3-5-2007',	'4-10-2011',	'3-12-2007',	'3-12-2009',	'BHI'),
(7879,	'3-5-2007',	'4-10-2011',	'3-12-2009',	'4-10-2011',	'BHI'),

(7797,	'6-12-2007',	'7-10-2011',	'6-12-2007',	'7-10-2011',	'XYZ');

DELETE FROM demo4 WHERE ISU = 2345 AND contract ='TAR'

SELECT *  FROM DEMO4

WITH Z AS 
(
SELECT * ,RANK() OVER (PARTITION BY ISU ORDER BY END_DATE DESC) AS D
FROM DEMO4 WHERE move_in = START_DATE
),
CTE0 AS
(
SELECT * FROM Z WHERE D= 1
)
,
H AS
(
SELECT * FROM  DEMO4 WHERE move_in != START_DATE
),
I AS 
(
SELECT ISU,MOVE_IN,MOVE_OUT,START_DATE,END_DATE,CONTRACT FROM H
UNION ALL
SELECT ISU,MOVE_IN,MOVE_OUT,START_DATE,END_DATE,CONTRACT FROM CTE0
),
CTE1 AS 
(
SELECT *, RANK() OVER (PARTITION BY ISU  ORDER BY START_DATE ASC, END_DATE DESC ) AS GROUP_NO 
FROM I
),
CTE2 AS (
SELECT *, 
case when Lag(contract) OVER (PARTITION BY ISU  ORDER BY START_DATE ASC, END_DATE DESC  ) = contract 
and  GROUP_NO- Lag(group_no) OVER (PARTITION BY ISU  ORDER BY START_DATE ASC, END_DATE DESC  )  =1 
THEN 0
ELSE GROUP_NO
END AS ROW_NO
FROM CTE1
)
,
CTE3 AS (
SELECT * FROM CTE2 WHERE ROW_NO !=1  AND ROW_NO !=0 AND START_DATE != MOVE_IN
)
,
CTE4 AS (
SELECT *,RANK() OVER (PARTITION BY ISU  ORDER BY START_DATE ASC ,END_DATE DESC) AS RANK FROM CTE3
),
CTE5 AS
(
SELECT ISU,MOVE_IN,MOVE_OUT,START_DATE,END_DATE,CONTRACT FROM CTE4 WHERE RANK =1
)
,CTE6 AS
(
SELECT DISTINCT ISU,move_in,move_out,NULL AS START_DATE,NULL AS END_DATE,'NULL' AS CONTRACT  FROM demo4
WHERE ISU NOT IN 
(SELECT ISU FROM CTE5)
)

SELECT * FROM CTE5
UNION ALL 
SELECT * FROM CTE6

