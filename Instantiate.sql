|
CREATE DATABASE BOM1;
|
USE BOM1;
|
CREATE PROCEDURE instantiate_metal_blue()
BEGIN
CREATE TABLE metal_blue(
part_id int AUTO_INCREMENT,
part_name varchar(30),
parent varchar(30),
PRIMARY KEY(part_id)
);
INSERT INTO metal_blue(part_name,parent) VALUES('Top Barrel Assembled', NULL), ('Rest Of Pen Assembled', NULL), ('Blue Box Assembled',NULL),
('Metal Top Barrel', 'Top Barrel Assembled'), ('Metal Blue Clip', 'Top Barrel Assembled'), ('Bottom Barrel Assembled', 'Rest of Pen Assembled'), ('Cartridge Assembled', 'Rest of Pen Assembled'), 
('Metal Bottom Barrel', 'Bottom Barrel Assembled'), ('Blue Grip', 'Bottom Barrel Assembled'), ('Metal Thruster','Rest of Pen Assembled'),
('Cam','Rest of Pen Assembled'),('Spring','Rest of Pen Assembled'), ('Cartridge Body','Cartridge Assembled'),('Cartridge Cap','Cartridge Assembled'),
('Cartridge Tip','Cartridge Assembled'),('Blue Ink','Cartridge Assembled'), ('Blue Box Top','Blue Box Assembled'),('Blue Box Bottom','Blue Box Assembled'),('Box Insert','Blue Box Assembled');
END;
|
CREATE PROCEDURE instantiate_metal_red()
BEGIN
CREATE TABLE metal_red(
part_id int AUTO_INCREMENT,
part_name varchar(30),
parent varchar(30),
PRIMARY KEY(part_id)
);
INSERT INTO metal_red(part_name,parent) VALUES('Top Barrel Assembled', NULL), ('Rest Of Pen Assembled', NULL), ('Red Box Assembled',NULL),
('Metal Top Barrel', 'Top Barrel Assembled'), ('Metal Red Clip', 'Top Barrel Assembled'), ('Bottom Barrel Assembled', 'Rest of Pen Assembled'), ('Cartridge Assembled', 'Rest of Pen Assembled'), 
('Metal Bottom Barrel', 'Bottom Barrel Assembled'), ('Red Grip', 'Bottom Barrel Assembled'), ('Metal Thruster','Rest of Pen Assembled'),
('Cam','Rest of Pen Assembled'),('Spring','Rest of Pen Assembled'), ('Cartridge Body','Cartridge Assembled'),('Cartridge Cap','Cartridge Assembled'),
('Cartridge Tip','Cartridge Assembled'),('Red Ink','Cartridge Assembled'), ('Red Box Top','Red Box Assembled'),('Red Box Bottom','Red Box Assembled'),('Box Insert','Red Box Assembled');
END;
|
CREATE PROCEDURE instantiate_plastic_red()
BEGIN
CREATE TABLE plastic_red(
part_id int AUTO_INCREMENT,
part_name varchar(30),
parent varchar(30),
PRIMARY KEY(part_id)
);
INSERT INTO plastic_red(part_name,parent) VALUES('Top Barrel Assembled', NULL), ('Rest Of Pen Assembled', NULL), ('Red Box Assembled',NULL),
('Plastic Top Barrel', 'Top Barrel Assembled'), ('Plastic Red Clip', 'Top Barrel Assembled'), ('Bottom Barrel Assembled', 'Rest of Pen Assembled'), ('Cartridge Assembled', 'Rest of Pen Assembled'), 
('Plastic Bottom Barrel', 'Bottom Barrel Assembled'), ('Red Grip', 'Bottom Barrel Assembled'), ('Plastic Thruster','Rest of Pen Assembled'),
('Cam','Rest of Pen Assembled'),('Spring','Rest of Pen Assembled'), ('Cartridge Body','Cartridge Assembled'),('Cartridge Cap','Cartridge Assembled'),
('Cartridge Tip','Cartridge Assembled'),('Red Ink','Cartridge Assembled'), ('Red Box Top','Red Box Assembled'),('Red Box Bottom','Red Box Assembled'),('Box Insert','Red Box Assembled');
END;
|
CREATE PROCEDURE instantiate_plastic_blue()
BEGIN
CREATE TABLE plastic_blue(
part_id int AUTO_INCREMENT,
part_name varchar(30),
parent varchar(30),
PRIMARY KEY(part_id)
);
INSERT INTO plastic_blue(part_name,parent) VALUES('Top Barrel Assembled', NULL), ('Rest Of Pen Assembled', NULL), ('Blue Box Assembled',NULL),
('Plastic Top Barrel', 'Top Barrel Assembled'), ('Plastic Blue Clip', 'Top Barrel Assembled'), ('Bottom Barrel Assembled', 'Rest of Pen Assembled'), ('Cartridge Assembled', 'Rest of Pen Assembled'), 
('Plastic Bottom Barrel', 'Bottom Barrel Assembled'), ('Blue Grip', 'Bottom Barrel Assembled'), ('Plastic Thruster','Rest of Pen Assembled'),
('Cam','Rest of Pen Assembled'),('Spring','Rest of Pen Assembled'), ('Cartridge Body','Cartridge Assembled'),('Cartridge Cap','Cartridge Assembled'),
('Cartridge Tip','Cartridge Assembled'),('Blue Ink','Cartridge Assembled'), ('Blue Box Top','Blue Box Assembled'),('Blue Box Bottom','Blue Box Assembled'),('Box Insert','Blue Box Assembled');
END;
|
call instantiate_plastic_blue();
|
call instantiate_metal_blue();
|
call instantiate_plastic_red();
|
call instantiate_metal_red();
|