CREATE TABLE manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    manufacturer_name TEXT NOT NULL UNIQUE,
    comment TEXT
);

CREATE TABLE musical_notes (
    note_id SERIAL PRIMARY KEY,
    international_pitch_notation TEXT NOT NULL UNIQUE,
    note_frequency numeric NOT NULL, 
    note_description TEXT,
    comment TEXT
);

CREATE TABLE strings (
    string_id SERIAL PRIMARY KEY,
    string_name TEXT NOT NULL,
    string_density numeric NOT NULL,
    string_thickness numeric NOT NULL,
    UNIQUE(string_name, string_density, string_thickness),
    string_tensile_strength numeric,
    string_description TEXT,
    comment TEXT
);

CREATE TABLE string_sets (
    string_set_id SERIAL PRIMARY KEY,
    string_set_name TEXT NOT NULL,
    string_id bigint NOT NULL,
    string_order int NOT NULL,
    manufacturer_id bigint NOT NULL,
    FOREIGN KEY (string_id) REFERENCES strings (string_id),
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id),
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

-- this is actually derivable from string length, density, thickness and tension
CREATE TABLE string_notes (
  string_id bigint NOT NULL,
  note_id bigint NOT NULL,
  PRIMARY KEY (string_id, note_id),
  FOREIGN KEY (string_id) REFERENCES strings (string_id),
  FOREIGN KEY (note_id) REFERENCES musical_notes (note_id),
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

-- https://en.wikipedia.org/wiki/String_vibration
CREATE TABLE harmonics (
    L numeric NOT NULL,
    rho numeric NOT NULL,
    d numeric NOT NULL,
    T numeric NOT NULL,
    n int NOT NULL DEFAULT 1,
    frequency numeric GENERATED ALWAYS AS ((n/L*d)*sqrt(T/PI()*rho)) STORED,
	wavelength numeric GENERATED ALWAYS AS ((2*L/n)) STORED
);
