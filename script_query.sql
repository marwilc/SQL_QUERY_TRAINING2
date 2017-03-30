SELECT * FROM Bank.Cuenta_Habiente;

SELECT *
FROM Bank.Cuenta_Habiente 
WHERE nacimiento is null;

SELECT *
FROM 
BAnk.Cuenta_Habiente 
	JOIN Bank.Cuenta ON Bank.Cuenta_Habiente.cedula = Bank.Cuenta.cliente;

SELECT 	CH.nombre,
		C.apertura
FROM Bank.cuenta_habiente AS CH
	JOIN Bank.Cuenta  AS C ON CH.cedula = C.cliente;

SELECT CH.nombre
FROM Bank.cuenta_habiente AS CH
WHERE CH.cedula NOT IN (SELECT C.cliente
						FROM Bank.Cuenta AS C);


SELECT 	CH.nombre,
		(	SELECT COUNT (*)
			FROM Bank.cuenta_habiente AS CH1
			WHERE  LEFT (CH1.nombre,1)= LEFT(CH.nombre,1)) AS Cantidad
FROM 	(	SELECT	*
			FROM Bank.cuenta_habiente
		) 	AS CH;

SELECT 	CH.nombre,
		COUNT (*) OVER() AS Cuenta
FROM Bank.cuenta_habiente AS CH
ORDER BY CH.nombre;

SELECT
FROM
JOIN
WHERE
GROUP BY



SELECT 	CH.cedula,
		COUNT(*) AS Cuentas
FROM Bank.cuenta_habiente AS CH
	JOIN Bank.Cuenta AS C ON C.cliente = CH.cedula
WHERE CH.cedula = '203634534582822' 
GROUP BY CH.cedula
ORDER BY CH.cedula ASC;

SELECT 	CH.cedula,
		COUNT(*) AS Cuentas
FROM Bank.cuenta_habiente AS CH
	JOIN Bank.Cuenta AS C ON C.cliente = CH.cedula
GROUP BY CH.cedula
HAVING COUNT(*)>1
ORDER BY CH.cedula ASC;



SELECT *
FROM Bank.cuenta_habiente;

DELETE FROM Bank.deposito
WHERE Cuenta IN (	SELECT Bank.cuenta_habiente
					FROM Bank.Cuenta
					WHERE cliente IN ('24544357626','246434591');
		
SELECT CH.nombre,
		C.numero,
		D.codigo,
		D.monto
FROM Bank.Cuenta_Habiente AS CH
	JOIN Bank.Cuenta AS C ON C.cliente = CH.cedula
	JOIN Bank.Deposito AS D ON D.cuenta = C.numero
WHERE C.cliente NOT IN (SELECT cedula
						FROM Bank.Cuenta_Habiente);



SELECT CH.nombre,
		C.numero,
		D.codigo,
		D.monto,
		CASE
			WHEN D.codigo is null THEN 'null'
			ELSE ' no es null'
		END Def,
		Row_number() OVER( 	PARTITION BY CH.Nombre
							order by CH.nombre, D.fecha DESC
							) AS deposito		
FROM Bank.Cuenta_Habiente AS CH
	JOIN Bank.Cuenta AS C ON C.cliente = CH.cedula
	JOIN Bank.Deposito AS D ON D.cuenta = C.numero
ORDER BY CH.nombre ASC;
