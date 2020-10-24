crontol + k y u pasar a mayusculas una seleccion

The difference is whether you want to change the column name, column definition or both.

CHANGE
Can rename a column or change its definition, or both.

ALTER TABLE t1 CHANGE a b BIGINT NOT NULL

MODIFY
Can change a column definition but not its name

ALTER TABLE t1 MODIFY b INT NOT NULL

RENAME COLUMN
Can change a column name but not its definition.

ALTER TABLE t1 RENAME COLUMN b TO a


mysql -u root -p


CREATE TABLE people(person_id INT NOT NULL AUTO_INCREMENT, last_name VARCHAR(255) NOT NULL, first_name VARCHAR(255) NOT NULL, address VARCHAR(255) NOT NULL, city VARCHAR(255) NOT NULL, PRIMARY KEY(person_id));

SELECT * FROM people;
SHOW CREATE TABLE people; muestra la estructura de una tabla, como esta hecha

INSERT INTO people VALUES(NULL, 'nieto', 'johan', 'venezuela', 'san antonio');
INSERT INTO people VALUES(NULL, 'perez', 'alexis', 'colombia', 'cucuta');

INSERT INTO people VALUES(NULL, 'hernandez', 'laura', 'mexico', 'monterrey');

CREATE VIEW platzipeole AS SELECT * FROM people;

ALTER TABLE people ADD COLUMN date_of_birth DATETIME NULL AFTER city;

ALTER TABLE people MODIFY date_of_birth VARCHAR(30) NULL DEFAULT NULL; modifique el tipo de date_of_birth

ALTER TABLE people DROP COLUMN date_of_birth;

DROP TABLE people;

DROP DATABASE platziblog;

UPDATE people SET last_name='rodrigez', city= 'culiacan' WHERE person_id= 3;

UPDATE people SET city= 'cali' WHERE first_name= 'alexis';

UPDATE people SET first_name= 'juan'; esto es peligroso, sin una condicion de busqueda, cambiara todos los nombres de los registros a juan

DELETE FROM people; tambien peligrosa, borrara todos los registros

DELETE FROM people WHERE person_id= 5;

SELECT first_name, last_name FROM people;

CREATE TABLE categorias (id INT NOT NULL AUTO_INCREMENT, nombre_categoria VARCHAR (30) NOT NULL, PRIMARY KEY (id));

CREATE TABLE etiquetas (id INT NOT NULL AUTO_INCREMENT, nombre_etiqueta VARCHAR (30) NOT NULL, PRIMARY KEY (id));

CREATE TABLE usuarios (id INT NOT NULL AUTO_INCREMENT, login VARCHAR(30) NOT NULL, password VARCHAR(32) NOT NULL, nickname VARCHAR(40) NOT NULL, email VARCHAR(40) NOT NULL, PRIMARY KEY (id), UNIQUE INDEX email_unique (email));

CREATE TABLE post (id INT NOT NULL AUTO_INCREMENT, titulo VARCHAR(130) NOT NULL, fecha_publicacion TIMESTAMP NULL, contenido TEXT NOT NULL, estatus CHAR (8) NULL DEFAULT 'activo', usuario_id INT NOT NULL, categoria_id INT NOT NULL, PRIMARY KEY (id));

ALTER TABLE post ADD INDEX post_usuarios_idx (usuario_id);//añadimos un indice a la columna usuario_id, sirve para busquedas

ALTER TABLE post ADD CONSTRAINT post_usuarios FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE NO ACTION ON UPDATE CASCADE;// agregamos la clave foranea con un constraint que nombramos post_usuarios

ALTER TABLE post ADD INDEX post_categorias_idx (categoria_id);

ALTER TABLE post ADD CONSTRAINT post_categorias FOREIGN KEY (categoria_id) REFERENCES categorias (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE comentarios (id INT NOT NULL AUTO_INCREMENT, cuerpo_comentario TEXT NOT NULL, usuario_id INT NOT NULL, post_id INT NOT NULL, CONSTRAINT comentarios_usuarios FOREIGN KEY (usuario_id) REFERENCES usuarios(id) , CONSTRAINT comentarios_post FOREIGN KEY (post_id) REFERENCES post(id), PRIMARY KEY (id));

CREATE TABLE post_etiquetas (id INT NOT NULL AUTO_INCREMENT, post_id INT NOT NULL, etiqueta_id INT NOT NULL, CONSTRAINT postEtiquetas_post FOREIGN KEY (post_id) REFERENCES post(id) , CONSTRAINT postEtiquetas_etiquetas FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id), PRIMARY KEY (id));

SELECT titulo AS encabezado, fecha_publicacion AS publicado_en, estatus FROM post;

SELECT COUNT(*) FROM post;

SELECT COUNT(*) AS numero_posts FROM post;

SELECT * FROM usuarios LEFT JOIN post ON usuarios.id = post.usuario_id;//traera todos los usuarios de la tabla izquierda es decir usuarios, y de la post los que coincidan con usuarios, todos eso usando de condicion "usuarios.id = post.usuario_id", traera a todos los usarios asi no tengan post, en el lado del post, si el usuario no tiene uno mandara null en sus datos

SELECT * FROM usuarios LEFT JOIN post ON usuarios.id = post.usuario_id WHERE post.usuario_id IS NULL; //con esta condicion solo traera los usarios que no tengan posts

SELECT * FROM usuarios RIGHT JOIN post ON usuarios.id = post.usuario_id;//aqui traera todos los post y usuarios que tengan post, pero si un post no tiene asocidado un usuario, vendra el post pero en su correspondiente usuario llegaran null, es decir estos joins traen todos los datos, deacuerdo al lado que indiquemos, y donde falten datos pondra null

SELECT * FROM usuarios INNER JOIN post ON usuarios.id = post.usuario_id;//trae todos los datos que esten relacionados, si no no los trae, es decir, los usuarios que tienen post, los post que son de un usuario al menos

SELECT * FROM usuarios LEFT JOIN post ON usuarios.id = post.usuario_id UNION SELECT * FROM usuarios RIGHT JOIN post ON usuarios.id = post.usuario_id; // con este traemos todo, con el LEFT todos los datos de los usuarios y con el RIGHT todos los datos de los post, absolutamente todos, usando el UNION que nos permite unir varias consultas SELECT 


SELECT * FROM usuarios LEFT JOIN post ON usuarios.id = post.usuario_id WHERE post.usuario_id IS NULL UNION SELECT * FROM usuarios RIGHT JOIN post ON usuarios.id = post.usuario_id WHERE post.usuario_id IS NULL; //Y aqui los usuarios que no tengan post, y los post sin usuario usando la condicion WHERE post.usuario_id IS NULL

SELECT * FROM post WHERE titulo LIKE "%evento%";
SELECT * FROM post WHERE titulo LIKE "evento%";//comienze con la palabra evento
SELECT * FROM post WHERE titulo LIKE "%evento";//termine con la palabra evento

SELECT * from post WHERE fecha_publicacion > '2025-01-01';

SELECT * from post WHERE fecha_publicacion BETWEEN '2023-01-01' AND '2025-12-31';

SELECT * from post WHERE id BETWEEN 50 AND 60;

SELECT * from post WHERE YEAR(fecha_publicacion) BETWEEN '2023' AND '2025';//con YEAR solo tomara el año como parametro

SELECT * from post WHERE YEAR(fecha_publicacion) = '2023';

SELECT * from post WHERE MONTH(fecha_publicacion) = '04';// como el YEAR pero con meses

SELECT * FROM post WHERE usuario_id IS NULL;

SELECT * FROM post WHERE usuario_id IS NOT NULL;

SELECT * FROM post WHERE usuario_id IS NOT NULL AND estatus= 'activo';//uso del AND para filtrar con mas condiciones, aqui que traiga los que no tienen valor NULL en el usuario_id y que tambien tengan en su estatus el valor activo

SELECT * FROM post WHERE usuario_id IS NOT NULL AND estatus= 'activo' AND id<50 AND categoria_id= 2;// que el usuario_id no sea null, que sus estatus sean activos, que sus ids sean menores a 50 y que solo traiga a los que tengan 2 en la categoria_id

puedes usar el AND para encadenar filtraciones, todas las que necesites


SELECT estatus, COUNT(*) AS post_cantidad FROM post GROUP BY estatus;//deacuerdo a que valores posea la columna a indicar, GROUP BY los ordena automaticamente

SELECT YEAR(fecha_publicacion) AS post_year, COUNT(*) AS post_cantidad FROM post GROUP BY post_year;// trae todos los años y los agrupa por la fecha es decir, si trae 2021 y hay 2 post con ese año pondra "2025,2"


SELECT MONTHNAME(fecha_publicacion) AS post_month, COUNT(*) AS post_cantidad FROM post GROUP BY post_month;

SELECT estatus, MONTHNAME(fecha_publicacion) AS post_month, COUNT(*) AS post_cantidad FROM post GROUP BY estatus, post_month; //selecciona los estatus y meses, los agrupa por activo o inactivo y por mes

SELECT * FROM post ORDER BY fecha_publicacion;// por defecto los ordena de forma ascendente, si quieres de otra forma puedes usar ASC O DESC

SELECT * FROM post ORDER BY fecha_publicacion DESC;

SELECT * FROM post ORDER BY titulo ASC LIMIT 5;//los trae ordenados deacuero al titulo, es decir en orden alfabetico de forma ascendente de la comenzando por A, y solo traera 5 resultados

SELECT estatus, MONTHNAME(fecha_publicacion) AS post_month, COUNT(*) AS post_cantidad FROM post  GROUP BY estatus, post_month HAVING post_cantidad > 1 ORDER BY post_month;

//el HAVING es como un WHERE que usa valores dinamicos/creados en la misma query, y debe ir despues del GROUP BY y antes del ORDER BY, esta busqueda se traduce a: traeme todos los estatus, fecha y conteo agrupandolos por estatus y mes, que tengan una cantidad de post mayor a 1 y ordenamelos por el mes

SELECT nueva_tabla.date, COUNT(*) AS post_count FROM
(SELECT DATE(MIN(fecha_publicacion)) AS date, YEAR(fecha_publicacion) post_year from post GROUP BY post_year) AS nueva_tabla GROUP BY nueva_tabla.date ORDER BY nueva_tabla.date;// a esto se le llama querys anidados o nested, consiste en hacer una consulta, con una tabla temporal creada por otra consulta, aqui estamos seleccionando la fecha minima de un año, y cuantos hay por mes

SELECT * FROM post WHERE fecha_publicacion= (SELECT MAX(fecha_publicacion) FROM post);//buscamos primero cual es el maximo valo de fecha en algun registro de post y luego lo comparamos con la fecha del algun post que posea ese valor


SELECT: lo que quiero mostrar

FROM: de donde voy a sacar los datos

WHERE: los filtros de datos que quieres mostrar

GROUP BY: los rubros por los que me interesa agrupar la informacion

ORDER BY: el orden en el que quiero presentar mi informacion

HAVING: los filtros que quiero que mis datos agrupados tengan



									PREGUNTAS

1.Trame cuantas etiquetas hay por posts.

SELECT titulo, COUNT(*) AS num_etiquetas FROM post INNER JOIN post_etiquetas ON post.id = post_etiquetas.post_id INNER JOIN etiquetas ON etiquetas.id= post_etiquetas.etiqueta_id GROUP BY post.id ORDER BY num_etiquetas DESC;

// la cosa es traemos el titulo para de alguna manera identificar cada post, hacemos un inner join primero con la tabla union de post y etiquetas llamada post_etiquetas, y asi llegar a etiquetas, el solo hecho de que esten relacionadas, nos dara cuantas coincidencias hay entre ambas.El GROUP BY lo entiendo como la forma de traer varias filas, de otra manera solo nos trae una fila en la consulta.

2.Traeme los post y cuales etiquetas tiene asociadas.

SELECT titulo, GROUP_CONCAT(nombre_etiqueta) AS etiquetas_asociadas FROM post INNER JOIN post_etiquetas ON post.id = post_etiquetas.post_id INNER JOIN etiquetas ON etiquetas.id= post_etiquetas.etiqueta_id GROUP BY post.id;

//el GROUP_CONCAT nos agrupa en una mismo campo, y separado por "," los valores que el query consigue, es decir, las etiquetas asociadas a cada post, de otra manera, solo nos trae una sola etiqueta en el campo por cada post.

3. Trae todas las etiquetas que no han sido usadas en algun post

SELECT * FROM etiquetas LEFT JOIN post_etiquetas ON etiquetas.id = post_etiquetas.etiqueta_id WHERE post_etiquetas.post_id IS NULL; 

//aqui unimos las tablas etiquetas con post_etiquetas, trayendo todo de la primera, sin importar que en la segunda no hayan datos relacionados, y comparamos si algun campo es NULL en algun registro de post_etiquetas, si es asi, quiere decir que es una etiqueta que ningun post ha usado.


4. cuantos posts tiene cada categoria y ordenarlos deacuerdo a cuantos tiene y de mayor a menor.

SELECT c.nombre_categoria, COUNT(*) AS num_post FROM categorias AS c INNER JOIN post AS p ON c.id = p.categoria_id GROUP BY c.id ORDER BY num_post DESC;

5. que usuarios tienen mas post;

SELECT u.nickname, COUNT(*) AS cant_post FROM usuarios AS u INNER JOIN post ON u.id = post.usuario_id GROUP BY u.id ORDER BY cant_post DESC;

6. los usuarios con mas post, y la categoria de cada uno de sus post.

SELECT u.nickname, COUNT(*) AS cant_post, GROUP_CONCAT(c.nombre_categoria) FROM usuarios AS u INNER JOIN post ON u.id = post.usuario_id INNER JOIN categorias AS c ON c.id = post.categoria_id GROUP BY u.id ORDER BY cant_post DESC;




-----------------------------------------------------------------------------------------------------------------

-- Estructura basica de un query
SELECT	*
FROM		posts;

-- Estructura extendida de un query
SELECT	*
FROM		posts
WHERE	fecha_publicacion > '2024';



-- Datos de prueba

-- Usuarios
INSERT INTO usuarios VALUES (NULL,'israel','jc8209*(^GCHN_(hcLA','Israel','israel@platziblog.com');
INSERT INTO usuarios VALUES (NULL,'monica','(*&^LKJDHC_(*#YDLKJHODG','Moni','monica@platziblog.com');
INSERT INTO usuarios VALUES (NULL,'laura','LKDJ)_*(-c.M:\"[pOwHDˆåßƒ∂','Lau','laura@platziblog.com');
INSERT INTO usuarios VALUES (NULL,'edgar','LLiy)CX*Y:M<A<SC_(*N>O','Ed','edgar@platziblog.com');
INSERT INTO usuarios VALUES (NULL,'perezoso','&N_*JS)_Y)*(&TGOKS','Oso Pérez','perezoso@platziblog.com');

-- Categorías
INSERT INTO categorias VALUES (NULL,'Ciencia');
INSERT INTO categorias VALUES (NULL,'Tecnología');
INSERT INTO categorias VALUES (NULL,'Deportes');
INSERT INTO categorias VALUES (NULL,'Espectáculos');
INSERT INTO categorias VALUES (NULL,'Economía');

-- Etiquetas
INSERT INTO etiquetas VALUES (1,'Robótica');
INSERT INTO etiquetas VALUES (2,'Computación');
INSERT INTO etiquetas VALUES (3,'Teléfonos Móviles');
INSERT INTO etiquetas VALUES (4,'Automovilismo');
INSERT INTO etiquetas VALUES (5,'Campeonatos');
INSERT INTO etiquetas VALUES (6,'Equipos');
INSERT INTO etiquetas VALUES (7,'Bolsa de valores');
INSERT INTO etiquetas VALUES (8,'Inversiones');
INSERT INTO etiquetas VALUES (9,'Brokers');
INSERT INTO etiquetas VALUES (10,'Celebridades');
INSERT INTO etiquetas VALUES (11,'Eventos');
INSERT INTO etiquetas VALUES (12,'Moda');
INSERT INTO etiquetas VALUES (13,'Avances');
INSERT INTO etiquetas VALUES (14,'Nobel');
INSERT INTO etiquetas VALUES (15,'Matemáticas');
INSERT INTO etiquetas VALUES (16,'Química');
INSERT INTO etiquetas VALUES (17,'Física');
INSERT INTO etiquetas VALUES (18,'Largo plazo');
INSERT INTO etiquetas VALUES (19,'Bienes Raíces');
INSERT INTO etiquetas VALUES (20,'Estilo');

-- Posts
INSERT INTO post VALUES (43,'Se presenta el nuevo teléfono móvil en evento','2030-04-05 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',1,2);
INSERT INTO post VALUES (44,'Tenemos un nuevo auto inteligente','2025-05-04 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',2,2);
INSERT INTO post VALUES (45,'Ganador del premio Nobel por trabajo en genética','2023-12-22 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',3,1);
INSERT INTO post VALUES (46,'Los mejores vestidos en la alfombra roja','2021-12-22 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',4,4);
INSERT INTO post VALUES (47,'Los paparatzi captan escándalo en cámara','2025-01-09 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','inactivo',4,4);
INSERT INTO post VALUES (48,'Se mejora la conducción autónoma de vehículos','2022-05-23 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',1,2);
INSERT INTO post VALUES (49,'Se descubre nueva partícula del modelo estandar','2023-01-10 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',2,1);
INSERT INTO post VALUES (50,'Químicos descubren nanomaterial','2026-06-04 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',2,1);
INSERT INTO post VALUES (51,'La bolsa cae estrepitosamente','2024-04-03 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',2,5);
INSERT INTO post VALUES (52,'Bienes raices más baratos que nunca','2025-04-11 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','inactivo',2,5);
INSERT INTO post VALUES (53,'Se fortalece el peso frente al dolar','2021-10-09 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',1,5);
INSERT INTO post VALUES (54,'Tenemos ganador de la formula e','2022-11-11 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',1,3);
INSERT INTO post VALUES (55,'Ganan partido frente a visitantes','2023-12-10 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',2,3);
INSERT INTO post VALUES (56,'Equipo veterano da un gran espectaculo','2023-12-01 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','inactivo',2,3);
INSERT INTO post VALUES (57,'Escándalo con el boxeador del momento','2025-03-05 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',4,4);
INSERT INTO post VALUES (58,'Fuccia OS sacude al mundo','2028-10-10 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',1,2);
INSERT INTO post VALUES (59,'U.S. Robotics presenta hallazgo','2029-01-10 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n','activo',1,2);
INSERT INTO post VALUES (60,'Cierra campeonato mundial de football de manera impresionante','2023-04-10 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n','activo',2,3);
INSERT INTO post VALUES (61,'Escándalo en el mundo de la moda','2022-04-11 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n','activo',4,4);
INSERT INTO post VALUES (62,'Tenemos campeona del mundial de volleiball','2024-09-09 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n','inactivo',2,3);
INSERT INTO post VALUES (63,'Se descubre la unión entre astrofísica y fisica cuántica','2022-05-03 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n','inactivo',3,1);
INSERT INTO post VALUES (64,'El post que se quedó huérfano','2029-08-08 00:00:00','\'Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n\'','activo',2,2);

-- Posts-etiquetas
INSERT INTO post_etiquetas VALUES (1,43,3);
INSERT INTO post_etiquetas VALUES (2,43,11);
INSERT INTO post_etiquetas VALUES (3,44,2);
INSERT INTO post_etiquetas VALUES (4,44,4);
INSERT INTO post_etiquetas VALUES (5,45,14);
INSERT INTO post_etiquetas VALUES (6,45,13);
INSERT INTO post_etiquetas VALUES (7,46,10);
INSERT INTO post_etiquetas VALUES (8,46,11);
INSERT INTO post_etiquetas VALUES (9,46,12);
INSERT INTO post_etiquetas VALUES (10,46,20);
INSERT INTO post_etiquetas VALUES (11,47,10);
INSERT INTO post_etiquetas VALUES (12,48,1);
INSERT INTO post_etiquetas VALUES (13,48,2);
INSERT INTO post_etiquetas VALUES (14,48,4);
INSERT INTO post_etiquetas VALUES (15,48,13);
INSERT INTO post_etiquetas VALUES (16,49,13);
INSERT INTO post_etiquetas VALUES (17,49,14);
INSERT INTO post_etiquetas VALUES (18,49,17);
INSERT INTO post_etiquetas VALUES (19,50,13);
INSERT INTO post_etiquetas VALUES (20,50,14);
INSERT INTO post_etiquetas VALUES (21,50,16);
INSERT INTO post_etiquetas VALUES (22,51,7);
INSERT INTO post_etiquetas VALUES (23,51,8);
INSERT INTO post_etiquetas VALUES (24,51,9);
INSERT INTO post_etiquetas VALUES (25,51,18);
INSERT INTO post_etiquetas VALUES (26,52,8);
INSERT INTO post_etiquetas VALUES (27,52,18);
INSERT INTO post_etiquetas VALUES (28,53,7);
INSERT INTO post_etiquetas VALUES (29,53,8);
INSERT INTO post_etiquetas VALUES (30,54,4);
INSERT INTO post_etiquetas VALUES (31,54,5);
INSERT INTO post_etiquetas VALUES (32,55,5);
INSERT INTO post_etiquetas VALUES (33,55,6);
INSERT INTO post_etiquetas VALUES (34,56,5);
INSERT INTO post_etiquetas VALUES (35,56,6);
INSERT INTO post_etiquetas VALUES (36,56,10);
INSERT INTO post_etiquetas VALUES (37,58,2);
INSERT INTO post_etiquetas VALUES (38,58,3);
INSERT INTO post_etiquetas VALUES (39,58,13);
INSERT INTO post_etiquetas VALUES (40,59,1);
INSERT INTO post_etiquetas VALUES (41,59,13);
INSERT INTO post_etiquetas VALUES (42,57,10);
INSERT INTO post_etiquetas VALUES (43,60,5);
INSERT INTO post_etiquetas VALUES (44,60,6);
INSERT INTO post_etiquetas VALUES (45,61,10);
INSERT INTO post_etiquetas VALUES (46,61,12);
INSERT INTO post_etiquetas VALUES (47,61,20);
INSERT INTO post_etiquetas VALUES (48,62,5);
INSERT INTO post_etiquetas VALUES (49,62,10);
INSERT INTO post_etiquetas VALUES (50,63,13);
INSERT INTO post_etiquetas VALUES (51,63,14);
INSERT INTO post_etiquetas VALUES (52,63,17);
INSERT INTO post_etiquetas VALUES (53,52,19);




------------------------------------------------------------------
curso sql/mysql
------------------------------------------------------------------


CREATE DATABASE platzi_operation;

CREATE DATABASE IF NOT EXITS platzi_operation;//si existe la BD, entonces no la crea.

SHOW warnings;//el show tambien sirve para mostrar los warnings.

Buena practica es, usar sustantivos en plural para las tablas y a poder ser en ingles.
books, users, etc.

Toda tabla necesita su id, y asi identificar rapidamente una tupla/row/fila.

DESC describe la estructuta de una tabla, a diferencia del SHOW CREATE TABLE "NOMBRE DE LA TABLA",
este no muestra la consulta con la que se creo, muestra una tabla con la estructura.

 `language` varchar(2) NOT NULL COMMENT 'ISO 639-1 Language code (2 chars)',// em la definicion
 de una tabla puedes asociar un comentario a una de sus columnas.

 SHOW FULL COLUMNS FROM books; //con este puedes ver mas metadatos de las columnas de una tabla
 y asi poder ver el comentario del campo language.

 `year` int(11) NOT NULL DEFAULT '1900',//year es una palabra reservada de sql, para evitar
 conflictos, se recomienda encerrar los nombres de columna en ``(comillas de identificacion), 
 no confundir con las '', estas son para cadenas, es decir, 'año' cadena, `year`nombre de una
 columna que usa una palabra reservada, asi sql no la confundira.

 SELECT * FROM usuarios WHERE id=4 \G \\con este "\G" No nos mostrara los datos en una tabla
 si no uno justo debajo del otro como si fuera un objeto

 INSERT INTO nombre_tabla VALUES(2, "nombre", "lugar") ON DUPLICATE KEY UPDATE active = "activo";
//lo del ON DUPLICATE KEY UPDATE nos permite actualiar un registro ya hecho usando inserts
reescribira lo demas y hasta cambiara las UNIQUE, btw nunca usar el ON DUPLICATE KEY IGNORE ALL
ya que ignoras los errores y warnings, por ejemplo.

INSERT INTO books (title, autor_id, year)
VALUES (“Vuelta al Laberinto de la Soledad”,
(SELECT autor_id FROM authors
WHERE name = “Octavio Paz”
LIMIT 1
), 1960
)//se pueden insertar datos traidos de otros query SELECT

SELECT NOW();//Trae la fecha y hora del dia.
SELECT YEAR(NOW()); //trae el año del dia de hoy;

SELECT name, YEAR(NOW()) - YEAR(cumpleaños) FROM clients LIMIT 10;//Traera el nombre y la 
edad,la primera funcion YEAR con la NOW traen el año del presente menos el año 
 del cumpleaños de un cliente igual a su edad.

 SELECT c.name, b.title, a.name, t.type
FROM transactions AS t
JOIN books AS b
On t.book_id = b.book_id
JOIN clients AS c
On t.client_id = c.client_id
JOIN authors AS a
ON b.author_id = a.author_id
WHERE c.gender = “M”
AND t.type IN (“sell”, “lend”);//el IN es para decir que posibles valores puede tener el type
que tu quieras


SELECT a.author_id, a.name, a.nationality, COUNT (b.book_id) FROM authors AS a
LEFT JOIN books AS b ON a.author_id = b.author_id WHERE a.author_id BETWEEN 1 AND 5
 GROUP BY a.author_id ORDER BY a.author_id;//aqui si entendi el GROUP BY, siempre se usa junto
 al metodo COUNT, la idea es que por ejemplo si el autor tiene 3 libros, no muestre autor libro1,
 autor libro2, autor libro3, si no que mas bien los agrupe autor libro1 libro2 libro3.


 1. que nacionalidades hay?

 SELECT DISTINCT nationality FROM authors WHERE nationality IS NOT NULL;// el DISTINCT es
 como un GROUP BY pero sin hace uso del COUNT, es para filtrar directamente lo que se mostrara.
 Aunque yo filtre los NULL, es valido que hayan autores sin nacionalidad, que tengan NULL.

 2. cuantos escritores hay de cada nacionalidades

 SELECT nationality, COUNT(author_id) AS num_autores FROM authors 
 GROUP BY nationality ORDER BY num_autores DESC, nationality;//aqui los ordena primero por numero
 de autores monstrandolos de mayor a menor, y despues si hay por ejemplo 3 paises con 2 
 autores, estos los ordenara alfabeticamente y de forma ascedente que es por defecto ya que no
 le especifique.

SELECT nationality, COUNT(author_id) AS num_autores FROM authors WHERE nationality IS NOT NULL
AND nationality <> 'RUS'
 GROUP BY nationality ORDER BY num_autores DESC, nationality;//que no traiga el null, y tampoco
 a rusia. Tambien se puede usar este comando NOT IN ('RUS').

 SELECT nationality, COUNT (book_id) AS libros, AVG(prices) AS promedio_precio, STDDEV(price) AS 
 desviacion_standard FROM books AS b JOIN authors AS a ON a.author_id = b.author_id GROUP BY
 nationality ORDER BY libros DESC;// dame el promedio del precio de los libros y desviacion
 estandar de los mismos, el numero de ellos y agrupamelos por la nacionalidad.

 SELECT nationality, MAX(price), MIN(price) FROM books AS b JOIN authors AS a
 ON a.author_id = b.author_id GROUP BY
 nationality; //el precio mas alto y mas bajo de libros por pais


 SELECT c.name, t.type, b.title, CONCAT( a.name, "(", a.nationality), ")") AS autor FROM 
transactions AS t LEFT JOIN clients AS c ON c.client_id = t.client_id LEFT JOIN books AS b
ON b.book_id = t.book_id LEFT JOIN authors AS a ON a.author_id = b.author_id;// trae el nombre
del cliente, titulo y autor del libro, de las transacciones registradas.

SELECT TO_DAYS(NOW()); //trae todos los dias transcurridos desde el año 0 gregoriano hasta 
el que especifiquemos , en este caso NOW es el dia actual.


 SELECT c.name, t.type, b.title, CONCAT( a.name, "(", a.nationality), ")") AS autor,
 TO_DAYS(NOW) - TO_DAYS(t.created_at) AS ago FROM 
transactions AS t LEFT JOIN clients AS c ON c.client_id = t.client_id LEFT JOIN books AS b
ON b.book_id = t.book_id LEFT JOIN authors AS a ON a.author_id = b.author_id;//
lo mismo que la anterior, pero ahora nos trae cuantos dias pasaron desde hoy, hasta el dia
que se registro la transaccion de los libros

SELECT * FROM authors ORDER BY RAND() LIMIT 10; // con RAND nos ordenara de manera aleatoria
los autores que traera.

DELETE FROM authors WHERE author_id = 161 LIMIT 1; //es buena practica limitar la eliminacion
a uno, no se que hallan valores repetidos.

SELECT client_id, name FROM clients WHERE client_id IN (3,5,7);//nos traera los clientes 
con los ids de los valores en los parentesis del IN es como una lista.

UPDATE clients SET active = 0 WHERE client_id = 181 LIMIT 1;// actualiza el valor active
del usuario 181. Btw siempre colocar el WHERE en las sentencias UPDATE y DELETE.

SELECT sum(price) FROM books WHERE sellable = 1;//suma todos los precios de los libros con 
valor true en sellable.

SELECT COUNT(*) FROM books; = SELECT * COUNT(book_id), SUM(1) FROM books;//aqui el SUM suma 1
por cada registro, es como un for, ah y es recomendable indicar la primary key de una tabla
para usarla con el COUNT y asi sumar los registros en vez de usar el *

SELECT sum(price*copies) FROM books WHERE sellable = 1;

SELECT COUNT (book_id), SUM(IF(b.year < 1950,1,0)) AS 'menor a 1950' FROM books AS b;//aqui
usamos una condicion para si la columna año de la tabla books su valor es menor a 1950, si
es asi entonces le dara un valor de 1 al metodo SUM asi el contara ese registro, de lo
contrario no lo sumara, es decir, el query es traeme el numero de libros que su año
sea antes de 1950.

SELECT COUNT(book_id) FROM books WHERE year < 1950; -- es lo mismo que el query de arriba, btw
	-- con los -- hacemos comentarios por linea
SELECT COUNT (book_id), SUM(IF(b.year < 1950,1,0)) AS 'menor a 1950',
SUM(IF(b.year > 1950,1,0)) AS 'mayor a 1950' FROM books AS b;//la suma de las columnas
de menor y mayor que deberian dar igual que la suma del COUNT.

SELECT COUNT (book_id), SUM(IF(b.year < 1950,1,0)) AS 'menor a 1950',
SUM(IF(b.year >= 1950 AND b.year < 1990,1,0)) AS 'menor a 1990',
SUM(IF(b.year >= 1990 AND b.year < 2000,1,0)) AS 'menor a 2000',
SUM(IF(b.year >= 2000,1,0)) AS 'menor a hoy'
 FROM books AS b;--todos los libros que su año de salida es menora 1950, 1990 , 2000 y 
 hasta hoy.

 SELECT nationality, COUNT (book_id), SUM(IF(b.year < 1950,1,0)) AS 'menor a 1950',
SUM(IF(b.year >= 1950 AND b.year < 1990,1,0)) AS 'menor a 1990',
SUM(IF(b.year >= 1990 AND b.year < 2000,1,0)) AS 'menor a 2000',
SUM(IF(b.year >= 2000,1,0)) AS 'menor a hoy'
 FROM books AS b JOIN authors AS a ON b.author_id = a.author_id WHERE nationality IS NOT NULL
 GROUP BY nationality;-- lo mismo que el anterior query pero dividido/agrupado por paises
 -- ah y que no sean null

 mysqldump--herramienta fuera de sql para crear y importar archivo sql











 --sql linkeind course---------------------------------------------------------------------------------------------------------------------

 SHOW DATABASES;

 SHOW TABLES;

 CREATE TABLE user_type(
     id INT NOT NULL AUTO_INCREMENT,
     name VARCHAR(20) NOT NULL,
     PRIMARY KEY (id)
     )ENGINE=INNODB DEFAULT CHARSET=utf8mb4;--motor innodb recomendado con charset utf8mb4 el utf8 solo ya no se recomienda

DESCRIBE user_type;

CREATE TABLE user(
     id INT NOT NULL AUTO_INCREMENT,
     email VARCHAR(50) NOT NULL,
     password varchar(50) NOT NULL,
     PRIMARY KEY (id)
     )ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

     ALTER TABLE user ADD COLUMN user_type_id INT(11) NOT NULL AFTER password, ADD INDEX fk_user_user_type_idx (user_type_id ASC);

ALTER TABLE `user` 
ADD CONSTRAINT `fk_user_user_type`
  FOREIGN KEY (`user_type_id`)
  REFERENCES `user_type` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION

  --los nombres de columnas y campos puede ser con o sin comillas

ALTER TABLE user DROP CONSTRAINT `fk_user_user_type`;--SE PUDEN BORRAR LLAVES FORANEAS
ALTER TABLE user DROP INDEX fk_user_user_type_idx;-- TAMBIEN INDICES

ALTER TABLE user DROP COLUMN user_type_id;--esta columna tenia un indice y tambien era una clave foranea, de querer
--eliminarla, primero eliminamos su funcion de foreing key/ constraint, y despues su index, tal cual las ultimas 3 lineas
--POR CIERTO IMPORTANTE usando el MYSQLWORKBENCH al final de 
--ALTER TABLE user ADD COLUMN user_type_id INT(11) NOT NULL AFTER password, 
--ADD INDEX fk_user_user_type_idx (user_type_id ASC) colocaba un VISIBLE, me daba error con ese parametro;



  ALTER TABLE post ADD INDEX post_usuarios_idx (usuario_id);//añadimos un indice a la columna usuario_id, sirve para busquedas

ALTER TABLE post ADD CONSTRAINT post_usuarios FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE NO ACTION ON UPDATE CASCADE;// agregamos la clave foranea con un constraint que nombramos post_usuarios

ALTER TABLE post ADD INDEX post_categorias_idx (categoria_id);

ALTER TABLE post ADD CONSTRAINT post_categorias FOREIGN KEY (categoria_id) REFERENCES categorias (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE person CHANGE date_of_birt date_of_birth INT(11) NOT NULL;--cambie el nombre del campo que estaba mal escrito, faltaba la h

ALTER TABLE person CHANGE date_of_birth date_of_birth DATE NOT NULL;--cambie el tipo INT a DATE, es necesario volver a "renombrar"


--PETICIONES-----------------------------------------------------------------------
SELECT version();--funcion que trae la version de sql
SELECT now();--fecha y hora actual
STATUS;--estado de la conexion
DESCRIBE user;--describe una tabla

SELECT CONCAT('bernardo','pineda');--concatena campos

SELECT dayName('1991-07-11');--DEVUELVE el nombre del dia que pasemos, el nombre del metodo is incasesensitive puede ser dayname O EN MAYUS

SELECT length('bernardo');--longitud de lo que le pasemos

SELECT 50+200;--SUMA

SELECT ROUND(3.5);--REDONDEA AQUI SERIA 4

--IMPORTAR DATOS ARCHIVO EXTERNO

mysql -u root -D sql_course_wb < peticiones_news.sql -- logeamos a la base de datos, en este caso con el usuario root
--y indicamos que base de datos importara el archivo peticiones, dentro de este ultimo hay sentencias para crear una tabla news
-- y llenarla de datos, debemos logear desde donde esta el archivo, recordar que el comando mysql del archivo mysql.exe que esta en xampp
-- ya tiene su directorio en la variable path de variables de entorno para usarlo donde sea
--este comando solo es para registrar ese archivo con sentencias a la base de datos, no logea


--tambien se puede hacer desde el phpmyadmin en la opcion importar

mysql -D sql_course_wb-- asi inicio sql directamente con la base de datos que quiero usar(recordar que mi usuario de PC tambien esta como un usuario de root)
--si no tendriamos que usar por ejemplo al usuario root como en el comando de arriba


SELECT id FROM news WHERE id <> 6; --todos los  ids de los registros  menos el correspodientes al id 6

SELECT id FROM news WHERE publish_date >= "2016-01-01";--todas las publicaciones a partir del 2016-01-01

SELECT id, title FROM news WHERE publish_date >= "2015-01-01" AND publish_date <= "2015-12-31";--todas las publicaciones del año 2015



INSERT INTO person (id,name,last_name,date_of_birth) VALUES (null,"johan","pineda","1991-07-11");

INSERT INTO person VALUES (null,"johan","pineda","1991-07-11");--tambien se pueden insertar datos asi

INSERT INTO person (id,name,last_name,date_of_birth) VALUES (null,"carla","lana","1991-11-28");

INSERT INTO person SET id=null, name= 'marco', last_name= 'jaeger', date_of_birth="1992-08-12";--tambien se pueden registrar asi con el comando SET

--recordar que mandamos al id como null, por que autoincrementable

INSERT INTO person VALUES (null,"alexis",null,"1991-07-11");--el apellido puede ser null, nos demas son NOT NULL



DELETE FROM news;--borra todos los registros

DELETE FROM news WHERE id=10 LIMIT 1;--el limit es por buena practica asi aseguramos que elimine un registro

SELECT id, title, publish_date FROM news WHERE publish_date < "2016-01-01" OR publish_date > "2016-12-31";

DELETE FROM news WHERE publish_date < "2016-01-01" OR publish_date > "2016-12-31";--con la sentencia anterior verificamos que el filtro que usaremos
--para borrar sea el correcto



DROP TABLE news;--eliminar una tabla



UPDATE news SET title= 'Nuevo curso de python';--cambiara todos los titles de los registros en news

UPDATE news SET title= 'Curso de php' WHERE id=2 LIMIT 1;--cambiamos el titulo del segundo curso, antes se llamaba 'Nuevo curso de php'

UPDATE news SET title = 'Curso de SQL', status=2 WHERE id=1;--cambia el nombre del curso y su status con el id 1

UPDATE news SET status= 3 WHERE publish_date < '2016-01-01';--cambia el status a todos los registros antes del año 2016

SELECT id,title,status,publish_date FROM news WHERE status=3;


UPDATE news SET status= 0 WHERE id= 1;-- borrado logico, al darle al registro 1 el status de 0, es decir eliminado

SELECT id,title,status,publish_date FROM news WHERE status!=0;--filtro para que no se seleccionen los "eliminados" 

UPDATE news SET status=1 WHERE id=1 LIMIT 1;--volvio el dato, hay varias estrategias para "eliminar" datos sin que sea un borrado fisico es decir con un DELETE

SELECT id,title,publish_date,status FROM news WHERE title LIKE 'Nuevo%';--comienze con Nuevo

SELECT id,title,publish_date,status FROM news WHERE title LIKE '%Ruby';--termine con Ruby

SELECT id,title,publish_date,status FROM news WHERE title LIKE '%Ruby%';--ruby en cualquier parte del dato

SELECT id,title,publish_date,status FROM news WHERE title LIKE 'Nuevo%' and title LIKE '%Ruby%';--comienze con Nuevo y tenga Ruby en alguna parte

SELECT id,title,publish_date,status FROM news ORDER BY id DESC;--mayor a menor

SELECT id,title,publish_date,status FROM news ORDER BY title;--ALFABETICAMENTE

SELECT id,title,publish_date,status FROM news ORDER BY publish_date;--años atras a posteriores

SELECT id,title,publish_date,status FROM news ORDER BY publish_date DESC;--años mas recientes a anteriores

SELECT id,title,publish_date,status FROM news LIMIT 5;--Solo traera 5 registros

SELECT id,title,publish_date,status FROM news LIMIT 5,10;--desde el quinto registro muestrame 10 registros

SELECT news.id,news.title,news.status,status.* FROM news,status WHERE news.status= status.id;--todos los registros donde los status de news 
--coincidan con el tipo de status de la tabla status

SELECT news.id,news.title,news.status,status.* FROM news INNER JOIN status ON news.status= status.id;-- lo mismo que la sentencia 
--anterior pero con inner join


SELECT news.id,news.title,news.status,status.* FROM news LEFT JOIN status ON news.status= status.id;--trae todos los registros de la 
--tabla de la izquierda  en este caso news que hara de pivote, y todos los de la derecha status, pero donde no coinciden en relacion pondra null en sus datos

SELECT news.id,news.title,news.status,status.* FROM news RIGHT JOIN status ON news.status= status.id;--aqui el pivote seria la tabla status
--entonces muestra todos los registros de la tabla de la derecha, y pondra null en los que no correspondan en la izquierda

SELECT COUNT(*) FROM news;--conteo de todos los registros de news

SELECT COUNT(*) FROM news WHERE publish_date < "2016-01-01";--todos los registros con fecha antes del año 2016

SELECT id AS Identificador, title AS Titulo FROM news;--alias

SELECT COUNT(*) AS conteo_datos FROM news;--alias


SELECT id AS Identificador, title AS Titulo, publish_date AS fecha, status FROM news 
WHERE publish_date > '2014-12-31' AND title NOT LIKE '%Ruby%';--cursos despues de 2014 que no sean de Ruby

SELECT * FROM (SELECT id AS Identificador, title AS Titulo, publish_date AS fecha, status FROM news 
WHERE publish_date > '2014-12-31' AND title NOT LIKE '%Ruby%') AS T1;--encerramos las subqueries, es decir previas sentencias de busquedad
--que funcionan como si fueran tablas entre parentesis, y les damos un alias, aqui 'T1'  de otra forma sql no lo ejecuta

SELECT * FROM (SELECT id AS Identificador, title AS Titulo, publish_date AS fecha, status FROM news 
WHERE publish_date > '2014-12-31' AND title NOT LIKE '%Ruby%') AS T1 WHERE status=1;--todos los registros donde status igual a 1

SELECT * FROM (SELECT id AS Identificador, title AS Titulo, publish_date AS fecha, status FROM news 
WHERE publish_date > '2014-12-31' AND title NOT LIKE '%Ruby%') AS T1 WHERE status=1 AND fecha > '2015-12-31';--todos los registros despues
--de 2015, notese que para la condicion usamos el alias de publish_date que es fecha



SELECT * FROM (SELECT id AS Identificador, title AS Titulo, publish_date AS fecha, status FROM news 
WHERE publish_date > '2014-12-31' AND title NOT LIKE '%Ruby%') AS T1 WHERE status=1 AND fecha > '2015-12-31' AND titulo NOT LIKE '%JS%'
ORDER BY fecha;
--todos los registros despues del año 2015 que no sean de RUBY ni de angularJS, y que tengan status 1, ordenado por fechas

SELECT user.*,user_log.* FROM user INNER JOIN user_log ON user.id= user_log.user_id;--todos los usuarios que han entrado al sistema al
--menos una vez

SELECT user.*,user_log.* FROM user INNER JOIN user_log ON user.id= user_log.user_id WHERE user.id= 1 ORDER BY date_logged_in DESC LIMIT 1;
--cuando fue la ultima vez que entro al sistema el usuario admin osea el 1, el DESC indica la mayor fecha

SELECT user.*, status.name FROM user INNER JOIN status ON user.status_id = status.id;--que nombre de status tienen los usuarios, pensando 
-- que en la tabla user solo esta el numero de id, pero el nombre esta en la tabla status

SELECT user.email,user_type.* FROM user INNER JOIN user_type ON user.user_type_id= user_type.id;--tipo de usuario de cada usuario en la BD