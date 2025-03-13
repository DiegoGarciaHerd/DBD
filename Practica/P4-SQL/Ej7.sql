/* Ejercicio 7
 Club = (codigoClub, nombre, anioFundacion, codigoCiudad(FK))
 Ciudad = (codigoCiudad, nombre)
 Estadio = (codigoEstadio, codigoClub(FK), nombre, direccion)
 Jugador = (DNI, nombre, apellido, edad, codigoCiudad(FK))
 ClubJugador = (codigoClub (FK), DNI (FK), desde, hasta) */ 

/*  1. Reportar nombre y año de fundación de aquellos clubes de la ciudad de La Plata que no poseen
 estadio. */
SELECT 
    c.nombre, 
    c.anioFundacion
FROM 
    Club c
JOIN 
    Ciudad ci ON c.codigoCiudad = ci.codigoCiudad
LEFT JOIN 
    Estadio e ON c.codigoClub = e.codigoClub
WHERE 
    ci.nombre = 'La Plata'
    AND e.codigoClub IS NULL;

/*  2. Listar nombre de los clubes que no hayan tenido ni tengan jugadores de la ciudad de Berisso.*/ 

SELECT c.nombre FROM Club c 
INNER JOIN ClubJugador cj ON (c.codigoClub = c.codigoClub) 
WHERE cj.DNI NOT IN (
    SELECT j.DNI
    FROM Jugador j INNER JOIN Ciudad c ON (j.codigoCiudad = c.codigoCiudad)
    WHERE (c.nombre = "Berisso")
)

/*  3. Mostrar DNI, nombre y apellido de aquellos jugadores que jugaron o juegan en el club Gimnasia
 y Esgrima La Plata.*/ 

SELECT dni, nombre, apellido FROM Jugador j 
INNER JOIN ClubJugador cj ON (j.DNI=cj.DNI)
INNER JOIN Club c ON (cj.codigoClub=c.codigoClub)
WHERE c.nombre ='Gimnasia'

/* 4. Mostrar DNI, nombre y apellido de aquellos jugadores que tengan más de 29 años y
hayan jugado o juegan en algún club de la ciudad de Córdoba. */ 

SELECT dni, nombre, apellido FROM Jugador j 
WHERE j.edad > 29 and j.dni IN ( SELECT j.dni FROMJugador j 
                                INNER JOIN ClubJugador cj ON (j.DNI=cj.DNI)
                                INNER JOIN Club c ON (cj.codigoClub=c.codigoClub)
                                INNER JOIN Ciudad ciu ON (c.codigoCiudad=ciu.codigoCiudad)
                                WHERE ciu.nombre= 'Cordoba' 
                                )

 /* 5. Mostrar para cada club, nombre de club y la edad promedio de los jugadores que juegan
 actualmente en cada uno. */ 

SELECT c.nombre AVG(j.edad) FROM Club c 
INNER JOIN ClubJugador cj ON (c.codigoClub=cj.codigoClub)
INNER JOIN Jugador j ON (j.DNI=cj.DNI)
WHERE cj.hasta IS NULL
GROUP BY codigoClub nombre 

 /* 6. Listar para cada jugador nombre, apellido, edad y cantidad de clubes diferentes en los que jugó.
 (incluido el actual) */ 

SELECT j.nombre, j.apellido, j.edad, COUNT(*) as cantidad FROM Jugador j
INNER JOIN ClubJugador ON (j.dni=cj.dni)
GROUP BY j.dni j.nombre j.apellido j.edad 

/*  7. Mostrar el nombre de los clubes que nunca hayan tenido jugadores de la ciudad de Mar del
 Plata. */ 

SELECT c.nombre FROM Club c 
WHERE c.codigoClub NOT IN (
    SELECT c.codigoClub FROM Club C
    INNER JOIN ClubJugador cj ON (c.codigoClub=cj.codigoClub)
    INNER JOIN Jugador j ON (cj.DNI=j.DNI)
    INNER JOIN Ciudad ciu ON (j.codigoCiudad=ciu.codigoCiudad)
    WHERE j.codigoCiudad = 'Mar del Plata'
)

/*  8. Reportar el nombre y apellido de aquellos jugadores que hayan jugado en todos los clubes de la
 ciudad de Córdoba. */ 

SELECT j.nombre j.apellido FROM Jugador j 
WHERE NOT EXISTS ( 
                    SELECT * FROM Club c 
                    INNER JOIN Ciudad ciu ON (c.codigoCiudad=ciu.codigoCiudad)
                    WHERE ciu.nombre = 'Cordoba' AND NOT EXISTS
                    (
                        SELECT * FROM ClubJugador cj 
                        WHERE(j.DNI=cj.DNI) AND (c.codigoClub=cj.codigoClub)
                    )
)

/* 9. Agregar el club “Estrella de Berisso”, con código 1234, que se fundó en 1921 y que pertenece a
 la ciudad de Berisso. Puede asumir que el codigoClub 1234 no existe en la tabla Club. */ 

INSERT INTO Club (codigoClub, nombre, anioFundacion, codigoCiudad(FK)) 
VALUES ("Estrella de Berisso",1234,1921,(
    SELECT c.codigoCiudad
    FROM Ciudad 
    WHERE Ciudad.nombre = "Berisso"
    ))