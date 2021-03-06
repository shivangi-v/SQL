USE DEMO;
CREATE TABLE TASK6 
(
ISU_NUM INT,
START_DATE DATE,
END_DATE DATE,
PRODUCT_SYS_NUM VARCHAR(50),
RENEW_BEHAVE VARCHAR(50)
);
 select * from task5
INSERT INTO TASK6 VALUES
(	111222333	,	'10-19-2020'	,	'12-31-9999'	,	'GAS_OOC',null	)
(	999888777	,	'02-06-2019'	,	'02-07-2019'	,	NULL	,	'xxxxx'	),
(	999888777	,	'02-06-2019'	,	'10-07-2019'	,	'ELEC_OOC'	,	'xxxxx'	),
(	56565656	,	'22-12-2018'	,	'21-01-2019'	,	NULL	,	'xxxxx'	),
(	56565656	,	'02-06-2019'	,	'10-07-2019'	,	NULL	,	'xxxxx'	),
(	9	,	'21-01-2019'	,	'01-05-2019'	,	NULL	,	NULL	),
(	90909090	,	'21-01-2019'	,	'10-07-2019	',	NULL	,	NULL	)

SELECT * FROM TASK6

DROP #A
SELECT *,RANK() OVER(PARTITION BY ISU_NUM ORDER BY END_DATE DESC, START_DATE DESC) R ,
INTO #A FROM TASK6 

DROP #B
SELECT *
INTO #B FROM TASK6 
WHERE PRODUCT_SYS_NUM = 'GAS_OOC' OR PRODUCT_SYS_NUM = 'ELEC_OOC'

DROP #C
SELECT *,RANK() OVER(PARTITION BY ISU_NUM ORDER BY END_DATE DESC, START_DATE DESC) R1 
INTO #C
FROM #B

SELECT ISU_NUM, START_DATE, END_DATE, PRODUCT_SYS_NUM, RENEW_BEHAVE, 
ROW_NUMBER() OVER(PARTITION BY ISU_NUM,START_DATE, END_DATE, PRODUCT_SYS_NUM, RENEW_BEHAVE ORDER BY ISU_NUM) L
INTO #RESULT
FROM
(
SELECT * FROM #C WHERE R1 = 1
UNION ALL
SELECT * FROM #A WHERE R = 1
)M

SELECT * FROM #RESULT WHERE L =1;














