|
USE BOM1;
|
CALL delete_part('Cartridge Cap','Metal Red');
CALL component_parts('Plastic Blue');
CALL insert_child_parent('Cartridge Body','Body Assembled','Metal Red');
CALL insert_new_part('Red Ink','Metal Red');
CALL list_all_assemblies('Plastic Blue');
CALL list_all_assemblies_specific_child('Blue Grip','Metal Blue');
CALL orphan_parts('Plastic Red');
CALL parts_in_specific_assembly('Rest of Pen Assembled','Metal Red');
CALL remove_from_assembly('Red Ink','Plastic Red');
CALL sub_assemblies('Metal Blue');
CALL top_level_assemblies('Plastic Red');
CALL list_all_parts('Plastic Blue');
CALL all_first_children('Rest of Pen Assembled','Plastic Red');


