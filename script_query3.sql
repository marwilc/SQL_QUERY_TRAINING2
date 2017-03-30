/*
1) Mostrar los clientes y sus depositos ordenados de manera ascendente por la fecha del Deposito
*/
SELECT 	CH.NOMBRE,
		D.MONTO,
		D.CODIGO
FROM	BANK.DEPOSITO AS D
		JOIN BANK.CUENTA AS C ON D.CUENTA=C.NUMERO
		JOIN BANK.CUENTA_HABIENTE AS CH ON CH.CEDULA=C.CLIENTE	
ORDER BY D.FECHA ASC;  
/*
2) Mostrar los clientes (nombre), depositos (codigo,monto y fecha) y sucursal(estado y ciudad)
ordenados por sucursales de manera ascendente y fecha del Deposito de manera descendente
*/
SELECT	CH.NOMBRE,
		D.CODIGO,
		D.MONTO,
		D.FECHA,
		S.ESTADO,
		S.CIUDAD
FROM	BANK.DEPOSITO AS D
		JOIN BANK.CUENTA AS C ON D.CUENTA=C.NUMERO
		JOIN BANK.CUENTA_HABIENTE AS CH ON CH.CEDULA=C.CLIENTE
		JOIN BANK.SUCURSAL AS S ON S.ESTADO=C.ESTADO AND S.CIUDAD=C.CIUDAD
ORDER BY D.FECHA DESC, S.NOMBRE ASC;
/*
3) Mostrar que cuentas (numero) y su cliente(nombre) nunca ha tenido algun deposito realizado
en la misma sucursal donde abrió dicha cuenta.
*/
SELECT	C.NUMERO,
		CH.NOMBRE
FROM	BANK.CUENTA AS C
		JOIN BANK.CUENTA_HABIENTE AS CH ON CH.CEDULA=C.CLIENTE
		JOIN BANK.SUCURSAL AS S ON S.ESTADO=C.ESTADO AND S.CIUDAD=C.CIUDAD
WHERE	(S.ESTADO , S.CIUDAD) NOT IN (
		SELECT	D.ESTADO,
				D.CIUDAD
		FROM	BANK.DEPOSITO AS D);
/*
4) Mostrar los clientes (nombre) y la cantidad de depositos que ha tenido en todas sus cuentas.
*/
SELECT 	CH.NOMBRE,
		COUNT(*) AS NUMERO_DEPOSITOS
FROM	BANK.CUENTA_HABIENTE AS CH
		JOIN BANK.CUENTA AS C ON CH.CEDULA=C.CLIENTE
		JOIN BANK.DEPOSITO AS D ON D.CUENTA=C.NUMERO
GROUP BY CH.NOMBRE
ORDER BY CH.NOMBRE ASC;
/*
5) Mostrar los clientes (nombre), cuenta (numero) y la cantidad de depositos que ha tenido dicha cuenta.
*/
SELECT 	CH.NOMBRE,
		C.NUMERO,
		COUNT(*) AS NUMERO_DEPOSITOS
FROM	BANK.CUENTA_HABIENTE AS CH
		JOIN BANK.CUENTA AS C ON CH.CEDULA=C.CLIENTE
		JOIN BANK.DEPOSITO AS D ON D.CUENTA=C.NUMERO
GROUP BY CH.NOMBRE,
		 C.NUMERO
ORDER BY CH.NOMBRE ASC;
/*
7) Mostrar los clientes (nombre), cuenta (numero) y la suma de los depositos que ha tenido dicha cuenta.
*/
SELECT 	CH.NOMBRE,
		C.NUMERO,
		SUM (D.MONTO) AS MONTO_DEPOSITOS
FROM	BANK.CUENTA_HABIENTE AS CH
		JOIN BANK.CUENTA AS C ON CH.CEDULA=C.CLIENTE
		JOIN BANK.DEPOSITO AS D ON D.CUENTA=C.NUMERO
GROUP BY CH.NOMBRE,
		 C.NUMERO
ORDER BY CH.NOMBRE ASC;
/*
8) Mostrar las cuentas que han sido aperturadas en el siglo 20
*/
SELECT 	C.NUMERO,
		C.APERTURA
FROM	BANK.CUENTA AS C 
WHERE	C.APERTURA BETWEEN '19000101' AND '19991231';
/*
9) Mostrar los clientes (nombre) y su ultimo Deposito recibido (codigo y fecha)
*/
SELECT 	nombre,
		codigo,
		fecha
FROM	(SELECT		CH.nombre AS nombre, 
                	D.codigo AS codigo, 
                	D.fecha AS fecha,
                	ROW_NUMBER() OVER (PARTITION BY CH.nombre ORDER BY D.fecha DESC) AS fila
		 FROM		BANK.CUENTA_HABIENTE AS CH
					JOIN BANK.CUENTA AS C ON CH.CEDULA=C.CLIENTE
					JOIN BANK.DEPOSITO AS D ON D.CUENTA=C.NUMERO) A
WHERE	fila = 1;
/*
10) Mostrar los clientes que no han recibido algun deposito en el año 2006 (sin usar NOT IN ni subconsultas).
*/
/*
SELECT	distinct CH.NOMBRE,
FROM	BANK.DEPOSITO AS D
		JOIN BANK.CUENTA AS C ON D.CUENTA=C.NUMERO
		JOIN BANK.CUENTA_HABIENTE AS CH ON CH.CEDULA=C.CLIENTE
		JOIN BANK.SUCURSAL AS S ON S.ESTADO=C.ESTADO AND S.CIUDAD=C.CIUDAD
WHERE	D.FECHA NOT IN BETWEEN '20060101' AND '20061231'
ORDER BY CH.NOMBRE ASC;  
*/
/*
11) Decir cuantos clientes hay por sucursal.
*/
SELECT 	S.NOMBRE,
		COUNT(*) AS CANTIDAD_DE_CLIENTES
FROM	BANK.CUENTA_HABIENTE AS CH
		JOIN BANK.CUENTA AS C ON CH.CEDULA=C.CLIENTE
		JOIN BANK.SUCURSAL AS S ON S.ESTADO=C.ESTADO AND S.CIUDAD=C.CIUDAD
GROUP BY S.NOMBRE
ORDER BY S.NOMBRE ASC;
/*
12) Decir cual es el cliente (nombre) y cuantos depositos tiene el cliente que tiene la mayor
cantidad de depositos en el sistema.
*/
/*
SELECT 	NOMBRE,
		MAX(NUMERO_DEPOSITOS) AS cantidad_de_depositos
FROM	 (SELECT CH.NOMBRE AS NOMBRE,
				COUNT(*) AS NUMERO_DEPOSITOS
		  FROM 	BANK.DEPOSITO AS D
		 		JOIN 	BANK.CUENTA AS C ON D.CUENTA=C.NUMERO
		 		JOIN 	BANK.CUENTA_HABIENTE AS CH ON CH.CEDULA=C.CLIENTE
		  GROUP by CH.NOMBRE) a
WHERE 	MAX(NUMERO_DEPOSITOS)= NUMERO_DEPOSITOS 
GROUP by NOMBRE;
*/
/*
13) Decir cuantos clientes tienen una cantidad depositada en total multipo de 6 pero no de 8.
*/
SELECT 	COUNT (*) AS n_clientes
FROM	(SELECT NOMBRE
		 FROM 	(SELECT	CH.NOMBRE AS NOMBRE,
		 			  	SUM(D.MONTO) AS MONTO_TOTAL 
		 		FROM	BANK.CUENTA_HABIENTE AS CH
		 				JOIN BANK.CUENTA AS C ON CH.CEDULA=C.CLIENTE
		 				JOIN BANK.DEPOSITO AS D ON D.CUENTA=C.NUMERO
		 		GROUP BY CH.NOMBRE) B 
		 WHERE 	(MONTO_TOTAL%6=0) AND (MONTO_TOTAL%8<>0)) a;
/*
14) Decir que clientes (nombre) tienen una cantidad de depositos impar
*/
SELECT 	NOMBRE
FROM	(SELECT NOMBRE
		 FROM 	(SELECT	CH.NOMBRE AS NOMBRE,
		 			  	COUNT(D.codigo) AS cantidad_de_depositos 
		 		FROM	BANK.CUENTA_HABIENTE AS CH
		 				JOIN BANK.CUENTA AS C ON CH.CEDULA=C.CLIENTE
		 				JOIN BANK.DEPOSITO AS D ON D.CUENTA=C.NUMERO
		 		GROUP BY CH.NOMBRE) B 
		 WHERE 	(cantidad_de_depositos%2<>0)) a
GROUP by NOMBRE 
ORDER by NOMBRE ASC;
/*
15) Mostrar los clientes(nombre) y sus ultimos 2 depositos(numero) de los clientes que tienen mas de 2 depositos
*/

SELECT 	nombre,
		codigo
FROM	(SELECT		CH.CEDULA,
					CH.nombre, 
                	D.CODIGO, 
                	D.fecha,
                	ROW_NUMBER() OVER (PARTITION BY CH.CEDULA ORDER BY D.FECHA DESC) AS ORDEN,
					COUNT (C.NUMERO) OVER (PARTITION BY CH.CEDULA) AS DEPOSITOS
		 FROM		BANK.CUENTA_HABIENTE AS CH
					JOIN BANK.CUENTA AS C ON CH.CEDULA=C.CLIENTE
					JOIN BANK.DEPOSITO AS D ON D.CUENTA=C.NUMERO
		)FINAL
WHERE	ORDEN < 3 AND DEPOSITOS > 1;
/*
SELECT  CH.nombre, 
        count(D.codigo) AS depositos 
FROM	BANK.CUENTA_HABIENTE AS CH
		JOIN BANK.CUENTA AS C ON CH.CEDULA=C.CLIENTE
		JOIN BANK.DEPOSITO AS D ON D.CUENTA=C.NUMERO
GROUP BY CH.nombre
HAVING COUNT (*) > 2;
*/
/*
16) Decir el nombre de los clientes (nombre) que tiene exactamente 1 deposito en cualquier sucursal en la
que haya recibido un deposito.
*/
SELECT 	NOMBRE
FROM	BANK.CUENTA_HABIENTE AS CH
		JOIN BANK.CUENTA AS C ON CH.CEDULA=C.CLIENTE
		JOIN BANK.DEPOSITO AS D ON D.CUENTA=C.NUMERO
		JOIN (SELECT S.CIUDAD,
					 S.ESTADO
			  FROM	 BANK.SUCURSAL AS S 
			  		 JOIN BANK.DEPOSITO AS D ON S.ESTADO=D.ESTADO AND S.CIUDAD=D.CIUDAD
			  GROUP BY S.CIUDAD,
			  		   S.ESTADO
			  HAVING COUNT(D.CODIGO) = 1) AS S ON S.CIUDAD=C.CIUDAD AND S.ESTADO= C.ESTADO 
GROUP BY CH.NOMBRE
HAVING 	COUNT(D.CODIGO) = 1;		
/*
Ejemplo UPDATE 

Agregarle 500 bolívares a todos los depósitos de las cuentas que tengan al menos un 1 en su numero
*/

UPDATE Bank.Deposito
SET monto = monto +500
WHERE cuenta like '%1%';
/*
Ejemplo de DELETE

Eliminar todos los depósitos cuya cuenta tenga al menos un 2
*/
DELETE Bank.Deposito
WHERE cuenta like '%2%';
/*
NUNCA HAGAN UN DELETE O UN UPDATE SIN PONER UN WHERE 
*/