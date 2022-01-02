-- manufacturers
CREATE TABLE manufacturer_types (
  manufacturer_type_id SERIAL PRIMARY KEY,
  manufacturer_type TEXT NOT NULL UNIQUE,
  comment TEXT
);

CREATE TABLE manufacturers (
  manufacturer_id SERIAL PRIMARY KEY,
  manufacturer_name TEXT NOT NULL,
  manufacturer_type TEXT NOT NULL, FOREIGN KEY (manufacturer_type) REFERENCES manufacturer_types (manufacturer_type),
  UNIQUE(manufacturer_name,manufacturer_type),
  comment TEXT
);

CREATE TABLE units (
  unit_id SERIAL PRIMARY KEY,
  unit TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  comment TEXT
);

--- instruments
-- TODO: there are stringed instruments that are not plucked! violin etc. so perhaps stringed should be plucked-string ?
CREATE TABLE instrument_types (
  type_id SERIAL PRIMARY KEY,
  type TEXT NOT NULL UNIQUE,
  actuator_type TEXT NOT NULL,
  comment TEXT,
  UNIQUE(type, actuator_type)
);

CREATE TABLE instrument_categories (
  nstrument_category_id SERIAL PRIMARY KEY,
  instrument_category TEXT NOT NULL UNIQUE,
  comment TEXT
);

CREATE TABLE instruments (
  instrument_id SERIAL PRIMARY KEY,
  type TEXT NOT NULL, FOREIGN KEY (type) REFERENCES instrument_types (type),
  name TEXT NOT NULL,
  category TEXT NOT NULL, FOREIGN KEY (category) REFERENCES instrument_categories (instrument_category),
  UNIQUE(type,name,category),
  description TEXT,
  comment TEXT
);

CREATE TABLE instrument_attributes (
  id SERIAL PRIMARY KEY,
  instrument_attribute TEXT NOT NULL UNIQUE,
  instrument_attribute_type TEXT NOT NULL,
  description TEXT,
  comment TEXT  
);

CREATE TABLE instrument_characteristics (
  id SERIAL PRIMARY KEY,
  instrument_id BIGINT NOT NULL, FOREIGN KEY (instrument_id) REFERENCES instruments (instrument_id),
  instrument_characteristic TEXT NOT NULL, FOREIGN KEY (instrument_characteristic) REFERENCES instrument_attributes (instrument_attribute),
  instrument_characteristic_value TEXT NOT NULL,
  UNIQUE(instrument_id,instrument_characteristic,instrument_characteristic_value),
  description TEXT,
  comment TEXT
);

-- music
-- CREATE music schema
CREATE SCHEMA IF NOT EXISTS music AUTHORIZATION postgres;
SET search_path TO public,music;

CREATE TABLE music.octaves (
  id SERIAL PRIMARY KEY,
  octave_number INT NOT NULL UNIQUE,
  octave_name TEXT NOT NULL UNIQUE,
  midi_number INT NOT NULL UNIQUE,
  UNIQUE(octave_number,octave_name,midi_number)
);

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

CREATE TABLE music.international_pitch_notations (
  id SERIAL PRIMARY KEY,
  notation TEXT NOT NULL UNIQUE,
  note TEXT NOT NULL, FOREIGN KEY (note) REFERENCES music.notes(note),
  octave_number INT NOT NULL, FOREIGN KEY (octave_number) REFERENCES music.octaves(octave_number),
  frequency NUMERIC, 
  description TEXT,
  comment TEXT
);

CREATE TABLE materials (
  id SERIAL PRIMARY KEY,
  material_name TEXT NOT NULL UNIQUE,
  description TEXT,
  comment TEXT
);

CREATE TABLE string_tension_categories (
  id SERIAL PRIMARY KEY,
  category TEXT NOT NULL UNIQUE,
  description TEXT,
  comment TEXT
);

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

CREATE TABLE music.chromatic_scale (
  note TEXT NOT NULL UNIQUE,
  semitones_from_A4 NUMERIC NOT NULL UNIQUE,
  UNIQUE(note,semitones_from_A4),
  description TEXT,
  comment TEXT
);

-- CREATE FUNCTIONS
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

DROP FUNCTION IF EXISTS music.octave_difference(TEXT, TEXT);
CREATE FUNCTION music.octave_difference(
  n1 TEXT,
  n2 TEXT DEFAULT 'A4'
) RETURNS numeric
  AS '(SELECT ((SELECT octave_number FROM music.international_pitch_notations WHERE notation="n1") - (SELECT octave_number FROM music.international_pitch_notations WHERE notation="n2")));'
  LANGUAGE SQL
  IMMUTABLE
  RETURNS NULL ON NULL INPUT;

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

-- CREATE Views
DROP VIEW IF EXISTS view_strings;
CREATE VIEW view_strings AS 
  SELECT 
    music.frequency_from_mass_per_length(tension_maximum*1000*980.665,mass_per_length,scale_length/10) AS frequency_maximum,
    music.frequency_from_mass_per_length(tension_at_note*1000*980.665,mass_per_length,scale_length/10) AS frequency_at_note,
    music.frequency_from_mass_per_length(tension_minimum*1000*980.665,mass_per_length,scale_length/10) AS frequency_minimum,
	*
  FROM strings;

DROP VIEW IF EXISTS music.view_frequency_by_notation;
CREATE VIEW music.view_frequency_by_notation AS 
  SELECT 
	  id,
	  notation,
	  note,
	  octave_number,
	  music.frequency_by_notation(n=>notation, n0=>'A4', f0=>440.0) AS frequency_A4_440
  FROM music.international_pitch_notations;
