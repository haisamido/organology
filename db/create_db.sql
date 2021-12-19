CREATE TABLE manufacturers (
    manufacturer_id bigint NOT NULL PRIMARY KEY,
    manufacturer_name TEXT,
    comment TEXT
);

CREATE TABLE strings (
    string_id bigint NOT NULL PRIMARY KEY,
    string_name TEXT,
    string_year int,
    string_tensile_strength numeric,
    string_density numeric,
    string_thickness numeric,
    string_description TEXT,
    manufacturer_id bigint NOT NULL,
    comment TEXT
);

CREATE TABLE string_scales (
    string_scale_id bigint NOT NULL PRIMARY KEY,
    string_id bigint NOT NULL,
    string_minimum_scale numeric,
    string_maximum_scale numeric,
    comment TEXT
)

CREATE attributes (
    attribute_id bigint NOT NULL PRIMARY KEY,
    attribute_name TEXT,
    comment TEXT
);

CREATE TABLE string_attributes (
    string_attribute_id bigint NOT NULL PRIMARY KEY,
    string_id bigint NOT NULL,
    attribute_id bigint NOT NULL,
    comment TEXT
);

CREATE TABLE materials (
    material_id bigint NOT NULL PRIMARY KEY,
    material_name TEXT,
    comment TEXT
);

CREATE TABLE string_materials (
    string_material_id bigint NOT NULL PRIMARY KEY,
    string_id bigint NOT NULL,
    material_id bigint NOT NULL,
    comment TEXT
);

CREATE TABLE string_sets (
    string_set_id bigint NOT NULL PRIMARY KEY,
    string_id bigint NOT NULL,
    string_set_name TEXT,
    comment TEXT
);

CREATE TABLE instruments (
    instrument_id bigint NOT NULL PRIMARY KEY,
    instrument_name TEXT UNIQUE,
    comment TEXT
);

CREATE TABLE string_instruments (
    string_instrument_id bigint NOT NULL PRIMARY KEY,
    string_id bigint,
    instrument_id bigint
    comment TEXT
);

