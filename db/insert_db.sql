INSERT INTO manufacturers(manufacturer_name) VALUES ('D''Addario');

INSERT INTO strings(string_name, string_density, string_thickness) VALUES ('E4',7.726,0.00899*2.54);

INSERT INTO string_sets( string_id, string_order, string_set_name, manufacturer_id ) VALUES (1,1,'EXL-120',1);

SELECT 
	manufacturers.manufacturer_name,
	string_sets.string_set_name,
	strings.string_name,
	string_sets.string_order
from 
	string_sets,
	strings,
	manufacturers
where 
strings.string_id in (select strings.string_id from strings) and 
manufacturers.manufacturer_id in (select manufacturers.manufacturer_id from manufacturers where manufacturer_name='D''Addario')

-- https://www.daddario.com/products/guitar/electric-guitar/xl-nickel/exl120-nickel-wound-super-light-09-42/
-- http://www.phys.unsw.edu.au/music/guitar/
-- http://www.phys.unsw.edu.au/music/note/