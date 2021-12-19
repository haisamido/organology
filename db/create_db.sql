CREATE TABLE manufacturers (
    manufacturer_id bigint NOT NULL,
    manufacturer_name TEXT,
    comment TEXT
);

CREATE TABLE strings (
    string_id bigint NOT NULL,
    string_name TEXT,
    string_tensile_strength numeric,
    string_guage numeric,
    manufacturer_id bigint NOT NULL,
    comment TEXT
);

CREATE attributes (
    attribute_id,
    attribute_name TEXT,
    comment TEXT
);

CREATE TABLE string_attributes (
    string_attribute_id bigint NOT NULL,
    string_id bigint NOT NULL,
    attribute_id bigint NOT NULL,
    comment TEXT
);

CREATE TABLE materials (
    material_id bigint NOT NULL,
    material_name TEXT,
    comment TEXT
);

CREATE TABLE string_materials (
    string_material_id bigint NOT NULL,
    string_id bigint NOT NULL,
    material_id bigint NOT NULL,
    comment TEXT
);

CREATE TABLE string_sets (
    string_set_id bigint NOT NULL,
    string_id bigint NOT NULL,
    string_set_name TEXT,
    comment TEXT
);

CREATE TABLE instruments (
    instrument_id bigint NOT NULL,
    instrument_name TEXT UNIQUE,
    comment TEXT
);

CREATE TABLE string_instruments (
    string_instrument_id bigint NOT NULL,
    string_id bigint,
    instrument_id bigint
    comment TEXT
);

