/* 1.- Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las
claves primarias, foráneas y tipos de datos.*/

CREATE DATABASE prueba_sql_leonardo_villagran;

CREATE TABLE peliculas (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(255),
  anno INTEGER);

CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  tag VARCHAR(32));

CREATE TABLE peliculas_tags (
  id SERIAL PRIMARY KEY,
  id_pelicula INTEGER REFERENCES peliculas(id),
  id_tag INTEGER REFERENCES tags(id));


/* 2.- Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
segunda película debe tener dos tags asociados. 
*/

INSERT INTO peliculas (nombre, anno) VALUES
  ('Spider-Man', 2002),
  ('Batman Begins', 2005),
  ('Iron Man', 2008),
  ('The Avengers', 2012),
  ('Black Panther', 2018);

-- Insertar 5 tags
INSERT INTO tags (tag) VALUES
  ('Acción'),
  ('Aventura'),
  ('Ciencia ficción'),
  ('Fantasía'),
  ('Superhéroes');

-- Asociar tags a las películas
-- Película 1
INSERT INTO peliculas_tags (id_pelicula, id_tag) VALUES
  (1, 1),
  (1, 2),
  (1, 4);

-- Película 2
INSERT INTO peliculas_tags (id_pelicula, id_tag) VALUES
  (2, 1),
  (2, 2);
  
/* 3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
mostrar 0.
*/

SELECT p.id, p.nombre, COUNT(t.id_tag) as cantidad_tags
FROM peliculas as p
LEFT JOIN peliculas_tags as t ON p.id = t.id_pelicula
GROUP BY p.id, p.nombre
ORDER BY cantidad_tags desc;

/*----------------------------------------------------*/


/* 4.- Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
datos. (1 punto)
*/

-- Crear la tabla preguntas
CREATE TABLE preguntas (
  id SERIAL PRIMARY KEY,
  pregunta VARCHAR(255),
  respuesta_correcta VARCHAR
);

-- Crear la tabla usuarios
CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(255),
  edad INTEGER
);

-- Crear la tabla respuestas
CREATE TABLE respuestas (
  id SERIAL PRIMARY KEY,
  respuesta VARCHAR(255),
  usuario_id INTEGER REFERENCES usuarios(id) ,
  pregunta_id INTEGER REFERENCES preguntas(id));

/*5.- Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas*/

-- Insertar las preguntas
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES
  ('¿Cuál es la identidad secreta de Batman?', 'Bruce Wayne'),
  ('¿Quién es el villano principal en la película "The Avengers"?', 'Loki'),
  ('¿Cuál es el verdadero nombre de Spider-Man?', 'Peter Parker'),
  ('¿En qué película de Superman aparece el personaje de Lex Luthor por primera vez?', 'Superman: The Movie'),
  ('¿Cuál es el nombre real de Iron Man?', 'Tony Stark');

-- Insertar los usuarios
INSERT INTO usuarios (nombre, edad) VALUES
  ('Juan Pérez.', 57),
  ('Roberto Días', 40),
  ('Sergio Parra', 37),
  ('Tomás Silva', 25),
  ('Pedro Cerda', 54);

-- la primera pregunta debe estar contestada dos veces correctamente por distintos usuarios

INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES
  ('Bruce Wayne', 1, 1), -- Usuario 1 responde correctamente la pregunta 1
  ('Bruce Wayne', 3, 1); -- Usuario 3 responde correctamente la pregunta 1
  
-- la pregunta 2 debe estar contestada correctamente sólo por un usuario

INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES
  ('Loki', 1, 2); -- Usuario 1 responde correctamente la pregunta 2

-- y las otras 2 respuestas deben estar incorrectas.

INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES
  ('Peter Parker', 2, 2), -- Usuario 2 responde incorrectamente la pregunta 2
  ('Bruce Banner', 3, 2); -- Usuario 3 responde incorrectamente la pregunta 2
  
  
  /*6.- Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
pregunta). (1 punto)*/ 

SELECT u.nombre, COUNT(r.respuesta) as respuestas_correctas
FROM usuarios as u
inner JOIN respuestas as r ON u.id = r.usuario_id
inner JOIN preguntas as p ON r.pregunta_id = p.id 
WHERE r.respuesta=p.respuesta_correcta
GROUP BY u.nombre
ORDER BY respuestas_correctas DESC , u.nombre DESC;

/*7.- Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
respuesta correcta. (1 punto)*/

SELECT p.id AS pregunta_id, p.pregunta, p.respuesta_correcta, COUNT(r.usuario_id) as usuarios_correctos
FROM preguntas AS p
LEFT JOIN respuestas AS r  ON p.id = r.pregunta_id
WHERE r.respuesta = p.respuesta_correcta
GROUP BY p.id, p.pregunta, p.respuesta_correcta;


/*8-. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
primer usuario para probar la implementación.*/

ALTER TABLE respuestas 
DROP CONSTRAINT IF EXISTS respuestas_usuario_id_fkey, 
ADD CONSTRAINT respuestas_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;


DELETE FROM usuarios WHERE id = 1;

SELECT * FROM usuarios; /* no hay usuarios con id 1 */
SELECT * FROM respuestas; /* no hay usuarios con id 1 */


/*9.- Crea una restricción que impida insertar usuarios menores de 18 años en la base de
datos. */

ALTER TABLE usuarios 
DROP CONSTRAINT IF EXISTS ck_edad_minima, 
ADD CONSTRAINT ck_edad_minima CHECK (edad >= 18);

INSERT INTO usuarios (nombre, edad) VALUES
  ('Ignacio Chico', 13); /*error de ingreso por edad */

/*10.- Altera la tabla existente de usuarios agregando el campo email con la restricción de
único. */

ALTER TABLE usuarios ADD COLUMN email VARCHAR(255);

ALTER TABLE  usuarios 
DROP CONSTRAINT IF EXISTS unique_email, 
ADD CONSTRAINT unique_email UNIQUE (email);

INSERT INTO usuarios (nombre, edad, email) VALUES
  ('Román Aldo', 23, 'aldo@gmail.com'),
  ('María Aldo', 26, 'aldo@gmail.com'); /* Error de ingreso por e-mail duplicado */