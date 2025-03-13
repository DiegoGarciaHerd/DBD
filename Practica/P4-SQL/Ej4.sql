/* Ejercicio 4
 PERSONA=(DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
 ALUMNO=(DNI (fk), Legajo, Año_Ingreso)
 PROFESOR=(DNI (fk), Matricula, Nro_Expediente)
 TITULO = (Cod_Titulo, Nombre, Descripción)
 TITULO-PROFESOR = (Cod_Titulo (fk), DNI (fk), Fecha)
 CURSO=(Cod_Curso, Nombre, Descripción, Fecha_Creacion, Duracion)
 ALUMNO-CURSO =(DNI (fk), Cod_Curso (fk), Año, Desempeño, Calificación)
 PROFESOR-CURSO = (DNI (fk), Cod_Curso (fk), Fecha_Desde, Fecha_Hasta) */

/* 1. Listar DNI, legajo y apellido y nombre de todos los alumnos que tengan año de ingreso inferior a
 2014.*/

SELECT a.DNI a.legajo p.Apellido p.nombre FROM Alumno a 
INNER JOIN Persona p ON (a.DNI=p.DNI)
WHERE (a.Año_Ingreso < 2014) 

 /* 2. Listar DNI, matrícula, apellido y nombre de los profesores que dictan cursos que tengan más de
 100 horas de duración. Ordenar por DNI. */

SELECT prof.DNI prof.matrícula p.apellido p.nombre FROM Profesor prof 
INNER JOIN Persona p ON (p.DNI=prof.DNI) 
INNER JOIN PROFESOR-CURSO pc ON (pc.DNI=p.DNI)
INNER JOIN Curso c ON (c.Cod_Curso = pc.Cod_Curso)
WHERE ( c.Duracion > 100)
ORDER BY p.DNI

/* 3. Listar el DNI, Apellido, Nombre, Género y Fecha de nacimiento de los alumnos inscriptos al
 curso con nombre “Diseño de Bases de Datos” en 2023.*/

SELECT a.DNI p.apellido p.nombre p.genero p.fecha_nacimiento FROM Alumno a 
INNER JOIN Persona p ON (a.DNI=p.DNI) 
INNER JOIN ALUMNO-CURSO ac ON (a.DNI=ac.DNI) 
INNER JOIN CURSO c ON (c.Cod_Curso=ac.Cod_Curso)
WHERE (c.nombre = 'Diseño de Bases de Datos') AND (ac.año = 2023)

/*  4. Listar el DNI, Apellido, Nombre y Calificación de aquellos alumnos que obtuvieron una
 calificación superior a 8 en algún curso que dicta el profesor “Juan Garcia”. Dicho listado deberá
 estar ordenado por Apellido y nombre. */ 

SELECT a.DNI p.apellido p.nombre ac.calificación FROM Alumno a 
INNER JOIN ALUMNO-CURSO ac (a.dni=ac.dni)
INNER JOIN Curso c (c.Cod_Curso=ac.Cod_Curso)
INNER JOIN PROFESOR-CURSO pc (pc.Cod_Curso=pc.Cod_Curso)
INNER JOIN Profesor p(pc.dni=p.dni)
WHERE (ac.calificación > 8) AND (p.nombre='Juan') AND (p.apellido='Garcia')
ORDER BY p.apellido p.nombre

 /* 5. Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3 títulos.
 Dicho listado deberá estar ordenado por Apellido y Nombre.*/

SELECT p.DNI p.apellido p.nombre prof.matrícula
FROM Profesor prof 
INNER JOIN Persona p ON(p.DNI=prof.DNI) 
INNER JOIN Profesor-Titulo pt ON(p.DNI=pt.DNI)
GROUP BY p.nombre p.apellido 
HAVING COUNT(pt.Cod_Titulo) > 3
ORDER BY p.apellido p.nombre

/*  6. Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada profesor.
 La cantidad de horas se calcula como la suma de la duración de todos los cursos que dicta. */ 

SELECT p.DNI p.apellido p.nombre SUM(c.duracion) as cantHoras AVG(c.duracion) as promedioHoras
FROM Profesor prof INNER JOIN Persona p ON(prof.DNI=p.DNI)
INNER JOIN Profesor-curso pc ON(prof.DNI=pc.DNI) 
INNER JOIN Curso c ON(c.Cod_Curso=pc.Cod_Curso) 
GROUP BY prof.DNI p.apellido p.nombre 

/*  7. Listar Nombre y Descripción del curso que posea más alumnos inscriptos y del que posea
 menos alumnos inscriptos durante 2024.*/

SELECT c.nombre c.descripcion 
FROM Curso c INNER JOIN Alumno-curso ac ON (c.Cod_Curso=ac.Cod_Curso)
WHERE ac.Año = 2024
GROUP BY c.Cod_Curso c.Nombre, c.Descripción
HAVING COUNT(*) >ALL (
    SELECT COUNT(*)
    FROM Curso c INNER JOIN Alumno-curso ac ON (c.Cod_Curso=ac.Cod_Curso)
    WHERE ac.Año = 2024
    GROUP BY c.Cod_Curso 
)
UNION 
SELECT c.Nombre, c.Descripción
FROM CURSO c INNER JOIN ALUMNO-CURSO ac ON (c.Cod_Curso = ac.Cod_Curso)
WHERE ac.Año = "2024"
GROUP BY c.Cod_Curso, c.Nombre, c.Descripción
HAVING COUNT(*) <= ALL (
    SELECT COUNT (*)
    FROM ALUMNO-CURSO ac
    WHERE ac.Año = "2024"
    GROUP BY ac.Cod_Curso
)

/*8. Listar el DNI, Apellido, Nombre y Legajo de alumnos que realizaron cursos con nombre
conteniendo el string ‘BD’ durante 2022 pero no realizaron ningún curso durante 2023. */ 

SELECT a.DNI, p.Apellido, p.Nombre, a.Legajo
FROM ALUMNO a INNER JOIN PERSONA p ON (a.DNI = p.DNI)
    INNER JOIN ALUMNO-CURSO ac ON (p.DNI = ac.DNI)
    INNER JOIN CURSO c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE (c.Nombre LIKE "%BD%") AND (ac.Año = "2018")
EXCEPT (
    SELECT a.DNI, p.Apellido, p.Nombre, a.Legajo
    FROM ALUMNO a INNER JOIN PERSONA p ON (a.DNI = p.DNI)
    INNER JOIN ALUMNO-CURSO ac ON (p.DNI = ac.DNI)
    WHERE (ac.Año = "2019")
)
 
/* 9. Agregar un profesor con los datos que prefiera y agregarle el título con código: 25.*/

INSERT INTO Persona (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero) 
VALUES (4323433,'Pablo','Marquez','12/11/2000','Soltero','Masculino')

INSERT INTO Profesor (DNI (fk), Matricula, Nro_Expediente) VALUES (4323433,1758,123)

INSERT INTO TITULO-PROFESOR(Cod_Titulo (fk), DNI (fk), Fecha) VALUES(25,4323433,'1/2/2024')

INSERT INTO

 /*10. Modificar el estado civil del alumno cuyo legajo es ‘2020/09’, el nuevo estado civil es divorciado.*/

UPDATE Alumno SET Estado_Civil='Divorciado' WHERE legajo='2020/09'

/*11. Dar de baja el alumno con DNI 30568989. Realizar todas las bajas necesarias para no dejar el
 conjunto de relaciones en un estado inconsistente.*/

DELETE FROM Persona WHERE DNI='30568989'
DELETE FROM Alumno WHERE DNI='30568989' 
DELETE FROM Alumno-curso WHERE DNI='30568989'