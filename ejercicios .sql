--Clase 7 sesion 3

-- • ON DELETE SET NULL: coloca nulos en todas las claves secundarias relacionadas. 
-- • ON DELETE CASCADE: borra todas las filas relacionadas con aquella que hemos eliminado. 
-- • ON DELETE SET DEFAULT: coloca en las filas relacionadas el valor por defecto de esa columna en la columna relacionada. 
-- • ON DELETE NOTHING: no hace nada.

-- Ejemplo:


CREATE TABLE prestamos (
    id SERIAL PRIMARY KEY,
    fecha_prestamo DATE,
    id_usuario INT,
    id_libro INT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE SET NULL, --
    FOREIGN KEY (id_libro) REFERENCES libros(id) ON DELETE NOTHING --
);


-- Operadores Básicos de SQL

-- +  -  *  /  


-- concatenación (||):    SELECT nombre || ' ' || apellido FROM alumnos; 

-- Comparación (<, >, =, >=, <=, IN, LIKE, BETWEEN):
-- IN: Verifica si un valor está dentro de un conjunto.
-- LIKE: Busca patrones en cadenas de texto (% reemplaza uno o más caracteres).
-- BETWEEN: Determina si un valor está dentro de un rango.

-- Lógicos (AND, OR, NOT, IS NULL):
-- AND, OR: Combinan condiciones. AND devuelve verdadero si todas las condiciones son verdaderas, mientras que OR devuelve verdadero si alguna condición es verdadera.
-- NOT: Invierte el resultado de la condición.
-- IS NULL: Verifica si un valor es nulo
---------------------------------------------------------------------------------

-- Sentencia SELECT

-- SELECT id_libro AS codigo FROM libros;

-- AS (renombrar)
-- DISTINCT elimina duplicados
-----------------------------------------------------------------------------------------
-- Funciones de Agregación
-- Son utilizadas para realizar cálculos sobre un conjunto de registros y devolver un solo valor.
-- COUNT: Cuenta el número de registros.
-- MIN: Encuentra el valor mínimo.
-- MAX: Encuentra el valor máximo.
-- SUM: Calcula la suma de valores.
-- AVG: Calcula el promedio.

-----------------------------------------
--Ejercicios de clase

CREATE DATABASE ejercicios_sql;
\c ejercicios_sql;

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(50) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL
);

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    departamento VARCHAR(50) NOT NULL,
    salario NUMERIC(10, 2) NOT NULL
);

CREATE TABLE alumnos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    nota NUMERIC(4, 2) NOT NULL,
    telefono VARCHAR(15)
);

INSERT INTO productos (nombre_producto, precio) VALUES
('Producto A', 60.00),
('Producto B', 150.00),
('Producto C', 45.00),
('Producto D', 220.00),
('Producto E', 75.00);


INSERT INTO empleados (nombre, departamento, salario) VALUES
('Juan', 'Ventas', 3000.00),
('Ana', 'Ventas', 3500.00),
('Luis', 'Marketing', 2500.00),
('María', 'Marketing', 4000.00),
('Pedro', 'Ventas', 3300.00),
('Sofía', 'Recursos Humanos', 2800.00),
('Jorge', 'Recursos Humanos', 2900.00);


INSERT INTO alumnos (nombre, nota, telefono) VALUES
('Andrés', 9.0, NULL),
('Beatriz', 7.5, '123456789'),
('Carlos', 8.5, '987654321'),
('Ana', 9.5, NULL),
('Daniel', 6.0, '567890123');



-----------------------
SELECT nombre_producto, precio, precio * 0.9 AS precio_descuento
FROM productos
WHERE precio BETWEEN 50 AND 200;
-------------------
SELECT departamento, COUNT(*) AS total_empleados, AVG(salario) AS salario_promedio
FROM empleados
GROUP BY departamento
HAVING COUNT(*) > 2
ORDER BY salario_promedio DESC;
-----------------------
SELECT COUNT(*) AS total_alumnos
FROM alumnos
WHERE (nota > 8 OR nombre LIKE 'A%')
AND telefono IS NOT NULL;

-------------------------------------------------------------------------------------------------

-- Ejercicio 1: Gestión de Inventario en una Tienda
-- Consigna
-- Se requiere gestionar un inventario para una tienda que vende productos de tecnología. El objetivo es crear una base de datos que permita realizar consultas sobre los productos disponibles, sus categorías y el historial de ventas.

-- Crear la base de datos:
CREATE DATABASE tienda_tecnologia;
-- Crear las tablas:

-- Tabla productos con los campos: id_producto (serial, PK), nombre_producto (varchar(50), NOT NULL), precio (numeric, NOT NULL), stock (int, NOT NULL), categoria (varchar(50)).
-- Tabla ventas con los campos: id_venta (serial, PK), id_producto (int, NOT NULL), cantidad (int, NOT NULL), fecha_venta (date, NOT NULL), total_venta (numeric).
-- Tabla categorias con los campos: id_categoria (serial, PK), nombre_categoria (varchar(50), NOT NULL).
CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(50) NOT NULL,
    precio NUMERIC NOT NULL,
    stock INT NOT NULL,
    categoria VARCHAR(50)
);

CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    fecha_venta DATE NOT NULL,
    total_venta NUMERIC,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL
);
-- Insertar datos de prueba:

-- Inserta al menos 5 productos, 3 categorías y 3 ventas en la base de datos.
-- Asegúrate de que algunas ventas sean de productos con categoría "Electrónica" y "Accesorios".

INSERT INTO productos (nombre_producto, precio, stock, categoria) VALUES
('Laptop', 1500, 10, 'Electrónica'),
('Mouse', 25, 50, 'Accesorios'),
('Teclado', 45, 30, 'Accesorios'),
('Smartphone', 800, 20, 'Electrónica'),
('Cámara', 1200, 5, 'Fotografía');

INSERT INTO categorias (nombre_categoria) VALUES
('Electrónica'), ('Accesorios'), ('Fotografía');

INSERT INTO ventas (id_producto, cantidad, fecha_venta, total_venta) VALUES
(1, 2, '2024-10-10', 3000),
(2, 5, '2024-10-11', 125),
(4, 1, '2024-10-12', 800);

-- Consultas a realizar:

-- Muestra el nombre de cada producto, su precio con un 15% de descuento y el stock disponible.
    SELECT nombre_producto, precio, precio * 0.85 AS precio_descuento, stock
    FROM productos;
-- Calcula la cantidad total de productos vendidos por categoría, y muestra solo aquellas con más de 3 productos vendidos.
    SELECT categoria, SUM(cantidad) AS total_vendidos
    FROM ventas
    INNER JOIN productos ON ventas.id_producto = productos.id_producto
    GROUP BY categoria
    HAVING SUM(cantidad) > 3;
-- Muestra el total de ventas por día, ordenando de mayor a menor.
    SELECT fecha_venta, SUM(total_venta) AS total_por_dia
    FROM ventas
    GROUP BY fecha_venta
    ORDER BY total_por_dia DESC;


-- Encuentra productos con un nombre que contenga la palabra "Smart" o que pertenezcan a la categoría "Accesorios".

    SELECT nombre_producto, categoria
    FROM productos
    WHERE nombre_producto LIKE '%Smart%' OR categoria = 'Accesorios';


-- Muestra aquellos productos cuyo stock sea inferior a 10, o que no tengan categoría asignada.

SELECT nombre_producto, stock, categoria
FROM productos
WHERE stock < 10 OR categoria IS NULL;


