CREATE TABLE manufacturers (
    manufacturer_id bigint NOT NULL PRIMARY KEY,
    manufacturer_name TEXT NOT NULL,
    comment TEXT
);

CREATE TABLE strings (
    string_id bigint NOT NULL PRIMARY KEY,
    string_name TEXT NOT NULL,
    string_date date NOT NULL,
    string_tensile_strength numeric NOT NULL,
    string_density numeric NOT NULL,
    string_thickness numeric NOT NULL,
    string_description TEXT NOT NULL,
    manufacturer_id bigint NOT NULL,
    comment TEXT
);

CREATE TABLE string_scales (
    string_scale_id bigint NOT NULL PRIMARY KEY,
    string_id bigint NOT NULL,
    string_minimum_scale numeric NOT NULL,
    string_maximum_scale numeric NOT NULL,
    comment TEXT
)

CREATE attributes (
    attribute_id bigint NOT NULL PRIMARY KEY,
    attribute_name TEXT NOT NULL,
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
    material_name TEXT NOT NULL,
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
    string_set_name TEXT NOT NULL,
    comment TEXT
);

CREATE TABLE instruments (
    instrument_id bigint NOT NULL PRIMARY KEY,
    instrument_name TEXT UNIQUE,
    comment TEXT
);

CREATE TABLE string_instruments (
    string_instrument_id bigint NOT NULL PRIMARY KEY,
    string_id bigint NOT NULL,
    instrument_id bigint NOT NULL,
    comment TEXT
);

