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
--Ejercicios

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
