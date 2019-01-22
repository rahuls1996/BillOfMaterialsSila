|
USE bonusdb;
|
CREATE PROCEDURE initialize_nested()
BEGIN
CREATE TABLE nested_pen_bom(
part_id int AUTO_INCREMENT,
part_name varchar(30),
lft int,
rgr int,
PRIMARY KEY(part_id)
);
INSERT INTO nested_pen_bom(part_name, lft, rgr) VALUES ('Pen Assembly',1,32), ('Top Barrel Assembled',2,7),('Top Barrel',3,4),('Clip',5,6),
('Rest of Pen Assembled',8,31),('Cartridge Assembled',9,18),('Cartridge Cap',10,11),('Cartridge Body',12,13), ('Cartridge Tip',14,15), ('Ink',16,17),
('Bottom Barrel Assembled',19,24),('Bottom Barrel',20,21),('Rubber Grip',22,23),('Thruster',25,26),('Spring',27,28),('Cam',29,30);
END;
|
CREATE PROCEDURE component_parts()
BEGIN
/*component parts*/
SELECT part_name
FROM nested_pen_bom
WHERE rgr = lft + 1;
END;
|
/*parent assemblies of given part*/
|
CREATE PROCEDURE parent_assemblies_of_given_child1(IN input varchar(30))
BEGIN
SELECT parent.part_name
FROM nested_pen_bom AS child, nested_pen_bom AS parent
WHERE child.lft BETWEEN parent.lft AND parent.rgr AND child.part_name = input AND parent.part_name != input
ORDER BY parent.lft;
END;
|
