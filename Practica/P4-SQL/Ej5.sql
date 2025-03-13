/*  Ejercicio 5
 AGENCIA = (RAZON_SOCIAL, dirección, telef, e-mail)
 CIUDAD = (CODIGOPOSTAL, nombreCiudad, añoCreación)
 CLIENTE = (DNI, nombre, apellido, teléfono, dirección)
 VIAJE = (FECHA, HORA, DNI (fk), cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion)*/
/* cpOrigen y cpDestino corresponden a la ciudades origen y destino del viaje*/ 

 /* 1. Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de ‘La
 Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y luego por
 teléfono. */ 

SELECT a.razon_social a.dirección a.telef FROM Agencia a 
INNER JOIN Viaje v ON (a.razon_social = v.razon_social) 
INNER JOIN Cliente c ON(c.dni=a.dni)
WHERE c.apellido='Roma' AND cp.origen = 'La Plata'
ORDER BY a.RAZON_SOCIAL, a.telef

/* 2. Listar fecha, hora, datos personales del cliente, nombres de ciudades origen y destino de viajes
 realizados en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’.*/ 

SELECT v.fecha v.hora c.dni c.nombre c.apellido c.telefono c.dirección FROM Viaje v 
INNER JOIN Cliente c ON (v.dni=c.dni)
WHERE v.FECHA BETWEEN '2019-01-01' AND '2019-31-01' AND (v.descripcion LIKE '%demorado%')

/*3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección de
 mail que termine con ‘@jmail.com’.*/

SELECT a.razon_social a.dirección a.telef a.email FROM Agencia a 
INNER JOIN Viaje v ON (a.razon_social=v.razon_social)
WHERE v.fecha BETWEEN '2019-01-01' AND '2019-31-12' OR (a.email LIKE "%@jmail.com")

/*  4. Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
 Brandsen’ */ 

SELECT c.DNI, c.nombre, c.apellido, c.telefono, c.direccion
FROM Cliente c INNER JOIN Viaje v ON (c.DNI = v.DNI)
    INNER JOIN Ciudad ciu ON(v.cpDestino = ciu.CODIGOPOSTAL)
WHERE ciu.nombreCiudad = "Coronel Brandsen" 
EXCEPT (
    SELECT c.DNI, c.nombre, c.apellido, c.telefono, c.direccion
    FROM Cliente c INNER JOIN Viaje v ON (c.DNI = v.DNI)
        INNER JOIN Ciudad ciu ON(v.cpDestino = ciu.CODIGOPOSTAL)
    WHERE NOT (ciu.nombreCiudad = "Coronel Brandsen")
)

/*  5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’. */ 

SELECT COUNT(*) as cantViajes FROM Agencia a 
INNER JOIN Viaje v ON (a.razon_social=v.razon_social)
WHERE a.razon_social = "TAXI Y" AND v.cpDestino='Villa Elisa'

/*  6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias. */ 

SELECT c.nombre c.apellido c.direccion c.telefono FROM Cliente c 
WHERE NOT EXISTS ( SELECT * FROM Agencia a 
                     WHERE NOT EXISTS(
                        SELECT * FROM Viaje v
                        WHERE (a.razon_social = v.razon_social)AND 
                            (c.DNI=v.DNI)
                     ))

/*  7. Modificar el cliente con DNI 38495444 actualizando el teléfono a ‘221-4400897’. */

UPDATE cliente SET telef='221-4400897'
WHERE dni='38495444'

/*  8. Listar razón social, dirección y teléfono de la/s agencias que tengan mayor cantidad de viajes
 realizados. */ 

SELECT a.RAZON_SOCIAL, a.direccion, a.telef
FROM AGENCIA a INNER JOIN VIAJE v ON (a.RAZON_SOCIAL = v.RAZON_SOCIAL)
GROUP BY v.RAZON_SOCIAL, v.direccion, v.telef
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM VIAJE v
    GROUP BY v.RAZON_SOCIAL
)

 /* 9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 10 viajes. */

SELECT c.nombre c.apellido c.direccion c.telefono FROM Cliente c
INNER JOIN Viaje v ON (c.DNI=v.DNI) 
GROUP BY c.nombre c.apellido c.direccion c.telefono 
HAVING COUNT(*) >= 10

/*  10. Borrar al cliente con DNI 40325692. */ 

DELETE FROM Cliente WHERE DNI ='40325692'
DELETE FROM Viaje WHERE DNI="40325692"