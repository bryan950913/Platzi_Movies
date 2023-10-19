CREATE OR REPLACE FUNCTION count_total_movies()
RETURNS INT
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN COUNT (*) FROM peliculas;
END
$$;

SELECT count_total_movies();

-------------------------------------------------

CREATE OR REPLACE FUNCTION movies_stats()
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    total_rated_r REAL := 0.0;
    total_larger_than_100 REAL := 0.0; 
    total_published_2006 REAL := 0.0;
    duration_avg REAL := 0.0;
    rental_price_avg REAL := 0.0;
BEGIN
    total_rated_r := count(*) from peliculas WHERE clasificacion = 'R';
    total_larger_than_100 := count(*) FROM peliculas WHERE duracion > 100;
    total_published_2006 := count(*) FROM peliculas WHERE anio_publicacion = 2006;
    duration_avg := avg(duracion) FROM peliculas;
    rental_price_avg := avg(precio_renta) FROM peliculas;
    
    TRUNCATE table peliculas_estadisticas;
    
    INSERT INTO peliculas_estadisticas(tipo_estadistica,total) VALUES 
        ('Peliculas con clasificacion R', total_rated_r),
        ('Peliculas de mas de 100 minutos', total_larger_than_100),
        ('Peliculas publicadas en 2006',total_published_2006),
        ('Promedio de duracion en minutos', duration_avg),
        ('Precio promedio de renta', rental_price_avg);
END
$$;

SELECT movies_stats();

SELECT max(precio_renta)
FROM peliculas;

SELECT titulo, max(precio_renta)
FROM peliculas
GROUP BY titulo;

SELECT titulo, min(precio_renta)
FROM peliculas
GROUP BY titulo;

SELECT  SUM(precio_renta)
FROM peliculas;

SELECT clasificacion, COUNT(*)
FROM peliculas
GROUP BY clasificacion;

SELECT AVG(precio_renta)
FROM peliculas;

SELECT clasificacion, AVG(precio_renta) AS precio_promedio
FROM peliculas
GROUP BY clasificacion
ORDER BY precio_promedio DESC;

SELECT clasificacion, AVG(duracion) AS duracion_promedio
FROM peliculas
GROUP BY clasificacion
ORDER BY duracion_promedio DESC;

SELECT clasificacion, AVG(duracion_renta) AS duracion_renta_promedio
FROM peliculas
GROUP BY clasificacion
ORDER BY duracion_renta_promedio DESC;

SELECT	ciudades.ciudad_id,
		ciudades.ciudad,
		COUNT(*) AS rentas_por_ciudad
FROM	ciudades
	INNER JOIN direcciones ON ciudades.ciudad_id = direcciones.ciudad_id
	INNER JOIN tiendas ON tiendas.direccion_id = direcciones.direccion_id
	INNER JOIN inventarios ON inventarios.tienda_id = tiendas.tienda_id
	INNER JOIN rentas ON inventarios.inventario_id = rentas.inventario_id
GROUP BY	ciudades.ciudad_id;

SELECT	date_part('year', rentas.fecha_renta) AS anio,
		date_part('month', rentas.fecha_renta) AS mes,
		peliculas.titulo,
		count(*) AS numero_rentas
FROM	rentas
	INNER JOIN	inventarios ON rentas.inventario_id = inventarios.inventario_id
	INNER JOIN	peliculas ON peliculas.pelicula_id	= inventarios.pelicula_id
GROUP BY anio, mes, peliculas.pelicula_id;

SELECT	date_part('year', rentas.fecha_renta) AS anio,
		date_part('month', rentas.fecha_renta) AS mes,
		count(*) AS numero_rentas
FROM	rentas
GROUP BY anio, mes;