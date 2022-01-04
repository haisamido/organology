
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
INSERT INTO public.materials (material_name) VALUES ('laser select black nylon');
INSERT INTO public.materials (material_name) VALUES ('bronze wound');
INSERT INTO public.materials (material_name) VALUES ('flat silverplated copper wound');

INSERT INTO public.string_tension_categories (category) VALUES ('light tension');
INSERT INTO public.string_tension_categories (category) VALUES ('medium tension' );
INSERT INTO public.string_tension_categories (category) VALUES ('moderate tension' );
INSERT INTO public.string_tension_categories (category) VALUES ('normal tension' );
INSERT INTO public.string_tension_categories (category) VALUES ('hard tension' );
INSERT INTO public.string_tension_categories (category) VALUES ('extra hard tension');

INSERT INTO public.string_classifications (classification) VALUES('treble');
INSERT INTO public.string_classifications (classification) VALUES('bass');

INSERT INTO public.string_sets (manufacturer_id, string_set_name, number_of_strings ) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='D''Addario' AND manufacturer_type='strings'),
  'EXL-120',
  6);
