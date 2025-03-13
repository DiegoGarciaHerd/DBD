/*  Ejercicio 3
 Banda = (codigoB, nombreBanda, genero_musical, año_creacion)
 Integrante = (DNI, nombre, apellido, dirección, email, fecha_nacimiento, codigoB(fk))
 Escenario = (nroEscenario, nombre_escenario, ubicación, cubierto, m2, descripción)
 Recital = (fecha, hora, nroEscenario (fk), codigoB (fk)) */

/* 1. Listar DNI, nombre, apellido,dirección y email de integrantes nacidos entre 1980 y 1990 y que
 hayan realizado algún recital durante 2023.*/

SELECT i.DNI i.nombre i.apellido i.direccion i.email FROM Integrante i
INNER JOIN Banda b (i.codigoB=b.codigoB)
INNER JOIN Recital r(r.codigoB=b.codigoB)
WHERE (i.fecha_nacimiento BETWEEN "1/1/1980" AND "31/12/1990") AND IN (
    SELECT i.DNI
    FROM Recital r INNER JOIN Banda b ON (r.codiboB = b.codigoB)
        INNER JOIN Integrante i ON (b.codigoB = i.codigoB)
    WHERE r.fecha BETWEEN "01/01/2018" AND "31/12/2018"
)

/* 2. Reportar nombre, género musical y año de creación de bandas que hayan realizado recitales
 durante 2023, pero no hayan tocado durante 2022 .*/

SELECT b.nombreBanda b.genero_musical b.año_creacion FROM Banda b 
INNER JOIN Recital r ON (b.codiboB=r.codiboB)
WHERE (r.fecha BETWEEN '1/1/2023' AND '31/12/2023') 
EXCEPT 
(SELECT b.nombreBanda b.genero_musical b.año_creacion FROM Banda b 
INNER JOIN Recital r ON (b.codiboB=r.codiboB)
WHERE (r.fecha BETWEEN '1/1/2022' AND '31/12/2022 '))

/*  3. Listar el cronograma de recitales del día 04/12/2023. Se deberá listar nombre de la banda que
 ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente.*/ 

SELECT b.nombreBanda r.fecha r.hora e.nombre e.ubicación 
FROM Banda b INNER JOIN Recital r ON (b.codigoB=r.codiboB)
INNER JOIN Escenario ON (e.nroEscenario=r.nroEscenario)
WHERE (r.fecha = '04/12/2023')
ORDER BY r.hora

/* 4. Listar DNI, nombre, apellido,email de integrantes que hayan tocado en el escenario con nombre
 ‘Gustavo Cerati’ y en el escenario con nombre ‘Carlos Gardel’.*/ 
SELECT i.DNI i.nombre i.apellido i.email FROM Integrante 
INNER JOIN Banda b ON (i.codigoB=b.codiboB) 
INNER JOIN Recital r ON (r.codibo=b.codiboB)
INNER JOIN Escenario e ON (r.nroEscenario=e.nroEscenario)
WHERE (e.nombre_escenario = 'Gustavo Cerati')
INTERSECT 
(SELECT i.DNI i.nombre i.apellido i.email FROM Integrante 
INNER JOIN Banda b ON (i.codigoB=b.codiboB) 
INNER JOIN Recital r ON (r.codibo=b.codiboB)
INNER JOIN Escenario e ON (r.nroEscenario=e.nroEscenario)
WHERE (e.nombre_escenario = 'Carlos Gardel'))

/* 5. Reportar nombre, género musical y año de creación de bandas que tengan más de 8 integrantes. */

SELECT b.nombreBanda b.genero_musical b.año_creacion FROM Banda b
INNER JOIN Integrante i ON (b.codiboB=i.codigoB)
GROUP BY b.nombreBanda
HAVING COUNT(*) > 8

/*  6. Listar nombre de escenario, ubicación y descripción de escenarios que solo tuvieron recitales
 con el género musical rock and roll. Ordenar por nombre de escenario */

SELECT e.nombre_escenario e.ubicación e.ubicación FROM Escenario e 
INNER JOIN Recital r ON (e.nroEscenario=r.nroEscenario) 
INNER JOIN Banda b ON (r.codigoB=b.codigoB)
WHERE (b.genero_musical = 'Rock n roll') AND e.nombre_escenario NOT IN
(SELECT e.nombre_escenario 
INNER JOIN Recital r ON (e.nroEscenario=r.nroEscenario) 
INNER JOIN Banda b ON (r.codigoB=b.codigoB)
WHERE (b.genero_musical <> 'Rock n roll'))
ORDER BY e.nombre_escenario

 /* 7. Listar nombre, género musical y año de creación de bandas que hayan realizado recitales en
 escenarios cubiertos durante 2023.// cubierto es true, false según corresponda */ 

SELECT b.nombreBanda b.genero_musical b.año_creacion FROM Banda b 
INNER JOIN Recital r ON (b.codiboB = r.codigoB) 
INNER JOIN Escenario e ON (r.nroEscenario=e.nroEscenario)
WHERE(e.cubierto=true) AND (r.fecha BETWEEN "01/01/2023" AND "31/12/2023") 

/*  8. Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2024. */ 

SELECT 
    e.nombre_escenario, COUNT(r.nroEscenario) AS CantRecitales
FROM 
    escenario e
LEFT JOIN 
    recital r ON e.nroEscenario = r.nroEscenario AND YEAR(r.fecha) = 2024 /* si es 0 tambien va a aparecer en la consulta) */
GROUP BY 
    e.nroEscenario, e.nombre_escenario
ORDER BY 
    e.nombre_escenario;

/*  9. Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’. */ 

UPDATE banda SET nombreBanda='Memphis la Blusera' WHERE nombreBanda='Mempis la Blusera'

