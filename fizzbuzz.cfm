<!--- 
	Was reading a blog that talked about the rules for FizzBuzz. I know it's a very basic (and old) coding
	problem, but I'm pretty much a self-taught guy. I've never actually written FizzBuzz, so I figured I'd 
	throw it together in SQL, then in CF. It's a cute little thought exercise. And even though it's easy and 
	fun, that's what toys are for, right? :-)
	
	Rules of the FizzBuzz Puzzle : 
	Write a program that prints the numbers from 1 to 100. For multiples of three print “Fizz” instead 
	of the number and for the multiples of five print “Buzz”. For numbers which are multiples of both three 
	and five print “FizzBuzz”. Otherwise print just the number.
--->

<cfscript>
	WriteOutput( "FizzBuzz Test <br/><br/>" );
	
	for(counter=1; counter LTE 100; counter++) {
		writeme = "";
		if ( counter%3 == 0 ) { writeme = "Fizz"; };
		if ( counter%5 == 0 ) { writeme = writeme & "Buzz"; };
		if ( LEN(writeme) == 0 ) { writeme = counter; };
		WriteOutput( writeme & "<br/>" );
	} ;
</cfscript>



<!--- SQL:

/* 3263 ms, 185client|3078server */

IF OBJECT_ID('tempdb.dbo.#TempInput') IS NOT NULL
    DROP TABLE #TempInput
CREATE TABLE #TempInput (
	InputVal INT
	, FIZZBUZZ varchar(10)
)

INSERT INTO #TempInput (InputVal)
SELECT TOP (100000) nums = ROW_NUMBER() OVER (ORDER BY sysAll1.object_id)
FROM sys.all_objects AS sysAll1 /* grab lots of IDs */
CROSS JOIN sys.all_objects AS sysAll2

UPDATE #TempInput
SET FIZZBUZZ = 
	CASE
		WHEN InputVal%3 = 0 AND InputVal%5 = 0 THEN 'FizzBuzz'
		WHEN InputVal%3 = 0 THEN 'Fizz'
		WHEN InputVal%5 = 0 THEN 'Buzz'
		ELSE CONVERT(varchar(10),InputVal)
	END

SELECT * FROM #TempInput


-------------------------------------------

/* 3271ms, 3248client|23server */

IF OBJECT_ID('tempdb.dbo.#TempInput') IS NOT NULL
    DROP TABLE #TempInput
CREATE TABLE #TempInput (
	InputVal INT
	, FIZZBUZZ varchar(10)
)

DECLARE @Input INT = 1

WHILE @Input <= 100000
BEGIN
	INSERT INTO #TempInput (InputVal, FIZZBUZZ)
	VALUES (@Input, 
		CASE 
			WHEN @Input%3 = 0 AND @Input%5 = 0 THEN 'FizzBuzz'
			WHEN @Input%3 = 0 THEN 'Fizz'
			WHEN @Input%5 = 0 THEN 'Buzz'
			ELSE CONVERT(varchar(10), @Input)
		END
		)
	SET @Input = @Input + 1
END

SELECT * FROM #TempInput



-------------------------------------------

/* 2436ms, 2430client|6server - this method solves the problem but doesn't store the results. */

DECLARE @Input INT = 1

WHILE @Input <= 100000 
BEGIN 
	DECLARE @FizzBuzz VARCHAR(10) = ''
	IF @Input%3 = 0 BEGIN SET @FizzBuzz = 'FIZZ' END
	IF @Input%5 = 0 BEGIN SET @FizzBuzz = @FizzBuzz + 'BUZZ' END
	
	PRINT ( CASE WHEN LEN(@FizzBuzz) > 0 THEN @FizzBuzz ELSE CONVERT(varchar(10),@Input) END )
	
	SET @Input = @Input+1
END

--->
