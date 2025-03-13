/* 
Cliente=(idCliente,nombre,apellido,DNI,telefono,direccion)
Venta=(nroVenta,total,fecha,hora,idCliente(fk))
DetalleVenta(nroVenta(fk),idLibro(fk),cantidad,precioUnitario)
Libro(idLibro,titulo,autor,precio,stock)
*/

/* Listar todos los libros cuyo precio es mayor a 2300 */

SELECT idLibro titulo autor precio stock FROM Libro 
WHERE(precio>2300)

/* Listar todas las ventas realizadas en agosto del 2023 */ 

SELECT nroVenta total hora idCliente FROM Venta 
WHERE fecha BETWEEN '1/1/2023' AND '31/12/2023'

/*Listar nombre,apellido,DNI,telefono,direccion de clientes que realizaron compras solamente durante 2022 */ 

SELECT c.nombre c.apellid c.DNI c.telefono c.direccion
FROM Cliente c INNER JOIN Venta v 
WHERE(V.fecha BETWEEN '1/1/2023' AND '31/12/2023')
EXCEPT 
(SELECT c.nombre c.apellid c.DNI c.telefono c.direccion
FROM Cliente c INNER JOIN Venta v 
WHERE(V.fecha BETWEEN '1/1/2023' AND '31/12/2023'))

/* Listar para cada libro, autor, precio y la cantidad total de veces que fue vendido. Tener en cuenta 
que puede haber libros que no se vendieron*/

SELECT l.autor l.precio COUNT(dv.nroVenta) as cantVentas
FROM Libro LEFT JOIN DetalleVenta dv ON (l.idLibro=dv.idLibro)
GROUP BY l.titulo

/* Listar nroVenta, total,fecha,hora y DNI del cliente, de aquellas ventas donde se haya vendido al menos un libro
con precio mayor a 1000*/

SELECT v.nroVenta v.total v.fecha v.hora c.DNI 
FROM Venta v INNER JOIN Cliente c ON (v.DNI=c.DNI)
INNER JOIN DetalleVenta dv ON(v.nroVenta=dv.nroVenta)
GROUP BY nroVenta v.total ,v.fecha v.hora c.DNI 
HAVING dv.precioUnitario > 1000 