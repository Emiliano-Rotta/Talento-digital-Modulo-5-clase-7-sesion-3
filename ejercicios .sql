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




-- Ejercicio 2: Sistema de Gestión de Alumnos
-- Consigna
-- Una universidad necesita gestionar los registros de sus alumnos y las notas obtenidas en diferentes materias. Crea una base de datos que permita consultar información sobre los alumnos y sus resultados académicos.

-- Crear la base de datos:

CREATE DATABASE gestion_universidad;

-- Crear las tablas:

-- Tabla alumnos con los campos: id_alumno (serial, PK), nombre (varchar(50), NOT NULL), apellido (varchar(50), NOT NULL), fecha_nacimiento (date), ciudad (varchar(50)).
-- Tabla materias con los campos: id_materia (serial, PK), nombre_materia (varchar(50), NOT NULL).
-- Tabla notas con los campos: id_nota (serial, PK), id_alumno (int, NOT NULL), id_materia (int, NOT NULL), nota (numeric, NOT NULL), fecha (date, NOT NULL).

CREATE TABLE alumnos (
    id_alumno SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    ciudad VARCHAR(50)
);

CREATE TABLE materias (
    id_materia SERIAL PRIMARY KEY,
    nombre_materia VARCHAR(50) NOT NULL
);

CREATE TABLE notas (
    id_nota SERIAL PRIMARY KEY,
    id_alumno INT NOT NULL,
    id_materia INT NOT NULL,
    nota NUMERIC NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY (id_materia) REFERENCES materias(id_materia)
);

-- Insertar datos de prueba:

-- Inserta al menos 5 alumnos, 3 materias y 6 notas.
-- Incluye al menos una nota con un valor nulo para practicar el uso de IS NULL.

INSERT INTO alumnos (nombre, apellido, fecha_nacimiento, ciudad) VALUES
('Juan', 'Pérez', '1998-04-23', 'Buenos Aires'),
('María', 'González', '1997-11-15', 'Córdoba'),
('Lucas', 'Rodríguez', '1999-07-30', 'Rosario'),
('Ana', 'Fernández', '2000-01-05', 'Mendoza'),
('Sofía', 'López', '1998-12-19', 'La Plata');

INSERT INTO materias (nombre_materia) VALUES
('Matemática'), ('Historia'), ('Programación');

INSERT INTO notas (id_alumno, id_materia, nota, fecha) VALUES
(1, 1, 8.5, '2024-08-10'),
(2, 3, NULL, '2024-08-11'),
(3, 2, 7.0, '2024-08-12'),
(4, 3, 9.0, '2024-08-13'),
(5, 1, 5.5, '2024-08-14'),
(1, 2, 6.0, '2024-08-15');

-- Consultas a realizar:

-- Encuentra el promedio de notas por alumno, y muestra solo aquellos con un promedio superior a 7.
-- Muestra las materias en las que al menos un alumno tiene una nota nula.
-- Lista los alumnos con sus edades, calculadas a partir de la fecha de nacimiento.
-- Muestra el total de notas registradas por ciudad, ordenando de mayor a menor.
-- Filtra los alumnos cuyo nombre empiece con 'A' o que no tengan asignada ninguna ciudad.
-- Estos ejercicios permiten que los estudiantes practiquen de manera más extensa y completa con los operadores básicos, la sentencia SELECT y las funciones de agregación en PostgreSQL.


------------------------------------------------------------------------------------------

-- Ejercicio 3: Gestión de Biblioteca
-- Consigna
-- Se necesita gestionar una base de datos para una biblioteca pública. El sistema debe permitir llevar el registro de libros, autores y préstamos realizados. El objetivo es crear una base de datos que permita realizar consultas relacionadas con los libros disponibles, sus autores y el historial de préstamos.

-- Crear la base de datos:

-- CREATE DATABASE gestion_biblioteca;

-- Crear las tablas:

-- Tabla libros con los campos: id_libro (serial, PK), titulo (varchar(100), NOT NULL), año_publicacion (int), genero (varchar(50)), disponible (boolean, NOT NULL).
-- Tabla autores con los campos: id_autor (serial, PK), nombre_autor (varchar(50), NOT NULL), nacionalidad (varchar(50)).
-- Tabla prestamos con los campos: id_prestamo (serial, PK), id_libro (int, NOT NULL), fecha_prestamo (date, NOT NULL), fecha_devolucion (date), id_autor (int, NOT NULL).

CREATE TABLE libros (
    id_libro SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    año_publicacion INT,
    genero VARCHAR(50),
    disponible BOOLEAN NOT NULL
);

CREATE TABLE autores (
    id_autor SERIAL PRIMARY KEY,
    nombre_autor VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(50)
);

CREATE TABLE prestamos (
    id_prestamo SERIAL PRIMARY KEY,
    id_libro INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE,
    id_autor INT NOT NULL,
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

-- Insertar datos de prueba:

-- Inserta al menos 5 libros, 3 autores y 4 préstamos en la base de datos.
-- Asegúrate de que algunos libros no estén disponibles.


INSERT INTO libros (titulo, año_publicacion, genero, disponible) VALUES
('Cien Años de Soledad', 1967, 'Realismo Mágico', FALSE),
('El Principito', 1943, 'Ficción', TRUE),
('1984', 1949, 'Distopía', FALSE),
('Rayuela', 1963, 'Ficción', TRUE),
('Don Quijote de la Mancha', 1605, 'Clásico', TRUE);

INSERT INTO autores (nombre_autor, nacionalidad) VALUES
('Gabriel García Márquez', 'Colombiano'),
('Antoine de Saint-Exupéry', 'Francés'),
('George Orwell', 'Inglés');

INSERT INTO prestamos (id_libro, fecha_prestamo, fecha_devolucion, id_autor) VALUES
(1, '2024-09-01', '2024-09-15', 1),
(2, '2024-09-03', NULL, 2),
(3, '2024-09-05', '2024-09-20', 3),
(4, '2024-09-07', NULL, 1);

-- Consultas a realizar:

-- Muestra los libros disponibles junto con el nombre del autor, ordenados por el año de publicación.
-- Encuentra los libros que no han sido devueltos (donde fecha_devolucion es nula).
-- Calcula el número total de préstamos por género literario, y muestra solo aquellos géneros con más de un préstamo.
-- Filtra los autores cuya nacionalidad sea "Colombiano" o "Inglés", o que hayan escrito un libro publicado antes de 1950.
-- Muestra el título del libro y el tiempo (en días) que ha estado prestado si no se ha devuelto.
