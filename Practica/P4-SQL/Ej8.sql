/*  Ejercicio 8
 Equipo = (codigoE, nombreE, descripcionE)
 Integrante = (DNI, nombre, apellido,ciudad,email, telefono,codigoE(fk))
 Laguna = (nroLaguna, nombreL, ubicación,extension, descripción)
 TorneoPesca = (codTorneo, fecha,hora, nroLaguna(fk), descripcion)
 Inscripcion = (codTorneo(fk),codigoE(fk), asistio, gano) // asistio y gano son true o false según
 corresponda */ 

/*  1. Listar DNI, nombre, apellido y email de integrantes que sean de la ciudad ‘La Plata’ y estén
 inscriptos en torneos disputados en 2023. */ 

SELECT dni, nombre, apellido, email FROM Integrante i 
INNER JOIN Equipo E ON (i.codigoE=e.codigoE)
INNER JOIN Inscripcion Ins ON (ins.codigoE=e.codigoE)
INNER JOIN TorneoPesca tp ON (tp.codTorneo=ins.codTorneo)
WHERE i.ciudad='La plata' and t.fecha BETWEEN 

/* 6. Eliminar el equipo con código:10000. */ 

DELETE FROM Equipo WHERE codigoE=10000
DELETE FROM Integrante WHERE codigoE="10000"
DELETE FROM Equipo WHERE codigoE="10000"

 /*7. Listar nombre, ubicación,extensión y descripción de lagunas que no tuvieron torneos.*/ 

SELECT nombreL, ubicación , extension , descripcion FROM Laguna l 
LEFT JOIN TorneoPesca tp (l.nroLaguna=tp.nroLaguna)
WHERE tp.codTorneo IS NULL

/* 8. Reportar nombre y descripción de equipos que tengan inscripciones a torneos a disputarse durante
 2024, pero no tienen inscripciones a torneos de 2023. */ 

SELECT 