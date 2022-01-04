
INSERT INTO public.manufacturer_types (manufacturer_type) VALUES ('strings');
INSERT INTO public.manufacturer_types (manufacturer_type) VALUES ('musical instruments');

INSERT INTO public.manufacturers(manufacturer_name,manufacturer_type) VALUES ('Aquila','strings');
INSERT INTO public.manufacturers(manufacturer_name,manufacturer_type) VALUES ('D''Addario','strings');
INSERT INTO public.manufacturers(manufacturer_name,manufacturer_type) VALUES ('Elixer','strings');
INSERT INTO public.manufacturers(manufacturer_name,manufacturer_type) VALUES ('Ernie Ball','strings');
INSERT INTO public.manufacturers(manufacturer_name,manufacturer_type) VALUES ('La Bella','strings');
INSERT INTO public.manufacturers(manufacturer_name,manufacturer_type) VALUES ('Martin & Co.','strings');
INSERT INTO public.manufacturers(manufacturer_name,manufacturer_type) VALUES ('Pyramid','strings');
INSERT INTO public.manufacturers(manufacturer_name,manufacturer_type) VALUES ('Savarez','strings');
INSERT INTO public.manufacturers(manufacturer_name,manufacturer_type) VALUES ('Taylor','musical instruments');
INSERT INTO public.manufacturers(manufacturer_name,manufacturer_type) VALUES ('Doff','musical instruments');

INSERT INTO public.units (unit,description,comment) VALUES ( 'lb/in', 'pound mass per inch','is is mu, needs to be converted to g/cm');
INSERT INTO public.units (unit,description,comment) VALUES ( 'lb', 'pound mass','needs to be converted to g or kg');
INSERT INTO public.units (unit,description,comment) VALUES ( 'lbf', 'pound force','needs to be converted to Newtons');

INSERT INTO public.instrument_types (type,actuator_type) VALUES ( 'brass', 'button' );
INSERT INTO public.instrument_types (type,actuator_type) VALUES ( 'keyboard', 'key' );
INSERT INTO public.instrument_types (type,actuator_type) VALUES ( 'percussion', 'stick' );
INSERT INTO public.instrument_types (type,actuator_type) VALUES ( 'stringed', 'pluck' );
INSERT INTO public.instrument_types (type,actuator_type) VALUES ( 'woodwind', 'breath' );

INSERT INTO public.instrument_categories (instrument_category) VALUES ( 'acoustic' );
INSERT INTO public.instrument_categories (instrument_category) VALUES ( 'classical' );
INSERT INTO public.instrument_categories (instrument_category) VALUES ( 'solid-body' );

INSERT INTO public.instruments (type,name,category) VALUES ('stringed','guitar','classical');

INSERT INTO public.instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('number_of_actuators', 'INT');
INSERT INTO public.instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('ethnic_association','TEXT');
INSERT INTO public.instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('electric','BOOLEAN');
INSERT INTO public.instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('multi_scale','BOOLEAN');
INSERT INTO public.instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('adjustable_scale_length','BOOLEAN');
INSERT INTO public.instrument_attributes (instrument_attribute,instrument_attribute_type) VALUES ('adjustable_scale_length_type','TEXT');

INSERT INTO public.instrument_characteristics (instrument_id,instrument_characteristic,instrument_characteristic_value) VALUES (
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'number_of_actuators',
  6
);
INSERT INTO public.instrument_characteristics (instrument_id,instrument_characteristic,instrument_characteristic_value) VALUES (
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'number_of_actuators',
  7
);
INSERT INTO public.instrument_characteristics (instrument_id,instrument_characteristic,instrument_characteristic_value) VALUES (
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'number_of_actuators',
  8
);
INSERT INTO public.instrument_characteristics (instrument_id,instrument_characteristic,instrument_characteristic_value) VALUES (
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'number_of_actuators',
  9
);
INSERT INTO public.instrument_characteristics (instrument_id,instrument_characteristic,instrument_characteristic_value) VALUES (
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
  'number_of_actuators',
  12
);
INSERT INTO public.materials (material_name) VALUES ('clear nylon');
INSERT INTO public.materials (material_name) VALUES ('black nylon');
INSERT INTO public.materials (material_name) VALUES ('rectified clear nylon');
INSERT INTO public.materials (material_name) VALUES ('titanium nylon');
INSERT INTO public.materials (material_name) VALUES ('silverplated wound');
INSERT INTO public.materials (material_name) VALUES ('laser select clear nylon');

INSERT INTO public.string_tension_categories (category) VALUES ('light tension');
INSERT INTO public.string_tension_categories (category) VALUES ('medium tension' );
INSERT INTO public.string_tension_categories (category) VALUES ('moderate tension' );
INSERT INTO public.string_tension_categories (category) VALUES ('normal tension' );
INSERT INTO public.string_tension_categories (category) VALUES ('hard tension' );
INSERT INTO public.string_tension_categories (category) VALUES ('extra hard tension');

INSERT INTO public.string_classifications (classification) VALUES('treble');
INSERT INTO public.string_classifications (classification) VALUES('bass');

-- J4301,.00002024,16.6,14.8,11.8,9.3,8.3,6.6,5.2,4.2
INSERT INTO public.strings(
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
  string_classification,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4301',
  'Pro-Arté',
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
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
  'treble',
  'Pro-Arté Classical Guitar J4301 - E-1st - 0.0275" (.699mm) Light Tension-Clear Nylon - 2F052'
);

-- J4302,.00002729,22.4,20.0,15.8,12.6,11.2,8.9,7.1,5.6
INSERT INTO public.strings(
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
  string_classification,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4302',
  'Pro-Arté',
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
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
  'treble',
  'Pro-Arté Classical Guitar J4302 - B-2nd - 0.0317" (.806mm) Light Tension-Clear Nylon - 1K021'
);

-- J4303,.00004525,37.1,33.1,26.3,20.8,18.6,14.7,11.7,9.3
INSERT INTO public.strings(
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
  string_classification,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4303',
  'Pro-Arté',
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
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
  'treble',
  'Pro-Arté Classical Guitar J4303 - G-3rd - 0.0397" (1.010mm) Light Tension-Clear Nylon'
);

-- J4401/EXP,.00002243,18.4,16.4,13.0,10.3,9.2,7.3,5.8,4.6
INSERT INTO public.strings(
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
  string_classification,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4401',
  'Pro-Arté',
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
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
  'treble',
  'Pro-Arté Classical Guitar J4401 - E-1st - 0.029" (.737mm) Extra Hard Tension-Clear Nylon - 2E 222'
);

-- J4402/EXP,.00003046,25.0,22.3,17.7,14.0,12.5,9.9,7.9,6.3
INSERT INTO public.strings(
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
  string_classification,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4402',
  'Pro-Arté',
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
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
  'treble',
  'Pro-Arté Classical Guitar J4401 - E-1st - 0.029" (.737mm) Extra Hard Tension-Clear Nylon - 2E222'
);

-- J4403/EXP,.00004989,40.9,36.5,29.0,23.0,20.5,16.3,12.9,10.2
INSERT INTO public.strings(
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
  string_classification,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'J4403',
  'Pro-Arté',
  (SELECT id FROM instruments WHERE type='stringed' AND name='guitar' AND category='classical'),
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
  'treble',
  'Pro-Arté Classical Guitar J4403 - G-3rd - 0.0416" (1.057mm) Extra Hard Tension-Clear Nylon - 2C282'
);

INSERT INTO public.string_sets (manufacturer_id, string_set_name, number_of_strings ) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'EXL-120',
  6);
