-- manufacturers
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
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('Aquila','strings');
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('D''Addario','strings');
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('Elixer','strings');
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('Ernie Ball','strings');
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('La Bella','strings');
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('Martin & Co.','strings');
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('Pyramid','strings');
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('Savarez','strings');
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('Taylor','musical instruments');
INSERT INTO manufacturers(manufacturer_name,manufacturer_type) VALUES ('Doff','musical instruments');

CREATE TABLE units (
    unit_id SERIAL PRIMARY KEY,
    unit TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    comment TEXT
);
INSERT INTO units (unit,description) VALUES ( 'lb/in', 'pound mass per inch');

--- instruments
-- TODO: there are stringed instruments that are not plucked! violin etc. so perhaps stringed should be plucked-string ?
CREATE TABLE instrument_types (
    type_id SERIAL PRIMARY KEY,
    type TEXT NOT NULL UNIQUE,
    actuator_type TEXT NOT NULL,
    comment TEXT,
    UNIQUE(type, actuator_type)
);
INSERT INTO instrument_types (type,actuator_type) VALUES ( 'brass', 'button' );
INSERT INTO instrument_types (type,actuator_type) VALUES ( 'keyboard', 'key' );
INSERT INTO instrument_types (type,actuator_type) VALUES ( 'percussion', 'stick' );
INSERT INTO instrument_types (type,actuator_type) VALUES ( 'stringed', 'pluck' );
INSERT INTO instrument_types (type,actuator_type) VALUES ( 'woodwind', 'breath' );

CREATE TABLE instrument_categories (
    nstrument_category_id SERIAL PRIMARY KEY,
    instrument_category TEXT NOT NULL UNIQUE,
    comment TEXT
);
INSERT INTO instrument_categories (instrument_category) VALUES ( 'acoustic' );
INSERT INTO instrument_categories (instrument_category) VALUES ( 'classical' );
INSERT INTO instrument_categories (instrument_category) VALUES ( 'solid-body' );

CREATE TABLE instruments (
    instrument_id SERIAL PRIMARY KEY,
    type TEXT NOT NULL, FOREIGN KEY (type) REFERENCES instrument_types (type),
    name TEXT NOT NULL,
    category TEXT NOT NULL, FOREIGN KEY (category) REFERENCES instrument_categories (instrument_category),
    UNIQUE(type,name,category),
    description TEXT,
    comment TEXT
);
INSERT INTO instruments (type,name,category) VALUES ('stringed','guitar','classical');

CREATE TABLE instrument_attributes (
    id SERIAL PRIMARY KEY,
    instrument_attribute TEXT NOT NULL UNIQUE,
    instrument_attribute_type TEXT NOT NULL,
    description TEXT,
    comment TEXT  
);
INSERT INTO instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('number_of_actuators', 'INT');
INSERT INTO instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('ethnic_association','TEXT');
INSERT INTO instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('electric','BOOLEAN');
INSERT INTO instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('multi_scale','BOOLEAN');
INSERT INTO instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('adjustable_scale_length','BOOLEAN');
INSERT INTO instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('adjustable_scale_length_type','TEXT');

CREATE TABLE instrument_characteristics (
    id SERIAL PRIMARY KEY,
    instrument_id BIGINT NOT NULL, FOREIGN KEY (instrument_id) REFERENCES instruments (instrument_id),
    instrument_characteristic TEXT NOT NULL, FOREIGN KEY (instrument_characteristic) REFERENCES instrument_attributes (instrument_attribute),
    instrument_characteristic_value TEXT NOT NULL,
    UNIQUE(instrument_id,instrument_characteristic,instrument_characteristic_value),
    description TEXT,
    comment TEXT
);
INSERT INTO instrument_characteristics (instrument_id,instrument_characteristic,instrument_characteristic_value) VALUES (
    (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
    'number_of_actuators',
    6
);
INSERT INTO instrument_characteristics (instrument_id,instrument_characteristic,instrument_characteristic_value) VALUES (
    (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
    'number_of_actuators',
    7
);
INSERT INTO instrument_characteristics (instrument_id,instrument_characteristic,instrument_characteristic_value) VALUES (
    (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
    'number_of_actuators',
    8
);
INSERT INTO instrument_characteristics (instrument_id,instrument_characteristic,instrument_characteristic_value) VALUES (
    (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
    'number_of_actuators',
    9
);
INSERT INTO instrument_characteristics (instrument_id,instrument_characteristic,instrument_characteristic_value) VALUES (
    (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
    'number_of_actuators',
    12
);

-- strings
CREATE TABLE strings (
    string_id SERIAL PRIMARY KEY,
    manufacturer_id BIGINT NOT NULL, FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id),
    manufacturer_string_id TEXT NOT NULL,
    instrument_id BIGINT NOT NULL, FOREIGN KEY (instrument_id) REFERENCES instruments (instrument_id),
    unit_weight NUMERIC DEFAULT 0 NOT NULL,
    unit_of_unit_weight TEXT NOT NULL,FOREIGN KEY (unit_of_unit_weight) REFERENCES units (unit),
    source TEXT DEFAULT '' NOT NULL,
    UNIQUE(manufacturer_id, manufacturer_string_id,unit_weight,unit_of_unit_weight),
    description TEXT,
    comment TEXT
);
INSERT INTO strings(manufacturer_id,manufacturer_string_id,unit_weight,unit_of_unit_weight,instrument_id,source ) VALUES ( 
    (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
    'J4301',
    .00002024,
    'lb/in',
    (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
    'https://www.daddario.com/globalassets/pdfs/accessories/tension_chart_13934.pdf'
);
INSERT INTO strings(manufacturer_id,manufacturer_string_id,unit_weight,unit_of_unit_weight,instrument_id,source ) VALUES ( 
    (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
    'J4302',
    .00002729,
    'lb/in',
    (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
    'https://www.daddario.com/globalassets/pdfs/accessories/tension_chart_13934.pdf'
);

-- string sets
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
    (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
    'EXL-120',
    6);

-- CREATE TABLE strings_in_sets (
--     string_id BIGINT NOT NULL, FOREIGN KEY (string_id) REFERENCES strings (string_id),
--     string_set_name TEXT NOT NULL, FOREIGN KEY (string_set_name) REFERENCES string_sets (string_set_name),
--     string_order int NOT NULL,
--     UNIQUE(string_id,string_set_name,string_order),
--     comment TEXT
-- );


-- materials
CREATE TABLE material_types (
    material_id SERIAL PRIMARY KEY,
    material_type TEXT NOT NULL UNIQUE,
    comment TEXT
);

CREATE TABLE materials (
    material_id SERIAL PRIMARY KEY,
    material_name TEXT NOT NULL UNIQUE,
    material_type TEXT NOT NULL, FOREIGN KEY (material_type) REFERENCES material_types (material_type),
    UNIQUE(material_name,material_type),
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

-- attributes
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

-- music
-- https://en.wikipedia.org/wiki/String_vibration
-- http://www.donaldsauter.com/string-calculation.htm
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

CREATE TABLE tunings (
    tuning_id SERIAL PRIMARY KEY,
    tuning TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    comment TEXT
);
INSERT INTO tunings (tuning,description) VALUES ( '12-TET', '12 equal temperament' );
INSERT INTO tunings (tuning,description) VALUES ( '24-TET', '24 equal temperament' );