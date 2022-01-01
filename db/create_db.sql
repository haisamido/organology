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
INSERT INTO units (unit,description,comment) VALUES ( 'lb/in', 'pound mass per inch','is is mu, needs to be converted to g/cm');
INSERT INTO units (unit,description,comment) VALUES ( 'lb', 'pound mass','needs to be converted to g or kg');
INSERT INTO units (unit,description,comment) VALUES ( 'lbf', 'pound force','needs to be converted to Newtons');

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


-- music
-- https://en.wikipedia.org/wiki/String_vibration
-- http://www.donaldsauter.com/string-calculation.htm
CREATE SCHEMA IF NOT EXISTS music AUTHORIZATION postgres;
SET search_path TO public,music;


DROP FUNCTION IF EXISTS music.frequency_by_interval(numeric, numeric, numeric);
CREATE FUNCTION music.frequency_by_interval(
  f0 numeric DEFAULT 440.0, 
  intervals numeric DEFAULT 12, 
  n numeric DEFAULT 0
) RETURNS numeric
  AS 'select (f0*(2^(1/intervals))^n);'
  LANGUAGE SQL
  IMMUTABLE
  RETURNS NULL ON NULL INPUT;
SELECT music.frequency_by_interval(f0=>440.0,intervals=>12, n=>0);
-- SELECT music.frequency_by_interval(f0=>440.0, n=>1);
-- SELECT music.frequency_by_interval(440.0,12,1);

-- https://en.wikipedia.org/wiki/String_vibration
DROP FUNCTION IF EXISTS music.derive_mass_per_length(numeric, numeric, numeric);
CREATE FUNCTION music.derive_mass_per_length(
  tension numeric,
  frequency numeric,
  scale_length numeric
) RETURNS numeric
  AS 'select (tension/((frequency*2*scale_length))^2);'
  LANGUAGE SQL
  IMMUTABLE
  RETURNS NULL ON NULL INPUT;

-- Item#,Unit Weight,g',f',e',d',c',b,a,g
-- PL009,.00001794,18.6,14.7,** 13.1 **,10.4,8.3,7.4,5.8,4.6
-- tension   = 13.1 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), from F=ma
-- frequency = 329.63 Hz, i.e. E4 (e')
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against PL009 spec by Daadario
SELECT music.derive_mass_per_length(tension=>13.1*453.59237*980.665,frequency=>329.63,scale_length => 25.5*2.54)/178.58;

-- Item#,Unit Weight,g',f',e',d',c',b,a,g
-- PL0095,.00001999,20.7,16.4,** 14.6 **,11.6,9.2,8.2,6.5,5.2
-- tension   = 14.6 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), from F=ma
-- frequency = 329.63 Hz, i.e. E4 (e')
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against PL0095 spec by Daadario
SELECT music.derive_mass_per_length(tension=>14.6*453.59237*980.665,frequency=>329.63,scale_length => 25.5*2.54)/178.58;

-- Item#,Unit Weight,f',e',d',c',b,a,g,f
-- J4301,.00002024,16.6,** 14.8 **,11.8,9.3,8.3,6.6,5.2,4.2
-- tension   = 14.8 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), from F=ma, 444822.16152605
-- frequency = 329.63 Hz, i.e. E4 (e')
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against J4301 spec by Daadario
SELECT music.derive_mass_per_length(tension=>14.8*453.59237*980.665,frequency=>329.63,scale_length => 25.5*2.54)/178.58;

-- Item#,Unit Weight,f',e',d',c',b,a,g,f
-- J4503/EXP,.00004679,38.4,** 34.2 **,27.2,21.6,19.2,15.2,12.1,9.6
-- tension   = 34.2 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), from F=ma, 444822.16152605
-- frequency = 329.63 Hz, i.e. E4 (e')
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against J4301 spec by Daadario
SELECT music.derive_mass_per_length(tension=>34.2*453.59237*980.665,frequency=>329.63,scale_length => 25.5*2.54)/178.58;

-- Item#,Unit Weight,f',e',d',c',b,a,g,f
-- J4503/EXP,.00004679,38.4,34.2,27.2,21.6,** 19.2 **,15.2,12.1,9.6
-- tension   = 19.2 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), from F=ma, 444822.16152605
-- frequency = 246.9 Hz, i.e. B3 (b)
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against J4301 spec by Daadario
SELECT music.derive_mass_per_length(tension=>19.2*453.59237*980.665,frequency=>246.9,scale_length => 25.5*2.54)/178.58;

-- https://en.wikipedia.org/wiki/String_vibration
DROP FUNCTION IF EXISTS music.frequency_from_mass_per_length(numeric, numeric, numeric, numeric);
CREATE FUNCTION music.frequency_from_mass_per_length(
  tension numeric, 
  mass_per_length numeric,
  scale_length numeric,
  n numeric DEFAULT 1
) RETURNS numeric
  AS 'select (sqrt(tension/mass_per_length)*(n/(2*scale_length)));'
  LANGUAGE SQL
  IMMUTABLE
  RETURNS NULL ON NULL INPUT;
-- Item#,Unit Weight,g',f',e',d',c',b,a,g
-- PL009,.00001794,18.6,14.7,** 13.1 **,10.4,8.3,7.4,5.8,4.6
-- tension   = 13.1 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), from F=ma
-- frequency = 329.63 Hz, i.e. E4 (e') [RETURNS THIS]
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against PL009 spec by Daadario
SELECT music.frequency_from_mass_per_length(tension=>13.1*453.59237*980.665,mass_per_length=>0.00001794*178.58,scale_length=>25.5*2.54);
  
-- Item#,Unit Weight,f',e',d',c',b,a,g,f
-- J4503/EXP,.00004679,38.4,34.2,27.2,21.6,** 19.2 **,15.2,12.1,9.6
-- tension   = 19.2 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), from F=ma, 444822.16152605
-- frequency = 246.9 Hz, i.e. B3 (b) [RETURNS THIS]
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against J4301 spec by Daadario
SELECT music.frequency_from_mass_per_length(tension =>19.2*453.59237*980.665,mass_per_length=>.00004679*178.58,scale_length=>25.5*2.54);

-- DROP FUNCTION IF EXISTS music.mu(numeric, numeric);
-- CREATE FUNCTION music.mu(
-- 	diameter numeric, 
-- 	density numeric
-- ) RETURNS numeric
-- 	AS 'select (PI()*(diameter^2)*density/4);'
--   LANGUAGE SQL
--   IMMUTABLE
-- 	RETURNS NULL ON NULL INPUT;
-- SELECT music.mu(diameter=>0.00899 * 2.54, density =>7.726 );

-- https://en.wikipedia.org/wiki/E_(musical_note)
-- https://en.wikipedia.org/wiki/Scientific_pitch_notation
CREATE TABLE music.octaves (
  id SERIAL PRIMARY KEY,
  octave_number INT NOT NULL UNIQUE,
  octave_name TEXT NOT NULL UNIQUE,
  midi_number INT NOT NULL UNIQUE,
  UNIQUE(octave_number,octave_name,midi_number)
);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (-1,'subsubcontra',0);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (0,'sub-contra',12);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (1,'contra',24);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (2,'great',36);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (3,'small',48);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (4,'one-lined',60);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (5,'two-lined',72);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (6,'three-lined',84);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (7,'four-lined',96);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (8,'five-lined',108);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (9,'six-lined',120);
INSERT INTO music.octaves (octave_number,octave_name,midi_number) VALUES (10,'seven-lined',132);

-- notes - has quarter tone steps
CREATE TABLE music.notes (
  id SERIAL PRIMARY KEY,
  note TEXT NOT NULL UNIQUE,
  note_also_known_as TEXT NOT NULL DEFAULT '',
  solfege TEXT NOT NULL UNIQUE,
  solfege_also_known_as TEXT NOT NULL DEFAULT '',
  UNIQUE(note,note_also_known_as,solfege,solfege_also_known_as),
  description TEXT,
  comment TEXT
);
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('C','','Do','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('C#','','Do#','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('D','','Re','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('D#','','Re#','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('E','','Mi','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('E#','','Mi#','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('F','','Fa','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('F#','','Fa#','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('G','','Sol','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('G#','','Sol#','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('A','','La','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('A#','','La#','');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('B','H','Si','Ti');
INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('B#','H#','Si#','Ti#');

-- https://en.wikipedia.org/wiki/Scientific_pitch_notation
CREATE TABLE music.international_pitch_notations (
  id SERIAL PRIMARY KEY,
  notation TEXT NOT NULL UNIQUE,
  note TEXT NOT NULL, FOREIGN KEY (note) REFERENCES music.notes(note),
  octave_number INT NOT NULL, FOREIGN KEY (octave_number) REFERENCES music.octaves(octave_number),
  frequency NUMERIC, 
  description TEXT,
  comment TEXT
);
-- music.international_pitch_notations AS music.international_pitch_notations2;
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C-1','C',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#-1','C#',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D-1','D',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#-1','D#',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E-1','E',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F-1','F',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#-1','F#',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G-1','G',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#-1','G#',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A-1','A',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#-1','A#',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B-1','B',-1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C0','C',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#0','C#',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D0','D',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#0','D#',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E0','E',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F0','F',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#0','F#',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G0','G',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#0','G#',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A0','A',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#0','A#',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B0','B',0);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C1','C',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#1','C#',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D1','D',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#1','D#',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E1','E',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F1','F',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#1','F#',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G1','G',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#1','G#',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A1','A',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#1','A#',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B1','B',1);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C2','C',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#2','C#',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D2','D',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#2','D#',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E2','E',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F2','F',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#2','F#',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G2','G',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#2','G#',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A2','A',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#2','A#',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B2','B',2);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C3','C',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#3','C#',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D3','D',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#3','D#',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E3','E',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F3','F',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#3','F#',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G3','G',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#3','G#',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A3','A',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#3','A#',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B3','B',3);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C4','C',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#4','C#',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D4','D',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#4','D#',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E4','E',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F4','F',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#4','F#',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G4','G',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#4','G#',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A4','A',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#4','A#',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B4','B',4);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C5','C',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#5','C#',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D5','D',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#5','D#',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E5','E',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F5','F',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#5','F#',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G5','G',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#5','G#',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A5','A',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#5','A#',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B5','B',5);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C6','C',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#6','C#',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D6','D',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#6','D#',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E6','E',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F6','F',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#6','F#',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G6','G',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#6','G#',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A6','A',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#6','A#',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B6','B',6);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C7','C',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#7','C#',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D7','D',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#7','D#',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E7','E',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F7','F',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#7','F#',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G7','G',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#7','G#',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A7','A',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#7','A#',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B7','B',7);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C8','C',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#8','C#',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D8','D',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#8','D#',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E8','E',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F8','F',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#8','F#',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G8','G',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#8','G#',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A8','A',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#8','A#',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B8','B',8);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C9','C',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#9','C#',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D9','D',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#9','D#',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E9','E',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F9','F',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#9','F#',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G9','G',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#9','G#',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A9','A',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#9','A#',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B9','B',9);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C10','C',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('C#10','C#',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D10','D',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('D#10','D#',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('E10','E',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F10','F',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('F#10','F#',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G10','G',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('G#10','G#',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A10','A',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('A#10','A#',10);
INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('B10','B',10);

-- CREATE TABLE temperaments (
--   id SERIAL PRIMARY KEY,
--   temperament TEXT NOT NULL UNIQUE,
--   description TEXT,
--   comment TEXT
-- );
-- INSERT INTO tunings (temparment,description) VALUES ( '12-TET', '12 equal temperament' );
-- INSERT INTO tunings (temparment,description) VALUES ( '24-TET', '24 equal temperament' );


-- TODO: is a unit conversion table needed? http://www.endmemo.com/sconvert/g_cmlb_in.php
-- TODO: table of tension_classification by manufacturer?
-- grams  = lbm * 453.592292 (mass, and not weight)
-- grams/cm = lbm/in * 178.579673 (mass per length, mu)
-- tension of lbm to metric = tension(lbm)* 444822.08503418 = tension(lbm) * 453.592292*980.665 
-- g0     = 980.665 cm/s**2 (gravity)

-- strings
--  all units must be in metric, g/mm, g, mm, tension => Force => F = m*a => kg * m/s**2 => g * mm/s**2
-- mass_per_length = g/cm
-- scale length    = cm
-- tension        ~= kg (which really mass and not force)

CREATE TABLE materials (
  id SERIAL PRIMARY KEY,
  material_name TEXT NOT NULL UNIQUE,
  description TEXT,
  comment TEXT
);
INSERT INTO materials (material_name) VALUES ('clear nylon');
INSERT INTO materials (material_name) VALUES ('black nylon');
INSERT INTO materials (material_name) VALUES ('titanium nylon');

CREATE TABLE string_tension_categories (
  id SERIAL PRIMARY KEY,
  category TEXT NOT NULL UNIQUE,
  description TEXT,
  comment TEXT
);
INSERT INTO string_tension_categories (category) VALUES ('light tension');
INSERT INTO string_tension_categories (category) VALUES ('medium tension' );
INSERT INTO string_tension_categories (category) VALUES ('hard tension' );
INSERT INTO string_tension_categories (category) VALUES ('extra hard tension');

-- strings from the perspective of the manufacturer
CREATE TABLE strings (
  id SERIAL PRIMARY KEY,
  manufacturer_id BIGINT NOT NULL, FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id),
  part_id TEXT NOT NULL,
  string_family TEXT NOT NULL,
  instrument_id BIGINT NOT NULL, FOREIGN KEY (instrument_id) REFERENCES instruments (instrument_id),
  string_note TEXT NOT NULL, FOREIGN KEY (string_note) REFERENCES music.international_pitch_notations (notation),
  string_order INT NOT NULL,
  string_diameter NUMERIC,
  string_tension_category TEXT NOT NULL, FOREIGN KEY (string_tension_category) REFERENCES string_tension_categories(category),
  string_material TEXT NOT NULL, FOREIGN KEY (string_material) REFERENCES materials (material_name),
  mass_per_length NUMERIC NOT NULL,
  scale_length NUMERIC NOT NULL,
  tension_maximum NUMERIC DEFAULT 0,
  tension_at_note NUMERIC NOT NULL,
  tension_minimum NUMERIC DEFAULT 0,
  UNIQUE(manufacturer_id, part_id),
  UNIQUE(manufacturer_id, part_id, string_family),
  UNIQUE(manufacturer_id, part_id, string_material),
  UNIQUE(manufacturer_id, part_id, string_note),
  UNIQUE(manufacturer_id, part_id, string_order),
  UNIQUE(manufacturer_id, part_id, string_diameter),
  source TEXT,
  description TEXT,
  comment TEXT
);

-- J4301,.00002024,16.6,14.8,11.8,9.3,8.3,6.6,5.2,4.2
INSERT INTO strings(
  manufacturer_id,
  part_id,
  string_family,
  instrument_id,
  string_note,
  string_order,
  string_diameter,
  string_tension_category,
  string_material,
  mass_per_length,  
  scale_length,
  tension_maximum,
  tension_at_note,
  tension_minimum,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4301',
  'Pro-Arté',
  (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'E4',
  1,
  .0275*25.4,
  'light tension',
  'clear nylon',
  .00002024*453.592292/2.54,
  25.5*25.4,
  16.6*453.592292/1000,
  14.8*453.592292/1000,
  4.2*453.592292/1000 ,
  'Pro-Arté Classical Guitar J4301 - E-1st - 0.0275" (.699mm) Light Tension-Clear Nylon - 2F052'
);

-- J4302,.00002729,22.4,20.0,15.8,12.6,11.2,8.9,7.1,5.6
INSERT INTO strings(
  manufacturer_id,
  part_id,
  string_family,
  instrument_id,
  string_note,
  string_order,
  string_diameter,
  string_tension_category,
  string_material,
  mass_per_length,  
  scale_length,
  tension_maximum,
  tension_at_note,
  tension_minimum,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4302',
  'Pro-Arté',
  (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'B3',
  2,
  .0317*25.4,
  'light tension',
  'clear nylon',
  .00002729*453.592292/2.54,
  25.5*25.4,
  22.4*453.592292/1000,
  11.2*453.592292/1000,
  5.6*453.592292/1000,
  'Pro-Arté Classical Guitar J4302 - B-2nd - 0.0317" (.806mm) Light Tension-Clear Nylon - 1K021'
);

-- J4303,.00004525,37.1,33.1,26.3,20.8,18.6,14.7,11.7,9.3
INSERT INTO strings(
  manufacturer_id,
  part_id,
  string_family,
  instrument_id,
  string_note,
  string_order,
  string_diameter,
  string_tension_category,
  string_material,
  mass_per_length,  
  scale_length,
  tension_maximum,
  tension_at_note,
  tension_minimum,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4303',
  'Pro-Arté',
  (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'G3',
  3,
  .0397*25.4,
  'light tension',
  'clear nylon',
  .00004525*453.592292/2.54,
  25.5*25.4,
  37.1*453.592292/1000,
  11.7*453.592292/1000,
  9.3*453.592292/1000,
  'Pro-Arté Classical Guitar J4303 - G-3rd - 0.0397" (1.010mm) Light Tension-Clear Nylon'
);

-- J4401/EXP,.00002243,18.4,16.4,13.0,10.3,9.2,7.3,5.8,4.6
INSERT INTO strings(
  manufacturer_id,
  part_id,
  string_family,
  instrument_id,
  string_note,
  string_order,
  string_diameter,
  string_tension_category,
  string_material,
  mass_per_length,  
  scale_length,
  tension_maximum,
  tension_at_note,
  tension_minimum,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4401',
  'Pro-Arté',
  (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'E4',
  1,
  .029*25.4,
  'extra hard tension',
  'clear nylon',
  .00002243*453.592292/2.54,
  25.5*25.4,
  18.4*453.592292/1000,
  16.4*453.592292/1000,
  4.6*453.592292/1000,
  'Pro-Arté Classical Guitar J4401 - E-1st - 0.029" (.737mm) Extra Hard Tension-Clear Nylon - 2E 222'
);

-- J4402/EXP,.00003046,25.0,22.3,17.7,14.0,12.5,9.9,7.9,6.3
INSERT INTO strings(
  manufacturer_id,
  part_id,
  string_family,
  instrument_id,
  string_note,
  string_order,
  string_diameter,
  string_tension_category,
  string_material,
  mass_per_length,  
  scale_length,
  tension_maximum,
  tension_at_note,
  tension_minimum,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4402',
  'Pro-Arté',
  (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'B3',
  2,
  .033*25.4,
  'extra hard tension',
  'clear nylon',
  .00003046*453.592292/2.54,
  25.5*25.4,
  22.3*453.592292/1000,
  12.5*453.592292/1000,
  6.3*453.592292/1000,
  'Pro-Arté Classical Guitar J4401 - E-1st - 0.029" (.737mm) Extra Hard Tension-Clear Nylon - 2E222'
);

-- J4403/EXP,.00004989,40.9,36.5,29.0,23.0,20.5,16.3,12.9,10.2
INSERT INTO strings(
  manufacturer_id,
  part_id,
  string_family,
  instrument_id,
  string_note,
  string_order,
  string_diameter,
  string_tension_category,
  string_material,
  mass_per_length,  
  scale_length,
  tension_maximum,
  tension_at_note,
  tension_minimum,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4403',
  'Pro-Arté',
  (SELECT instrument_id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'G3',
  3,
  .0416*25.4,
  'extra hard tension',
  'clear nylon',
  .00004989*453.592292/2.54,
  25.5*25.4,
  40.9*453.592292/1000,
  12.9*453.592292/1000,
  10.2*453.592292/1000,
  'Pro-Arté Classical Guitar J4403 - G-3rd - 0.0416" (1.057mm) Extra Hard Tension-Clear Nylon - 2C282'
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

-- 9806.65 = gravity in mm/s**2
-- 980.665 = gravity in cm/s2
SELECT music.frequency_from_mass_per_length( 
	tension         => (SELECT tension_at_note FROM strings where id=1)*1000*980.665, 
	mass_per_length => (SELECT mass_per_length FROM strings where id=1),
	scale_length    => (SELECT scale_length FROM strings where id=1)/10
);

DROP VIEW IF EXISTS view_strings;
CREATE VIEW view_strings AS 
  SELECT 
    music.frequency_from_mass_per_length(tension_maximum*1000*980.665,mass_per_length,scale_length/10) AS frequency_maximum,
    music.frequency_from_mass_per_length(tension_at_note*1000*980.665,mass_per_length,scale_length/10) AS frequency_at_note,
    music.frequency_from_mass_per_length(tension_minimum*1000*980.665,mass_per_length,scale_length/10) AS frequency_minimum,
	*
  FROM strings;

CREATE TABLE music.chromatic_scale (
  note TEXT NOT NULL UNIQUE,
  semitones_from_A4 NUMERIC NOT NULL UNIQUE,
  UNIQUE(note,semitones_from_A4),
  description TEXT,
  comment TEXT
);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('C',-9);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('C#',-8);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('D',-7);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('D#',-6);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('E',-5);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('F',-4);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('F#',-3);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('G',-2);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('G#',-1);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('A',0);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('A#',1);
INSERT INTO music.chromatic_scale (note,semitones_from_A4) VALUES ('B',2);

DROP FUNCTION IF EXISTS music.octave_difference(TEXT, TEXT);
CREATE FUNCTION music.octave_difference(
  n1 TEXT,
  n2 TEXT DEFAULT 'A4'
) RETURNS numeric
  AS '(SELECT ((SELECT octave_number FROM music.international_pitch_notations WHERE notation="n1") - (SELECT octave_number FROM music.international_pitch_notations WHERE notation="n2")));'
  LANGUAGE SQL
  IMMUTABLE
  RETURNS NULL ON NULL INPUT;

-- return the number of intervals away from A4 which is needed to determine the frequency
SELECT (
	(SELECT music.octave_difference('G3'))*12 + 
	(SELECT semitones_from_A4 from music.chromatic_scale where note=(( SELECT note from music.international_pitch_notations where notation='G3' ) ))
); 

SELECT music.frequency_by_interval(
	n=>(
		SELECT (
			(SELECT music.octave_difference('A0'))*12 + 
			(SELECT semitones_from_A4 from music.chromatic_scale where note=(( SELECT note from music.international_pitch_notations where notation='A0' ) ))
		)
	)
);

DROP FUNCTION IF EXISTS music.frequency_by_notation(TEXT, TEXT, NUMERIC);
CREATE FUNCTION music.frequency_by_notation(
	n TEXT,
	n0 TEXT DEFAULT 'A4',
	f0 NUMERIC DEFAULT 440.0
) RETURNS numeric
	AS 'SELECT (
			SELECT music.frequency_by_interval(
				n=>(
					SELECT (
						(SELECT music.octave_difference("n","n0"))*12 + 
						(SELECT semitones_from_A4 from music.chromatic_scale where note=(( SELECT note from music.international_pitch_notations where notation="n" ) ))
					)
				),
				f0=>f0
			)
		);'
	LANGUAGE SQL
	IMMUTABLE
	RETURNS NULL ON NULL INPUT;

SELECT music.frequency_by_notation(n=>'E4', n0=>'A4', f0=>440.0 );
SELECT music.frequency_by_notation(n=>'E4');
SELECT music.frequency_by_notation('D2');

DROP VIEW IF EXISTS music.view_frequency_by_notation;
CREATE VIEW music.view_frequency_by_notation AS 
  SELECT 
	  id,
	  notation,
	  note,
	  octave_number,
	  music.frequency_by_notation(n=>notation, n0=>'A4', f0=>440.0) AS frequency_A4_440
  FROM music.international_pitch_notations;

select * from music.view_frequency_by_notation;

-- CREATE TABLE manufacturer_string_families (
--   id SERIAL PRIMARY KEY,
--   manufacturer_id BIGINT NOT NULL, FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id),
--   string_family TEXT NOT NULL,
--   UNIQUE(manufacturer_id,string_family),
--   description TEXT,
--   comment TEXT
-- );
-- INSERT INTO manufacturer_string_families (manufacturer_id,string_family) VALUES ( 
--   (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
--   'Pro-Arté' 
-- );

-- -- attributes
-- CREATE TABLE attributes (
--   attribute_id SERIAL PRIMARY KEY,
--   attribute_name TEXT NOT NULL UNIQUE,
--   comment TEXT
-- );

-- CREATE TABLE string_attributes (
--   string_id BIGINT NOT NULL,
--   attribute_name TEXT NOT NULL,
--   PRIMARY KEY (string_id, attribute_name),
--   FOREIGN KEY (string_id) REFERENCES strings (string_id),
--   FOREIGN KEY (attribute_name) REFERENCES attributes (attribute_name),
--   comment TEXT
-- );

DROP FUNCTION IF EXISTS music.string_frequency(numeric, numeric, numeric, numeric, numeric);
CREATE FUNCTION music.string_frequency(
  scale_length NUMERIC,
  density NUMERIC,
  diameter NUMERIC,
  tension NUMERIC,
  n NUMERIC DEFAULT 1
) RETURNS numeric
  AS 'SELECT ((n/(scale_length*diameter))*sqrt(tension/(PI()*density)));'
  LANGUAGE SQL
  IMMUTABLE
  RETURNS NULL ON NULL INPUT;
SELECT music.string_frequency(scale_length=>25.625*2.54,density=>7.726,diameter=>0.00899*2.54,tension=>13.1*453.59237*980.655);