 /* Ejercicio 6
 Técnico = (codTec, nombre, especialidad) // técnicos
 Repuesto = (codRep, nombre, stock, precio) // repuestos
 RepuestoReparacion = (nroReparac (fk), codRep (fk), cantidad, precio) // repuestos utilizados en
 reparaciones.
 Reparación (nroReparac, codTec (fk), precio_total, fecha) // reparaciones realizadas. */ 

/*  1. Listar los repuestos, informando el nombre, stock y precio. Ordenar el resultado por precio. */

SELECT nombre, stock, precio FROM Repuesto 
ORDER BY precio

 /* 2. Listar nombre, stock y precio de repuestos que se usaron en reparaciones durante 2023 y que no
 se usaron en reparaciones del técnico ‘José Gonzalez’.*/

SELECT r.nombre r.stock r.precio FROM Repuesto r 
INNER JOIN RepuestoReparacion rr ON (r.codRep=rr.codRep)
INNER JOIN Reparacion repa ON (rr.nroReparac=repa.nroReparac)
WHERE r.fecha BETWEEN ('1/1/2023' AND '31/12/2023') AND r.nombre NOT IN ( SELECT r.nombre 
    INNER JOIN repuestoreparacion repu2 ON r2.codRep = repu2.codRep
    INNER JOIN reparacion repa2 ON repa2.nroReparac = repu2.nroReparac
    INNER JOIN tecnico t ON t.codTec = repa2.codTec
    WHERE t.nombre = 'Jose Gonzalez'
)

/*  3. Listar el nombre y especialidad de técnicos que no participaron en ninguna reparación. Ordenar
 por nombre ascendentemente. */ 

SELECT t.nombre, t.especialidad
FROM tecnico t
WHERE NOT EXISTS (
    SELECT *
    FROM reparacion r
    WHERE t.codTec = r.codTec
)
ORDER BY t.nombre

/* 4. Listar el nombre y especialidad de los técnicos que solamente participaron en reparaciones
 durante 2022. */

SELECT DISTINCT t.nombre, t.especialidad
FROM Tecnico t INNER JOIN Reparacion repa (t.codTec = repa.codTec)
WHERE repa.fecha BETWEEN "01/01/2018" AND "31/12/2018" 
EXCEPT (
    SELECT t.nombre, t.especialidad
    FROM Tecnico t INNER JOIN Reparacion repa (t.codTec = repa.codTec)
    WHERE NOT(repa.fecha BETWEEN "01/01/2018" AND "31/12/2018")
)

/* 5. Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo
utilizaron. Si un repuesto no participó en alguna reparación igual debe aparecer en
dicho listado. */

SELECT r.nombre , r.stock, COUNT(DISTINCT t.codTec) cantTecnicos FROM Repuesto r
LEFT JOIN RepuestoReparacion rr ON (rr.codRep=r.codRep) 
INNER JOIN Reparacion repa ON (rr.nroReparac=repa.nroReparac)
GROUP BY r.codRep r.nombre r.stock 

/* 6. Listar nombre y especialidad del técnico con mayor cantidad de reparaciones
realizadas y el técnico con menor cantidad de reparaciones. */

SELECT t.nombre t.especialidad FROM Tecnico t 
INNER JOIN Reparacion r ON (t.codTec=r.codTec)
GROUP BY t.codTec t.nombre t.especialidad 
HAVING COUNT(*) ALL>= ( SELECT COUNT(*) FROM Tecnico t 
                        INNER JOIN Reparacion r ON (t.codTec=r.codTec)
                        GROUP BY t.codTec
                        )

SELECT t.nombre, t.especialidad
FROM Tecnico t INNER JOIN Reparacion repa (t.codTec = repa.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad 
HAVING COUNT(*) <=ALL(
    SELECT COUNT(*)
    FROM Reparacion repa
    GROUP BY repa.codTec
)

/*  7. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto
 no haya estado en reparaciones con un precio total superior a $10000.*/

SELECT r.nombre r.stock r.precio FROM Repuesto r 
WHERE r.stock > 0 AND r.codRep NOT IN ( SELECT r.codRep FROM Reparacion repa 
                                            WHERE repa.precio_total>10000
                                            )

/* 8. Proyectar número, fecha y precio total de aquellas reparaciones donde se utilizó algún repuesto
 con precio en el momento de la reparación mayor a $10000 y menor a $15000.*/ 

SELECT DISTINCT r.nroReparac r.fecha r.precio_total FROM Reparacion r 
INNER JOIN RepuestoReparacion rr ON(r.nroReparac=rr.nroReparac)
WHERE rr.precio > 10000 and rr.precio<15000

/* 9. Listar nombre, stock y precio de repuestos que hayan sido utilizados por todos los técnicos. */ 

SELECT r.nombre ,r.stock ,r.precio FROM Respuesto r
WHERE NOT EXISTS ( SELECT t.codTec FROM Tecnico t 
                    WHERE NOT EXISTS ( 
                            SELECT repa.codRep FROM Reparacion repa 
                            INNER JOIN RepuestoReparacion rr ON(rr.nroReparac=repa.nroReparac)
                            WHERE (r.codRep=rr.codRep) AND (t.codTec=repa.codTec)                 
                    )
                )       

/*  10. Listar fecha, técnico y precio total de aquellas reparaciones que necesitaron al menos 10
 repuestos distintos. */ 

SELECT repa.fecha repa.codTec repa.precio_total FROM Reparacion repa 
INNER JOIN RepuestoReparacion rr ON (repa.nroReparac=rr.nroReparac)
GROUP BY repa.fecha repa.codTec repa.precio_total 
HAVING COUNT(rr.codRep) >= 10