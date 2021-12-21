CREATE TABLE manufacturer_types (
    manufacturer_type_id SERIAL PRIMARY KEY,
    manufacturer_type TEXT NOT NULL UNIQUE,
    comment TEXT
);
INSERT INTO manufacturer_types (manufacturer_type) VALUES ('strings');
INSERT INTO manufacturer_types (manufacturer_type) VALUES ('musical instruments');

CREATE TABLE manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    manufacturer_name TEXT NOT NULL,
    manufacturer_type TEXT NOT NULL, FOREIGN KEY (manufacturer_type) REFERENCES manufacturer_types (manufacturer_type),
    UNIQUE(manufacturer_name,manufacturer_type),
    comment TEXT
);
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('D''Addario','strings');

-- strings
CREATE TABLE strings (
    string_id SERIAL PRIMARY KEY,
    manufacturer_id BIGINT NOT NULL, FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id),
    string_name TEXT NOT NULL,
    string_density NUMERIC DEFAULT 0 NOT NULL,
    string_unit_weight NUMERIC DEFAULT 0 NOT NULL,
    string_thickness NUMERIC DEFAULT 0 NOT NULL,
    string_tensile_strength NUMERIC DEFAULT 0 NOT NULL,
    UNIQUE(manufacturer_id, string_name, string_density, string_unit_weight, string_thickness),
    string_description TEXT,
    comment TEXT
);
INSERT INTO strings(manufacturer_id, string_name, string_unit_weight ) VALUES (
    (SELECT manufacturer_id from manufacturers where manufacturer_name='D''Addario' AND manufacturer_type='strings'),
    'J4301',
    .00002024
);

CREATE TABLE string_sets (
    string_set_id SERIAL PRIMARY KEY,
    string_set_name TEXT NOT NULL,
	manufacturer_id BIGINT NOT NULL, FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id),
    number_of_strings int NOT NULL,
    UNIQUE(string_set_name,number_of_strings),
    UNIQUE(manufacturer_id,string_set_name,number_of_strings),
    comment TEXT
);
INSERT INTO string_sets (manufacturer_id, string_set_name, number_of_strings ) VALUES (
    (SELECT manufacturer_id from manufacturers where manufacturer_name='D''Addario' AND manufacturer_type='strings'),'EXL-120',6);

---
CREATE TABLE strings_in_sets (
    string_id BIGINT NOT NULL, FOREIGN KEY (string_id) REFERENCES strings (string_id),
    string_set_name TEXT NOT NULL, FOREIGN KEY (string_set_name) REFERENCES string_sets (string_set_name),
    string_order int NOT NULL,
    UNIQUE(string_id,string_set_name,string_order),
    comment TEXT
);
---

CREATE TABLE attributes (
    attribute_id SERIAL PRIMARY KEY,
    attribute_name TEXT NOT NULL UNIQUE,
    comment TEXT
);

CREATE TABLE string_attributes (
    string_id BIGINT NOT NULL,
    attribute_name TEXT NOT NULL,
    PRIMARY KEY (string_id, attribute_name),
    FOREIGN KEY (string_id) REFERENCES strings (string_id),
    FOREIGN KEY (attribute_name) REFERENCES attributes (attribute_name),
    comment TEXT
);

CREATE TABLE string_scales (
    string_id BIGINT NOT NULL,
    string_minimum_scale NUMERIC NOT NULL,
    string_maximum_scale NUMERIC NOT NULL,
    FOREIGN KEY (string_id) REFERENCES strings (string_id),
    comment TEXT
);

--- instrument tables
CREATE TABLE instruments (
    instrument_id SERIAL PRIMARY KEY,
    instrument_name TEXT NOT NULL,
    instrument_culture TEXT NOT NULL DEFAULT '',
    UNIQUE(instrument_name,instrument_culture),
    comment TEXT
);
INSERT INTO instruments (instrument_name,instrument_culture) VALUES ( 'guitar', '',false );
INSERT INTO instruments (instrument_name,instrument_culture) VALUES ( 'guitar', 'brazillian',false  );
INSERT INTO instruments (instrument_name,instrument_culture) VALUES ( 'guitar', 'german',false  );
INSERT INTO instruments (instrument_name,instrument_culture) VALUES ( 'guitar', 'russian',false  );

CREATE TABLE instrument_types (
    instrument_type_id SERIAL PRIMARY KEY,
    instrument_type TEXT NOT NULL UNIQUE,
    comment TEXT
);
INSERT INTO instrument_types (instrument_type) VALUES ( 'stringed' );

CREATE TABLE instrument_categories (
    nstrument_category_id SERIAL PRIMARY KEY,
    instrument_category TEXT NOT NULL UNIQUE,
    comment TEXT
);
INSERT INTO instrument_categories (instrument_category) VALUES ( 'classical' );
INSERT INTO instrument_categories (instrument_category) VALUES ( 'acoustic' );

CREATE TABLE instrument_classifications (
    instrument_id SERIAL PRIMARY KEY,
    instrument_name TEXT NOT NULL, FOREIGN KEY (instrument_name) REFERENCES instruments (instrument_name),
    instrument_type TEXT NOT NULL, FOREIGN KEY (instrument_type) REFERENCES instrument_types (instrument_type),
    instrument_category TEXT NOT NULL, FOREIGN KEY (instrument_category) REFERENCES instrument_categories (instrument_category),
    number_of_actuators INT NOT NULL,
    UNIQUE( instrument_name, instrument_type, instrument_category, number_of_actuators),
    comment TEXT
);
INSERT INTO instruments (instrument_name,instrument_type,instrument_category,number_of_actuators) VALUES ('guitar','stringed','classical',6);

CREATE TABLE string_instruments (
    string_id BIGINT NOT NULL,
    instrument_id BIGINT NOT NULL,
    PRIMARY KEY (string_id, instrument_id),
    FOREIGN KEY (string_id) REFERENCES strings (string_id),
    FOREIGN KEY (instrument_id) REFERENCES instruments (instrument_id),
    comment TEXT
);

-- https://en.wikipedia.org/wiki/String_vibration
CREATE TABLE harmonics (
    L NUMERIC NOT NULL,
    rho NUMERIC NOT NULL,
    d NUMERIC NOT NULL,
    T NUMERIC NOT NULL,
    n int NOT NULL DEFAULT 1,
    frequency NUMERIC GENERATED ALWAYS AS ((n/L*d)*sqrt(T/PI()*rho)) STORED,
	wavelength NUMERIC GENERATED ALWAYS AS ((2*L/n)) STORED
);

CREATE TABLE musical_notes (
    note_id SERIAL PRIMARY KEY,
    international_pitch_notation TEXT NOT NULL UNIQUE,
    note_frequency NUMERIC NOT NULL, 
    note_description TEXT,
    comment TEXT
);

CREATE TABLE materials (
    material_id SERIAL PRIMARY KEY,
    material_name TEXT NOT NULL UNIQUE,
    comment TEXT
);

CREATE TABLE string_materials (
    string_id BIGINT NOT NULL,
    material_id BIGINT NOT NULL,
    PRIMARY KEY (string_id, material_id),
    FOREIGN KEY (string_id) REFERENCES strings (string_id),
    FOREIGN KEY (material_id) REFERENCES materials (material_id),
    comment TEXT
);
