-- 1) Mostrar los clientes (nombre)) y sus depositos (monto, numero) ordenados de manera ascendente por la fecha del Deposito

SELECT  CH.nombre,
        D.monto,
        D.codigo
FROM    Bank.Deposito AS D
        JOIN    Bank.Cuenta AS CU ON  D.cuenta = CU.Numero
        JOIN Bank.Cuenta_Habiente AS CH ON CH.cedula = CU.cliente
ORDER BY D.fecha ASC;

-- 2) Mostrar los clientes (nombre), depositos (codigo,monto y fecha) y sucursal (estado y ciudad)

SELECT  CH.nombre,
        D.monto,
        D.codigo,
        D.fecha,
        CU.estado,
        CU.ciudad
FROM    Bank.Deposito AS D
        JOIN Bank.Cuenta AS CU ON  D.cuenta = CU.Numero
        JOIN Bank.Cuenta_Habiente AS CH ON CH.cedula = CU.cliente
        JOIN Bank.Sucursal AS S ON CU.estado = S.estado AND CU.ciudad = S.ciudad
ORDER BY D.fecha ASC;

-- 3) Mostrar que cuentas (numero) y su cliente(nombre) nunca ha tenido algun deposito realizado
-- en la misma sucursal donde abrió dicha cuenta.



-- 4) Mostrar los clientes (nombre) y la cantidad de depositos que ha tenido en todas sus cuentas.

SELECT  CH.nombre, COUNT(*)
FROM    Bank.cuenta_habiente AS CH
        JOIN Bank.cuenta AS CU ON CH.cedula = CU.cliente
        JOIN Bank.deposito AS D ON CU.numero = D.cuenta
GROUP BY CH.nombre;

-- 9) Mostrar los clientes (nombre) y su ultimo Deposito recibido (codigo y fecha)

SELECT  nombre, 
        codigo, 
        fecha
FROM (SELECT    CH.nombre AS nombre, 
                D.codigo AS codigo, 
                D.fecha AS fecha,
                ROW_NUMBER() OVER (PARTITION BY CH.nombre ORDER BY D.fecha DESC) AS fila
        FROM    Bank.cuenta_habiente AS CH
                JOIN Bank.cuenta AS CU ON CH.cedula = CU.cliente
                JOIN Bank.deposito AS D ON CU.numero = D.cuenta) a
WHERE fila = 1;

