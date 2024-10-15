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