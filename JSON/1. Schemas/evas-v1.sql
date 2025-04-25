create or replace table evas
(
    id_eva int auto_increment
        primary key,
    color  tinytext null
);

create or replace table pilotos
(
    id_piloto     int auto_increment
        primary key,
    nombre_piloto tinytext null
);

create or replace table evas_pilotos
(
    id_eva          int                                  null,
    id_piloto       int                                  null,
    fecha           datetime default current_timestamp() null,
    id_evas_pilotos int auto_increment
        primary key,
    constraint evas_pilotos_evas_id_eva_fk
        foreign key (id_eva) references evas (id_eva),
    constraint evas_pilotos_pilotos_id_piloto_fk
        foreign key (id_piloto) references pilotos (id_piloto)
);

