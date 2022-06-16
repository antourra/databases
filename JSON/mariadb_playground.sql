-- auto-generated definition
create table jugadores_json
(
    id_jugadores_json int auto_increment
        primary key,
    json              text null
);

SELECT *
FROM jugadores_json;

INSERT INTO jugadores_json
SET json = CONCAT('{"nombre": "Barby", "fecha":"', current_timestamp, '"}');

SELECT JSON_UNQUOTE(JSON_EXTRACT(json, '$.fecha'))
FROM jugadores_json;

SELECT JSON_SET(json, '$.nombre', 'Pipe')
FROM jugadores_json;

SELECT CONCAT('{"nombre": "Barby", "fecha":"', current_timestamp, '"}');

UPDATE jugadores_json
SET json = JSON_SET(json, '$.nombre', 'Pipe')
WHERE id_jugadores_json = 1;

UPDATE jugadores_json
SET json = JSON_SET(json, '$.nombre', 'Pipe')
WHERE JSON_UNQUOTE(JSON_EXTRACT(json, '$.nombre')) like '%Barby%';