/*  Ejercicio 2
 Localidad = (codigoPostal, nombreL, descripcion, #habitantes)
 Arbol = (nroArbol, especie, años, calle, nro, codigoPostal(fk))
 Podador = (DNI, nombre, apellido, telefono, fnac, codigoPostalVive(fk))
 Poda = (codPoda, fecha, DNI(fk), nroArbol(fk)) */

/* 1. Listar especie, años, calle, nro y localidad de árboles podados por el podador ‘Juan Perez’ y por
 el podador ‘Jose Garcia’.*/

--Solucion 1

SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
    INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
    INNER JOIN Podador p ON (po.DNI = p.DNI)
WHERE (p.nombre = "Juan" AND p.apellido = "Perez") AND a.nroArbol IN (
    SELECT a.nroArbol
    FROM ARBOL a INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
        INNER JOIN Podador p ON (po.DNI = p.DNI)
    WHERE p.nombre = "Jose" AND p.apellido = "Garcia"
    ) 

--Solucion 2

(SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
    INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
    INNER JOIN Podador p ON (po.DNI = p.DNI)
WHERE p.nombre = "Juan" AND p.apellido = "Perez")
INTERSECT(
    SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL
    FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
        INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
        INNER JOIN Podador p ON (po.DNI = p.DNI)
    WHERE p.nombre = "Jose" AND p.apellido = "Garcia"
)

/* 2. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
 podadores que tengan podas realizadas durante 2023.*/

SELECT DISTINCT p.dni p.nombre p.apellido p.fnac l.nombre FROM Poda po 
INNER JOIN Podador p ON (po.DNI = p.DNI)
INNER JOIN Localidad l(l.codigoPostal=p.codigoPostalVive)
WHERE (po.fecha BETWEEN '1/1/2023' AND '31/12/2023')

 /*3. Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca.*/

SELECT a.especie a.años a.calle a.nro l.nombre FROM Arbol a
LEFT JOIN Poda po ON (a.nroArbol = po.nroArbol)
INNER JOIN Podador p ON (po.DNI = p.DNI)
WHERE nroArbol IS NULL

--Solucion 1

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE a.nroArbol NOT IN (
    SELECT a.nroArbol
    FROM Arbol a INNER JOIN Poda po (a.nroArbol = po.nroArbol)
)

--Solucion 3

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE NOT EXIST (
    SELECT *
    FROM Poda p 
    WHERE (p.nroArbol = a.nroArbol)
)

/* 4. Reportar especie, años,calle, nro y localidad de árboles que fueron podados durante 2022 y
no fueron podados durante 2023. */

/* Solucion 1 */
SELECT a.especie a.años a.calle a.nro l.localidad FROM Arbol a 
INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
INNER JOIN Localidad l (l.codigoPostal=a.codigoPostal) 
WHERE po.fecha BETWEEN '1/1/2022' AND '31/12/2022'
AND nroArbol NOT IN (
        SELECT nroArbol FROM Arbol a 
        INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
        WHERE po.fecha BETWEEN '1/1/2023' AND '31/12/2023'
)
/* Solucion 2*/

SELECT a.especie a.años a.calle a.nro l.localidad FROM Arbol a 
INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
INNER JOIN Localidad l (l.codigoPostal=a.codigoPostal) 
WHERE po.fecha BETWEEN '1/1/2022' AND '31/12/2022'
EXCEPT (
    SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
    FROM ARBOL a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
        INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
    WHERE po.fecha BETWEEN "01/01/2023" AND "31/12/2023") 

/*  5. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
 podadores con apellido terminado con el string ‘ata’ y que tengan al menos una poda durante
 2024. Ordenar por apellido y nombre. */ 

SELECT p.DNI p.nombre p.apellido p.fnac l.localidad FROM Podador p 
INNER JOIN Poda po ON (p.dni=po.dni)
INNER JOIN Localidad l ON (p.codigoPostalVive=l.codigoPostal)
WHERE (p.apellido LIKE "%ata") AND nombre IN (
    SELECT nombre FROM Podador 
    INNER JOIN Poda
    WHERE(poda.fecha BETWEEN '1/1/2024' AND '31/12/2024') 
)
ORDER BY p.nombre p.apellido

/*  6. Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron
 árboles de especie ‘Coníferas’. */

SELECT p.DNI p.apellido p.nombre p.telefono p.fnac FROM Podador p 
INNER JOIN Poda po (p.DNI=po.DNI)
INNER JOIN Arbol a (a.codigoPostal=p.codigoPostal)
WHERE(a.especie='Coniferas')
EXCEPT
(
    SELECT p.DNI, p.nombre, p.apellido, p.telefono, p.fnac
    FROM Podador p INNER JOIN Poda po ON (p.DNI = po.DNI)
        INNER JOIN Arbol a ON (po.nroArbol = a.nroArbol)
        WHERE NOT (a.especie = "Coniferas")
)

/*  7. Listar especies de árboles que se encuentren en la localidad de ‘La Plata’ y también en la
 localidad de ‘Salta’*/

SELECT a.especie FROM Arbol a 
INNER JOIN Localidad l ON (a.codigoPostal=l.codigoPostal)
WHERE (l.nombre='La Plata') 
INTERSECT 
(SELECT a.especie
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE l.nombreL = "Salta")

/*  8. Eliminar el podador con DNI 22234566. */ 

DELETE FROM Podador
WHERE dni='22234566'

DELETE FROM Poda
WHERE dni='22234566'

/* 9. Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de 100
 árboles. */

SELECT l.nombre l.descripcion l.cantidad
FROM Localidad l
INNER JOIN Arbol a (a.codigoPostal=l.codigoPostal)
GROUP BY l.nombre
HAVING COUNT(*) < 100

