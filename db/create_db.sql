CREATE TABLE manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    manufacturer_name TEXT NOT NULL UNIQUE,
    comment TEXT
);

CREATE TABLE strings (
    string_id SERIAL PRIMARY KEY,
    string_name TEXT NOT NULL,
    string_tensile_strength numeric NOT NULL,
    string_linear_density numeric NOT NULL,
    string_thickness numeric NOT NULL,
    string_description TEXT NOT NULL,
    comment TEXT
);

-- https://en.wikipedia.org/wiki/String_vibration
CREATE TABLE string_frequencies (
    string_id bigint NOT NULL PRIMARY KEY,
    string_length numeric NOT NULL,
    string_linear_density numeric NOT NULL,
    string_tension numeric NOT NULL,
    string_frequency numeric GENERATED ALWAYS AS ((1.0/2*string_length)*sqrt(string_tension/string_linear_density)) STORED,
    FOREIGN KEY (string_id) REFERENCES strings (string_id)
);

CREATE TABLE musical_notes (
    note_id SERIAL PRIMARY KEY,
    note TEXT NOT NULL UNIQUE,
    note_description TEXT,
    comment TEXT
);

CREATE TABLE string_manufacturers (
  string_id bigint NOT NULL,
  manufacturer_id bigint NOT NULL,
  string_manufacturer_date date NOT NULL,
  PRIMARY KEY (string_id, manufacturer_id),
  FOREIGN KEY (string_id) REFERENCES strings (string_id),
  FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id)
);

CREATE TABLE string_scales (
    string_id bigint NOT NULL,
    string_minimum_scale numeric NOT NULL,
    string_maximum_scale numeric NOT NULL,
    FOREIGN KEY (string_id) REFERENCES strings (string_id),
    comment TEXT
);

CREATE TABLE attributes (
    attribute_id bigint NOT NULL PRIMARY KEY,
    attribute_name TEXT NOT NULL UNIQUE,
    comment TEXT
);

CREATE TABLE string_attributes (
    string_id bigint NOT NULL,
    attribute_id bigint NOT NULL,
    PRIMARY KEY (string_id, attribute_id),
    FOREIGN KEY (string_id) REFERENCES strings (string_id),
    FOREIGN KEY (attribute_id) REFERENCES attributes (attribute_id),
    comment TEXT
);

CREATE TABLE materials (
    material_id SERIAL PRIMARY KEY,
    material_name TEXT NOT NULL UNIQUE,
    comment TEXT
);

CREATE TABLE string_materials (
    string_id bigint NOT NULL,
    material_id bigint NOT NULL,
    PRIMARY KEY (string_id, material_id),
    FOREIGN KEY (string_id) REFERENCES strings (string_id),
    FOREIGN KEY (material_id) REFERENCES materials (material_id),
    comment TEXT
);

CREATE TABLE string_sets (
    string_set_id SERIAL PRIMARY KEY,
    string_id bigint NOT NULL,
    manufacturer_id bigint NOT NULL,
    FOREIGN KEY (string_id) REFERENCES strings (string_id),
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id),
    string_set_name TEXT NOT NULL,
    comment TEXT
);

CREATE TABLE instruments (
    instrument_id SERIAL PRIMARY KEY,
    instrument_name TEXT UNIQUE,
    comment TEXT
);

CREATE TABLE string_instruments (
    string_id bigint NOT NULL,
    instrument_id bigint NOT NULL,
    PRIMARY KEY (string_id, instrument_id),
    FOREIGN KEY (string_id) REFERENCES strings (string_id),
    FOREIGN KEY (instrument_id) REFERENCES instruments (instrument_id),
    comment TEXT
);

