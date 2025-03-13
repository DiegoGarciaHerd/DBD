/* Ejercicio 9
 Proyecto = (codProyecto, nombrP,descripcion, fechaInicioP, fechaFinP, fechaFinEstimada,
 DNIResponsable(FK), equipoBackend(FK), equipoFrontend(FK)) // DNIResponsable corresponde a un
 empleado, equipoBackend y equipoFrontend corresponden a equipos
 Equipo = (codEquipo, nombreE, descTecnologias, DNILider(FK))//DNILider corresponde a un empleado
 Empleado = (DNI, nombre, apellido, telefono, direccion, fechaIngreso)
 Empleado_Equipo = (codEquipo(FK, DNI(FK), fechaInicio, fechaFin, descripcionRol) */ 

/*  6. Modificar nombre, apellido y dirección del empleado con DNI 40568965 con los datos que desee. */ 

UPDATE Empleado SET nombre=Diego , dirección=20 , apellido=gh WHERE DNI=40568965