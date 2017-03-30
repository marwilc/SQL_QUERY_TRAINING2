--La siguiente manera de crear la base de datos es una manera
--poco optima, pero fue hecha de tal manera por fines educativos

CREATE DATABASE bancobd22 TEMPLATE template1;

\c bancobd22

CREATE SCHEMA Bank;


CREATE TABLE Bank.Cuenta_Habiente(
	cedula 		VARCHAR(20),
	nombre 		VARCHAR(30),
	estado 		VARCHAR(30),
	ciudad 		VARCHAR(30),
	nacimiento 	DATE
);

ALTER TABLE Bank.Cuenta_Habiente ADD CONSTRAINT PK_Bank_Cuenta_Habiente PRIMARY KEY (cedula);

CREATE TABLE Bank.Sucursal(
	nombre 		VARCHAR(30),
	estado 		VARCHAR(30),
	ciudad 		VARCHAR(30),
	direccion	VARCHAR(200),
	apertura	DATE
);

ALTER TABLE Bank.Sucursal ADD CONSTRAINT PK_Bank_Sucursal PRIMARY KEY (estado,ciudad);

CREATE TABLE Bank.Cuenta(
	numero		VARCHAR(10)	NOT NULL,
	tipo		VARCHAR(10)	NOT NULL,
	cliente		VARCHAR(20)	NOT NULL,
	estado 		VARCHAR(30)	NOT NULL,
	ciudad 		VARCHAR(30)	NOT NULL,
	apertura	DATE		NOT NULL	
);

ALTER TABLE Bank.Cuenta ADD CONSTRAINT PK_Bank_Cuenta PRIMARY KEY (numero);
ALTER TABLE Bank.Cuenta ADD CONSTRAINT CK_Bank_Cuenta_Tipo CHECK(tipo IN ('Ahorro','Corriente'));
ALTER TABLE Bank.Cuenta ADD CONSTRAINT FK_Bank_Cuenta_Cuenta_Habiente FOREIGN KEY (cliente) REFERENCES bank.Cuenta_Habiente(cedula);
ALTER TABLE Bank.Cuenta ADD CONSTRAINT FK_Bank_Cuenta_Sucursal FOREIGN KEY (estado,ciudad) REFERENCES bank.Sucursal(estado,ciudad);
CREATE INDEX IX_Cuenta_Sucursal ON Bank.Cuenta(estado,ciudad);

CREATE TABLE Bank.Deposito(
	Codigo		VARCHAR(20)		NOT NULL,
	estado 		VARCHAR(30)		NOT NULL,
	ciudad 		VARCHAR(30)		NOT NULL,
	cuenta		VARCHAR(10)		NOT NULL,
	monto		DECIMAL(28,10)	NOT NULL,
	fecha		DATE			NOT NULL
);

ALTER TABLE Bank.Deposito ADD CONSTRAINT PK_Bank_Deposito PRIMARY KEY (codigo);
ALTER TABLE Bank.Deposito ADD CONSTRAINT CK_Bank_Deposito_Montos_Positivos CHECK(monto > 0);
ALTER TABLE Bank.Deposito ADD CONSTRAINT FK_Bank_Deposito_Sucursal FOREIGN KEY (estado,ciudad) REFERENCES bank.Sucursal(estado,ciudad);
ALTER TABLE Bank.Deposito ADD CONSTRAINT FK_Bank_Deposito_Cuenta FOREIGN KEY(cuenta) REFERENCES bank.Cuenta(numero);
CREATE INDEX IX_Deposito_Sucursal ON Bank.Deposito(estado,ciudad);



/*\c postgres

DROP DATABASE bancod22;
*/