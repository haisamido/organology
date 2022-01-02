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

