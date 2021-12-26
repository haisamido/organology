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

-- strings
CREATE TABLE strings (
    string_id SERIAL PRIMARY KEY,
    manufacturer_id BIGINT NOT NULL, FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id),
    manufacturer_string_id TEXT NOT NULL,
    density NUMERIC DEFAULT 0 NOT NULL,
    unit_of_density NUMERIC DEFAULT 0 NOT NULL,
    unit_weight NUMERIC DEFAULT 0 NOT NULL,
    unit_of_unit_weight TEXT NOT NULL,FOREIGN KEY (unit_of_unit_weight) REFERENCES units (unit),
    thickness NUMERIC DEFAULT 0 NOT NULL,
    unit_of_thickness NUMERIC DEFAULT 0 NOT NULL,
    tensile_strength NUMERIC DEFAULT 0 NOT NULL,
    unit_of_tensile_strength NUMERIC DEFAULT 0 NOT NULL,
    source TEXT DEFAULT '' NOT NULL,
    UNIQUE(manufacturer_id, manufacturer_string_id, density, unit_weight,unit_of_unit_weight,thickness,unit_of_thickness,tensile_strength,unit_of_tensile_strength),
    description TEXT,
    comment TEXT
);
INSERT INTO strings(manufacturer_id, manufacturer_string_id, unit_weight, unit_of_unit_weight, source ) VALUES (
    (SELECT manufacturer_id from manufacturers where manufacturer_name='D''Addario' AND manufacturer_type='strings'),
    'J4301',.00002024,'lb/in',
    'https://www.daddario.com/globalassets/pdfs/accessories/tension_chart_13934.pdf'
);
INSERT INTO strings(manufacturer_id, manufacturer_string_id, unit_weight, unit_of_unit_weight, source ) VALUES ( (SELECT manufacturer_id from manufacturers where manufacturer_name='D''Addario' AND manufacturer_type='strings'),
    'J4302',.00002729,'lb/in',
    'https://www.daddario.com/globalassets/pdfs/accessories/tension_chart_13934.pdf'
);

CREATE TABLE strings2 (
    string_id SERIAL PRIMARY KEY,
    manufacturer_id BIGINT NOT NULL, FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id),
    manufacturer_string_id TEXT NOT NULL,
    instrument_id BIGINT NOT NULL, FOREIGN KEY (instrument_id) REFERENCES instruments (instrument_id),
    unit_weight NUMERIC DEFAULT 0 NOT NULL,
    unit_of_unit_weight TEXT NOT NULL,FOREIGN KEY (unit_of_unit_weight) REFERENCES units (unit),
    source TEXT DEFAULT '' NOT NULL,
    UNIQUE(manufacturer_id, manufacturer_string_id, unit_weight, unit_of_unit_weight),
    description TEXT,
    comment TEXT
);
INSERT INTO strings2(manufacturer_id, manufacturer_string_id, unit_weight, unit_of_unit_weight, instrument_id,source ) VALUES ( 
    (SELECT manufacturer_id from manufacturers where manufacturer_name='D''Addario' AND manufacturer_type='strings'),
    'J4302',
    .00002729,
    'lb/in',
    array(select * from instruments where name='guitar' and type='stringed' and category='classical'),
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
    (SELECT manufacturer_id from manufacturers where manufacturer_name='D''Addario' AND manufacturer_type='strings'),
    'EXL-120',
    6);

-- CREATE TABLE strings_in_sets (
--     string_id BIGINT NOT NULL, FOREIGN KEY (string_id) REFERENCES strings (string_id),
--     string_set_name TEXT NOT NULL, FOREIGN KEY (string_set_name) REFERENCES string_sets (string_set_name),
--     string_order int NOT NULL,
--     UNIQUE(string_id,string_set_name,string_order),
--     comment TEXT
-- );

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

CREATE TABLE adjustable_scale_length_types (
    id SERIAL PRIMARY KEY,  
    type TEXT NOT NULL UNIQUE,
    description TEXT NULL DEFAULT '',
    comment TEXT
);
INSERT INTO adjustable_scale_length_types (type,description) VALUES ( 'NA', 'not applicable' );
INSERT INTO adjustable_scale_length_types (type) VALUES ( 'fret' );
INSERT INTO adjustable_scale_length_types (type) VALUES ( 'fretless' );

CREATE TABLE instruments (
    instrument_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL, FOREIGN KEY (category) REFERENCES instrument_categories (instrument_category),
    subcategory TEXT NOT NULL DEFAULT '',
    type TEXT NOT NULL, FOREIGN KEY (type) REFERENCES instrument_types (type),
    style TEXT NOT NULL DEFAULT '',
    number_of_actuators INT NOT NULL,
    electric BOOLEAN NOT NULL DEFAULT 'false',
    adjustable_scale_length BOOLEAN NOT NULL DEFAULT 'true',
    adjustable_scale_length_type TEXT NOT NULL DEFAULT 'fret', FOREIGN KEY (adjustable_scale_length_type) REFERENCES adjustable_scale_length_types (type),
    multi_scale BOOLEAN NOT NULL DEFAULT 'false',
    comment TEXT,
    UNIQUE(name,category,subcategory,type,style,number_of_actuators,electric,adjustable_scale_length,adjustable_scale_length_type,multi_scale)
);
INSERT INTO instruments (type,name,category,style,number_of_actuators) VALUES ('stringed','guitar','classical','spanish',6);
INSERT INTO instruments (type,name,category,style,number_of_actuators,adjustable_scale_length_type) VALUES ('stringed','guitar','classical','spanish',6,'fretless');
INSERT INTO instruments (type,name,category,style,number_of_actuators,multi_scale) VALUES ('stringed','guitar','classical','spanish',6,'true');
INSERT INTO instruments (type,name,category,style,number_of_actuators,electric) VALUES ('stringed','guitar','classical','spanish',6,'true');


CREATE TABLE instrument_attributes (
    id SERIAL PRIMARY KEY,
    key TEXT NOT NULL,
    value TEXT NOT NULL,
    instrument_id BIGINT NOT NULL, FOREIGN KEY (instrument_id) REFERENCES instruments (instrument_id),
    UNIQUE(name, instrument_id),
    description TEXT,
    comment TEXT
);
INSERT INTO instrument_attributes (key,value,instrument_id) VALUES (
    'number_of_actuators',
    6,
    (SELECT instrument_id where type='stringed' and name='guitar' and category='classical')
);

-- INSERT INTO instruments (name,category,type,number_of_actuators) VALUES ('guitar','classical','stringed',6);
-- INSERT INTO instruments (name,category,type,number_of_actuators) VALUES ('guitar','classical-electric','stringed',6);
-- INSERT INTO instruments (name,category,type,number_of_actuators) VALUES ('guitar','acoustic','stringed',6);
-- INSERT INTO instruments (name,category,type,number_of_actuators) VALUES ('guitar','acoustic-electric','stringed',6);
-- INSERT INTO instruments (name,category,type,number_of_actuators,fretted) VALUES ('guitar','classical','stringed',6,'false');
-- INSERT INTO instruments (name,category,type,style,number_of_actuators) VALUES ('guitar','classical','stringed','brazillian',7);
-- INSERT INTO instruments (name,category,type,style,number_of_actuators) VALUES ('guitar','classical','stringed','brazillian',8);
-- INSERT INTO instruments (name,category,type,style,number_of_actuators) VALUES ('guitar','classical','stringed','russian',7);
-- INSERT INTO instruments (name,category,type,number_of_actuators) VALUES ('lute guitar','classical','stringed',6);
-- INSERT INTO instruments (name,category,type,style,number_of_actuators) VALUES ('lute guitar','classical','stringed','german',6);
-- INSERT INTO instruments (name,category,type,style,number_of_actuators) VALUES ('banjo','acoustic','stringed','american',5);

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