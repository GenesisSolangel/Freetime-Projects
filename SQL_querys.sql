DROP SCHEMA IF EXISTS airlines;
CREATE DATABASE IF NOT EXISTS airlines;
USE airlines;
CREATE TABLE aerolineas (
    icao VARCHAR(3),
    aerolinea VARCHAR(255),
    iata VARCHAR(2),
    country VARCHAR(255),
    founded INT,
    started_operations INT,
    air_group VARCHAR(255),
    base VARCHAR(255),
    fleet_size FLOAT,
    average_fleet_age FLOAT,
    official_site VARCHAR(255),
    PRIMARY KEY (icao)
);

CREATE TABLE estados (
    estado VARCHAR(2),
    nombre_estado VARCHAR(255),
    PRIMARY KEY (estado)
);

CREATE TABLE aeropuertos (
    codigo_aeropuerto VARCHAR(3),
    nombre_aeropuerto VARCHAR(255),
    ciudad VARCHAR(255),
    estado VARCHAR(2),
    latitud FLOAT,
    longitude FLOAT,
    direccion VARCHAR(255),
    PRIMARY KEY (codigo_aeropuerto),
    FOREIGN KEY (estado) REFERENCES estados (estado)
);

CREATE TABLE distancias (
    distancia_millas FLOAT,
    aeropuerto_origen VARCHAR(3),
    aeropuerto_destino VARCHAR(3),
    PRIMARY KEY (aeropuerto_origen , aeropuerto_destino),
    FOREIGN KEY (aeropuerto_origen) REFERENCES aeropuertos (codigo_aeropuerto),
    FOREIGN KEY (aeropuerto_destino) REFERENCES aeropuertos (codigo_aeropuerto)
    );

CREATE TABLE vuelos (
    aerolinea VARCHAR(3) NOT NULL,
    fecha DATE,
    numero_vuelo INT,
    numero_cola VARCHAR(255),
    hora_salida_programada TIME,
    hora_salida_real TIME,
    duracion_programada_vuelo INT,
    duracion_real INT,
    retraso_salida INT,
    hora_despegue TIME,
    tiempo_pista_salida INT,
    tiempo_retraso_aerolinea INT,
    tiempo_retraso_clima INT,
    tiempo_retraso_sistema_aviacion INT,
    tiempo_retraso_seguridad INT,
    retraso_llegada INT,
    aeropuerto_origen VARCHAR(3),
    hora_llegada_real TIME,
    festivos TINYINT,
    aeropuerto_destino VARCHAR(3),
    PRIMARY KEY (numero_vuelo),
    FOREIGN KEY (aerolinea) REFERENCES aerolineas (icao),
    FOREIGN KEY (aeropuerto_origen) REFERENCES aeropuertos (codigo_aeropuerto),
    FOREIGN KEY (aeropuerto_destino) REFERENCES aeropuertos (codigo_aeropuerto)
);

-- ¿Que 5 aerolineas tienen el tamaño de flota más grande?
SELECT aerolinea, fleet_size
FROM aerolineas
ORDER BY fleet_size DESC
LIMIT 5;

-- ¿Que distancia (en millas) tardaría en ir desde **ATL** a **JAN**?
SELECT distancia_millas
FROM distancias
WHERE aeropuerto_origen LIKE 'ATL' AND aeropuerto_destino LIKE 'JAN';

-- ¿Cual es la distancia más grande entre 2 aeropuertos? 
SELECT distancia_millas
FROM distancias
ORDER BY distancia_millas DESC
LIMIT 1;

-- ¿Qué ciudad tiene más aeropuertos?
SELECT ciudad, COUNT(codigo_aeropuerto) AS n_aeropuertos
FROM aeropuertos
GROUP BY ciudad
ORDER BY n_aeropuertos DESC
LIMIT 1;

-- Usando la tabla de **vuelos**, ¿Que **aerolinea** tuvo la mayor cantidad de vuelos en todas las fechas?
SELECT aerolinea, COUNT(*) AS n_vuelos
FROM vuelos
GROUP BY aerolinea
ORDER BY n_vuelos DESC
LIMIT 1;

-- ¿Cuantas millas se recorrieron en total el día **2021-12-31**?
SELECT SUM(distancia_millas)
FROM vuelos v
INNER JOIN distancias d ON v.aeropuerto_origen = d.aeropuerto_origen AND v.aeropuerto_destino = d.aeropuerto_destino
WHERE fecha = "2021-12-31"
;

-- Muestra en orden los 5 días con más retrasos y la media de retraso para cada día.
SELECT fecha, SUM(retraso_llegada) AS retraso, AVG(retraso_llegada) AS media_retraso
FROM vuelos
GROUP BY fecha
ORDER BY retraso DESC
LIMIT 5;

-- Muestra los nombres de las 10 aerolineas que tenga menos retraso que la media.
SELECT a.aerolinea, AVG(retraso_llegada) AS media_retraso
FROM vuelos v
INNER JOIN aerolineas a ON v.aerolinea=a.icao
GROUP BY aerolinea
HAVING media_retraso < (
    SELECT AVG(retraso_llegada) FROM vuelos
)
ORDER BY media_retraso ASC
LIMIT 10;

SELECT aerolinea, MAX(fleet_size)
FROM aerolineas
GROUP BY aerolinea;