|
USE BOM1;
|
/*All procedures contain 4 copies of the same code - one for each pen type*/
CREATE PROCEDURE all_first_children(IN assembly_name varchar(30), IN pen_type varchar(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
IF EXISTS (SELECT parent from plastic_blue where parent = assembly_name)
THEN
SELECT part_name from plastic_blue where parent = assembly_name;
ELSE 
SELECT 'Not an Assembly';
END IF;
ELSEIF pen_type = 'Plastic Red'
THEN
IF EXISTS (SELECT parent from plastic_red where parent = assembly_name)
THEN
SELECT part_name from plastic_red where parent = assembly_name;
ELSE 
SELECT 'Not an Assembly';
END IF;
ELSEIF pen_type = 'Metal Blue'
THEN
IF EXISTS (SELECT parent from metal_blue where parent = assembly_name)
THEN
SELECT part_name from metal_blue where parent = assembly_name;
ELSE 
SELECT 'Not an Assembly';
END IF;
ELSE
IF EXISTS (SELECT parent from metal_red where parent = assembly_name)
THEN
SELECT part_name from metal_red where parent = assembly_name;
ELSE 
SELECT 'Not an Assembly';
END IF;
END IF;
END


|

CREATE PROCEDURE component_parts(IN pen_type VARCHAR(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
SELECT t1.part_name FROM
plastic_blue AS t1 LEFT JOIN plastic_blue as t2
ON t1.part_name = t2.parent
WHERE t2.part_name IS NULL and t1.parent is not null;
ELSEIF pen_type = 'Plastic Red'
THEN
SELECT t1.part_name FROM
plastic_red AS t1 LEFT JOIN plastic_red as t2
ON t1.part_name = t2.parent
WHERE t2.part_name IS NULL and t1.parent is not null;
ELSEIF pen_type = 'Metal Red'
THEN 
SELECT t1.part_name FROM
metal_red AS t1 LEFT JOIN metal_red as t2
ON t1.part_name = t2.parent
WHERE t2.part_name IS NULL and t1.parent is not null;
ELSE 
SELECT t1.part_name FROM
metal_blue AS t1 LEFT JOIN metal_blue as t2
ON t1.part_name = t2.parent
WHERE t2.part_name IS NULL and t1.parent is not null;
END IF;
END


|

CREATE PROCEDURE delete_part(IN p_name varchar(30), IN pen_type varchar(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
IF EXISTS (SELECT part_name from plastic_blue where part_name = p_name)
THEN
/* only delete a part if it already exists*/
IF EXISTS (SELECT parent from plastic_blue where parent = p_name)
/*checking if part exists as a parent*/
THEN

CREATE TEMPORARY TABLE temp AS (SELECT * from plastic_blue);
CREATE TEMPORARY TABLE temp2 AS (SELECT * from plastic_blue);
/*assign deleted part's parent to it's children*/
UPDATE plastic_blue set parent = (SELECT parent from temp where part_name = p_name)
WHERE part_name IN (SELECT part_name from temp2 WHERE parent = p_name);
DELETE from plastic_blue where part_name = p_name; 
DROP TABLE temp;
DROP TABLE temp2;
SELECT * FROM plastic_blue;
ELSE
DELETE from plastic_blue where part_name = p_name;
SELECT * FROM plastic_blue;
END IF;
ELSE 
SELECT 'Not a part';
END IF;
ELSEIF pen_type = 'Plastic Red'
THEN
IF EXISTS (SELECT part_name from plastic_red where part_name = p_name)
THEN

IF EXISTS (SELECT parent from plastic_red where parent = p_name)
THEN

CREATE TEMPORARY TABLE temp AS (SELECT * from plastic_red);
CREATE TEMPORARY TABLE temp2 AS (SELECT * from plastic_red);
UPDATE plastic_red set parent = (SELECT parent from temp where part_name = p_name)
WHERE part_name IN (SELECT part_name from temp2 WHERE parent = p_name);
DELETE from plastic_red where part_name = p_name; 
DROP TABLE temp;
DROP TABLE temp2;
ELSE
DELETE from plastic_red where part_name = p_name;
END IF;
ELSE 
SELECT 'Not a part';
END IF;
SELECT * from plastic_red;
ELSEIF pen_type = 'Metal Blue'
THEN
IF EXISTS (SELECT part_name from metal_blue where part_name = p_name)
THEN

IF EXISTS (SELECT parent from metal_blue where parent = p_name)
THEN

CREATE TEMPORARY TABLE temp AS (SELECT * from metal_blue);
CREATE TEMPORARY TABLE temp2 AS (SELECT * from metal_blue);
UPDATE metal_blue set parent = (SELECT parent from temp where part_name = p_name)
WHERE part_name IN (SELECT part_name from temp2 WHERE parent = p_name);
DELETE from metal_blue where part_name = p_name; 
DROP TABLE temp;
DROP TABLE temp2;
ELSE
DELETE from metal_blue where part_name = p_name;
END IF;
ELSE 
SELECT 'Not a part';
END IF;
SELECT * from metal_blue;
ELSE 
IF EXISTS (SELECT part_name from metal_red where part_name = p_name)
THEN

IF EXISTS (SELECT parent from metal_red where parent = p_name)
THEN

CREATE TEMPORARY TABLE temp AS (SELECT * from metal_red);
CREATE TEMPORARY TABLE temp2 AS (SELECT * from metal_red);
UPDATE metal_red set parent = (SELECT parent from temp where part_name = p_name)
WHERE part_name IN (SELECT part_name from temp2 WHERE parent = p_name);
DELETE from metal_red where part_name = p_name; 
DROP TABLE temp;
DROP TABLE temp2;
ELSE
DELETE from metal_red where part_name = p_name;
END IF;
ELSE 
SELECT 'Not a part';
END IF;
SELECT * from metal_red;
END IF;
END;

|

CREATE PROCEDURE insert_child_parent(IN child_name varchar(30), IN parent_assembly_name varchar(30),IN pen_type VARCHAR(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
IF NOT EXISTS (SELECT part_name from plastic_blue where parent = parent_assembly_name AND part_name = child_name)
THEN
/* Check if parent child relationship already exists*/
IF EXISTS (SELECT part_name from plastic_blue where part_name = child_name) AND NOT EXISTS 
(SELECT parent from plastic_blue where parent = parent_assembly_name)
THEN
/* Check if child exists in the table already, and parent does not. If parent does not, then assign child's original parent as new parent's parent*/
SET @par = (SELECT parent from plastic_blue where part_name = child_name);
INSERT INTO plastic_blue(part_name, parent) VALUES(parent_assembly_name, @par);
UPDATE plastic_blue SET parent = parent_assembly_name WHERE part_name = child_name;
ELSEIF EXISTS (SELECT part_name from plastic_blue where part_name = child_name) AND EXISTS 
(SELECT parent from plastic_blue where parent = parent_assembly_name)
/* if both exist simply update*/
THEN
UPDATE plastic_blue SET parent = parent_assembly_name WHERE part_name = child_name;
ELSEIF NOT EXISTS (SELECT part_name from plastic_blue where part_name = child_name) AND EXISTS 
(SELECT parent from plastic_blue where parent = parent_assembly_name)
THEN
/*If child does not exist, simply insert*/
INSERT INTO plastic_blue(part_name, parent) VALUES (child_name, parent_assembly_name);
ELSE
/*if neither exist, insert and make parent top level assembly*/
INSERT INTO plastic_blue(part_name, parent) VALUES (child_name, parent_assembly_name);
INSERT INTO plastic_blue(part_name,parent) VALUES (parent_assembly_name,NULL);
END IF;
SELECT * from plastic_blue;
ELSE
SELECT 'Already exists';
END IF;
ELSEIF pen_type = 'Plastic Red'
THEN
IF NOT EXISTS (SELECT part_name from plastic_red where parent = parent_assembly_name AND part_name = child_name)
THEN
IF EXISTS (SELECT part_name from plastic_red where part_name = child_name) AND NOT EXISTS 
(SELECT parent from plastic_red where parent = parent_assembly_name)
THEN
SET @par = (SELECT parent from plastic_red where part_name = child_name);
INSERT INTO plastic_red(part_name, parent) VALUES(parent_assembly_name, @par);
UPDATE plastic_red SET parent = parent_assembly_name WHERE part_name = child_name;
ELSEIF EXISTS (SELECT part_name from plastic_red where part_name = child_name) AND EXISTS 
(SELECT parent from plastic_red where parent = parent_assembly_name)
THEN
UPDATE plastic_red SET parent = parent_assembly_name WHERE part_name = child_name;
ELSEIF NOT EXISTS (SELECT part_name from plastic_red where part_name = child_name) AND EXISTS 
(SELECT parent from plastic_red where parent = parent_assembly_name)
THEN
INSERT INTO plastic_red(part_name, parent) VALUES (child_name, parent_assembly_name);
ELSE
INSERT INTO plastic_red(part_name, parent) VALUES (child_name, parent_assembly_name);
INSERT INTO plastic_red(part_name,parent) VALUES (parent_assembly_name,NULL);
END IF;
SELECT * from plastic_red;
ELSE
SELECT 'Already exists';
END IF;
ELSEIF pen_type = 'Metal Blue'
THEN
IF NOT EXISTS (SELECT part_name from metal_blue where parent = parent_assembly_name AND part_name = child_name)
THEN
IF EXISTS (SELECT part_name from metal_blue where part_name = child_name) AND NOT EXISTS 
(SELECT parent from metal_blue where parent = parent_assembly_name)
THEN
SET @par = (SELECT parent from metal_blue where part_name = child_name);
INSERT INTO metal_blue(part_name, parent) VALUES(parent_assembly_name, @par);
UPDATE metal_blue SET parent = parent_assembly_name WHERE part_name = child_name;
ELSEIF EXISTS (SELECT part_name from metal_blue where part_name = child_name) AND EXISTS 
(SELECT parent from metal_blue where parent = parent_assembly_name)
THEN
UPDATE metal_blue SET parent = parent_assembly_name WHERE part_name = child_name;
ELSEIF NOT EXISTS (SELECT part_name from metal_blue where part_name = child_name) AND EXISTS 
(SELECT parent from metal_blue where parent = parent_assembly_name)
THEN 
INSERT INTO metal_blue(part_name, parent) VALUES (child_name, parent_assembly_name);
ELSE
INSERT INTO metal_blue(part_name, parent) VALUES (child_name, parent_assembly_name);
INSERT INTO metal_blue(part_name,parent) VALUES (parent_assembly_name,NULL);
END IF;
SELECT * from metal_blue;
ELSE
SELECT 'Already exists';
END IF;
ELSE
IF NOT EXISTS (SELECT part_name from metal_red where parent = parent_assembly_name AND part_name = child_name)
THEN
IF EXISTS (SELECT part_name from metal_red where part_name = child_name) AND NOT EXISTS 
(SELECT parent from metal_red where parent = parent_assembly_name)
THEN
SET @par = (SELECT parent from metal_red where part_name = child_name);
INSERT INTO metal_red(part_name, parent) VALUES(parent_assembly_name, @par);
UPDATE metal_red SET parent = parent_assembly_name WHERE part_name = child_name;
ELSEIF EXISTS (SELECT part_name from metal_red where part_name = child_name) AND EXISTS 
(SELECT parent from metal_red where parent = parent_assembly_name)
THEN
UPDATE metal_red SET parent = parent_assembly_name WHERE part_name = child_name;
ELSEIF NOT EXISTS (SELECT part_name from metal_red where part_name = child_name) AND EXISTS (SELECT parent from metal_red where parent = parent_assembly_name)
THEN 
INSERT INTO metal_red(part_name, parent) VALUES (child_name, parent_assembly_name);
ELSE
INSERT INTO metal_red(part_name, parent) VALUES (child_name, parent_assembly_name);
INSERT INTO metal_red(part_name,parent) VALUES (parent_assembly_name,NULL);
END IF;
SELECT * from metal_red;
ELSE
SELECT 'Already exists';
END IF;
END IF;
END;
|


CREATE PROCEDURE insert_new_part(IN new_part_name varchar(30),IN pen_type VARCHAR(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
IF NOT EXISTS (select part_name from plastic_blue where part_name = new_part_name)
THEN
INSERT INTO plastic_blue(part_name, parent) VALUES (new_part_name, NULL);
SELECT * from plastic_blue;
ELSE 
SELECT 'Part already exists';
END IF;
ELSEIF pen_type = 'Plastic Red'
THEN
IF NOT EXISTS (select part_name from plastic_red where part_name = new_part_name)
THEN
INSERT INTO plastic_red(part_name, parent) VALUES (new_part_name, NULL);
SELECT * from plastic_red;
ELSE
select 'Part already exists';
END IF;
ELSEIF pen_type = 'Metal Blue'
THEN
IF NOT EXISTS (select part_name from metal_blue where part_name = new_part_name)
THEN
INSERT INTO metal_blue(part_name, parent) VALUES (new_part_name, NULL);
SELECT * from metal_blue;
ELSE 
SELECT 'Part already exists';
END if;
ELSE
IF NOT EXISTS (select part_name from metal_red where part_name = new_part_name)
THEN
INSERT INTO metal_red(part_name, parent) VALUES (new_part_name, NULL);
SELECT * from metal_red;
ELSE
SELECT 'Part already exists';
END IF;
END IF;
END;
|


CREATE PROCEDURE list_all_assemblies(IN pen_type varchar(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
SELECT DISTINCT parent as Assemblies from plastic_blue where parent is not null;
ELSEIF pen_type = 'Plastic Red'
THEN
SELECT DISTINCT parent as Assemblies from plastic_red where parent is not null;
ELSEIF pen_type = 'Metal Blue'
THEN
SELECT DISTINCT parent as Assemblies from metal_blue where parent is not null;
ELSE
SELECT DISTINCT parent as Assemblies from metal_red where parent is not null;
END IF;
END;
|

CREATE PROCEDURE list_all_assemblies_specific_child(IN child_name varchar(30), IN pen_type varchar(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
IF EXISTS (Select part_name from plastic_blue Where part_name = child_name)
THEN 
CREATE TEMPORARY TABLE temp(
assembly varchar(30)
);
label1: WHILE child_name is not NULL DO
/*traversing up the tree; Made alot easier in the bonus solution!*/
INSERT INTO temp SELECT t1.parent FROM plastic_blue as t1 WHERE t1.part_name = child_name;
SELECT t1.parent FROM plastic_blue as t1 WHERE t1.part_name = child_name into child_name;
END WHILE label1;
SELECT * from temp where assembly is NOT NULL;
DROP TABLE temp;
ELSE 
SELECT 'Not a part';
END IF;

ELSEIF pen_type = 'Plastic Red'
THEN
IF EXISTS (Select part_name from plastic_red Where part_name = child_name)
THEN 
CREATE TEMPORARY TABLE temp(
assembly varchar(30)
);
label1: WHILE child_name is not NULL DO

INSERT INTO temp SELECT t1.parent FROM plastic_red as t1 WHERE t1.part_name = child_name;
SELECT t1.parent FROM plastic_red as t1 WHERE t1.part_name = child_name into child_name;
END WHILE label1;
SELECT * from temp where assembly is NOT NULL;
DROP TABLE temp;
ELSE 
SELECT 'Not a part';
END IF;

ELSEIF pen_type = 'Metal Blue'
THEN
IF EXISTS (Select part_name from metal_blue Where part_name = child_name)
THEN 
CREATE TEMPORARY TABLE temp(
assembly varchar(30)
);
label1: WHILE child_name is not NULL DO

INSERT INTO temp SELECT t1.parent FROM metal_blue as t1 WHERE t1.part_name = child_name;
SELECT t1.parent FROM metal_blue as t1 WHERE t1.part_name = child_name into child_name;
END WHILE label1;
SELECT * from temp where assembly is NOT NULL;
DROP TABLE temp;
ELSE 
SELECT 'Not a part';
END IF;
ELSE 
IF EXISTS (Select part_name from metal_red Where part_name = child_name)
THEN 
CREATE TEMPORARY TABLE temp(
assembly varchar(30)
);
label1: WHILE child_name is not NULL DO

INSERT INTO temp SELECT t1.parent FROM metal_red as t1 WHERE t1.part_name = child_name;
SELECT t1.parent FROM metal_red as t1 WHERE t1.part_name = child_name into child_name;
END WHILE label1;
SELECT * from temp where assembly is NOT NULL;
DROP TABLE temp;
ELSE 
SELECT 'Not a part';
END IF;
END IF;
END;
|

CREATE PROCEDURE list_all_parts(IN pen_type varchar(30))
BEGIN
IF pen_type = 'Plastic Blue' 
THEN
SELECT part_name from plastic_blue;
ELSEIF pen_type = 'Plastic Red'
THEN 
SELECT part_name from plastic_red;
ELSEIF pen_type = 'Metal Red'
THEN 
SELECT part_name from metal_red;
ELSE
SELECT part_name from metal_blue;
END IF;
END
|
CREATE PROCEDURE orphan_parts(IN pen_type VARCHAR(30))
BEGIN
IF pen_type = 'Plastic Blue' 
THEN
SELECT t1.part_name from plastic_blue as t1 where parent is null and NOT EXISTS 
(SELECT parent from plastic_blue where parent = t1.part_name);
ELSEIF pen_type = 'Plastic Red'
THEN
SELECT t1.part_name from plastic_red as t1 where parent is null and NOT EXISTS 
(SELECT parent from plastic_red where parent = t1.part_name);
ELSEIF pen_type = 'Metal Red'
THEN 
SELECT t1.part_name from metal_red as t1 where parent is null and NOT EXISTS 
(SELECT parent from metal_red where parent = t1.part_name);
ELSE 
SELECT t1.part_name from metal_blue as t1 where parent is null and NOT EXISTS 
(SELECT parent from metal_blue where parent = t1.part_name);
END IF;
END

|
CREATE PROCEDURE parts_in_specific_assembly(IN assembly_name varchar(30), IN pen_type varchar(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
IF EXISTS (SELECT parent from plastic_blue where parent = assembly_name) 
THEN
CREATE TEMPORARY TABLE temp(
part varchar(30)
);
SET @prev_count = 0;
insert into temp Select part_name from plastic_blue where parent = assembly_name;
label2: WHILE (SELECT Count(DISTINCT part) from temp where part is not null) != @prev_count DO 
/*counting when the number of distinct entries into the inner join does not increase, signifying the reaching of an end*/
SET @prev_count = (SELECT COUNT(DISTINCT part) from temp where part is not null);
CREATE TEMPORARY TABLE temp2 as (SELECT * from temp where part is not null);
insert into temp SELECT plastic_blue.part_name from temp2 left join plastic_blue on temp2.part = plastic_blue.parent;
DROP table temp2;
END WHILE label2;
select DISTINCT part from temp where part is not null;
DROP TABLE temp;
ELSE
SELECT 'Not an assembly';
END IF;
ELSEIF pen_type = 'Plastic Red'
THEN
IF EXISTS (SELECT parent from plastic_red where parent = assembly_name) 
THEN
CREATE TEMPORARY TABLE temp(
part varchar(30)
);
SET @prev_count = 0;
insert into temp Select part_name from plastic_red where parent = assembly_name;
label2: WHILE (SELECT Count(DISTINCT part) from temp where part is not null) != @prev_count DO
SET @prev_count = (SELECT COUNT(DISTINCT part) from temp where part is not null);
CREATE TEMPORARY TABLE temp2 as (SELECT * from temp where part is not null);
insert into temp SELECT plastic_red.part_name from temp2 left join plastic_red on temp2.part = plastic_red.parent;
DROP table temp2;
END WHILE label2;
select DISTINCT part from temp where part is not null;
DROP TABLE temp;
ELSE
SELECT 'Not an assembly';
END IF;

ELSEIF pen_type = 'Metal Blue'
THEN
IF EXISTS (SELECT parent from metal_blue where parent = assembly_name) 
THEN
CREATE TEMPORARY TABLE temp(
part varchar(30)
);
SET @prev_count = 0;
insert into temp Select part_name from metal_blue where parent = assembly_name;
label2: WHILE (SELECT Count(DISTINCT part) from temp where part is not null) != @prev_count DO
SET @prev_count = (SELECT COUNT(DISTINCT part) from temp where part is not null);
CREATE TEMPORARY TABLE temp2 as (SELECT * from temp where part is not null);
insert into temp SELECT metal_blue.part_name from temp2 left join metal_blue on temp2.part = metal_blue.parent;
DROP table temp2;
END WHILE label2;
select DISTINCT part from temp where part is not null;
DROP TABLE temp;
ELSE
SELECT 'Not an assembly';
END IF;
ELSE
IF EXISTS (SELECT parent from metal_red where parent = assembly_name) 
THEN
CREATE TEMPORARY TABLE temp(
part varchar(30)
);
SET @prev_count = 0;
insert into temp Select part_name from metal_red where parent = assembly_name;
label2: WHILE (SELECT Count(DISTINCT part) from temp where part is not null) != @prev_count DO
SET @prev_count = (SELECT COUNT(DISTINCT part) from temp where part is not null);
CREATE TEMPORARY TABLE temp2 as (SELECT * from temp where part is not null);
insert into temp SELECT metal_red.part_name from temp2 left join metal_red on temp2.part = metal_red.parent;
DROP table temp2;
END WHILE label2;
select DISTINCT part from temp where part is not null;
DROP TABLE temp;
ELSE
SELECT 'Not an assembly';
END IF;
END IF;
END
|

CREATE PROCEDURE remove_from_assembly(IN removed_part_name varchar(30), IN pen_type varchar(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
IF EXISTS (SELECT part_name from plastic_blue WHERE part_name = removed_part_name)
THEN
IF (SELECT parent from plastic_blue where part_name = removed_part_name) is not NULL
THEN
CREATE TEMPORARY TABLE temp SELECT * FROM plastic_blue;
SET @parent = (SELECT parent from plastic_blue WHERE part_name = removed_part_name);
UPDATE plastic_blue SET parent = (SELECT parent from temp where part_name = @parent)
WHERE part_name = removed_part_name;
DROP TABLE temp;
ELSE 
SELECT 'Part is not in an assembly';
END IF;
ELSE
SELECT 'Part does not exist';
END IF;
SELECT * from plastic_blue;
ELSEIF pen_type = 'Plastic Red'
THEN
IF EXISTS (SELECT part_name from plastic_red WHERE part_name = removed_part_name)
THEN
IF (SELECT parent from plastic_red where part_name = removed_part_name) is not NULL
THEN
CREATE TEMPORARY TABLE temp SELECT * FROM plastic_red;
SET @parent = (SELECT parent from plastic_red WHERE part_name = removed_part_name);
UPDATE plastic_red SET parent = (SELECT parent from temp where part_name = @parent)
WHERE part_name = removed_part_name;
DROP TABLE temp;
ELSE 
SELECT 'Part is not in an assembly';
END IF;
ELSE
SELECT 'Part does not exist';
END IF;
SELECT * from plastic_red;
ELSEIF pen_type = 'Metal Blue'
THEN 
IF EXISTS (SELECT part_name from metal_blue WHERE part_name = removed_part_name)
THEN
IF (SELECT parent from metal_blue where part_name = removed_part_name) is not NULL
THEN
CREATE TEMPORARY TABLE temp SELECT * FROM metal_blue;
SET @parent = (SELECT parent from metal_blue WHERE part_name = removed_part_name);
UPDATE metal_blue SET parent = (SELECT parent from temp where part_name = @parent)
WHERE part_name = removed_part_name;
DROP TABLE temp;
ELSE 
SELECT 'Part is not in an assembly';
END IF;
ELSE
SELECT 'Part does not exist';
END IF;
SELECT * from metal_blue;
ELSE
IF EXISTS (SELECT part_name from metal_red WHERE part_name = removed_part_name)
THEN
IF (SELECT parent from metal_red where part_name = removed_part_name) is not NULL
THEN
CREATE TEMPORARY TABLE temp SELECT * FROM metal_red;
SET @parent = (SELECT parent from metal_red WHERE part_name = removed_part_name);
UPDATE metal_red SET parent = (SELECT parent from temp where part_name = @parent)
WHERE part_name = removed_part_name;
DROP TABLE temp;
ELSE 
SELECT 'Part is not in an assembly';
END IF;
ELSE
SELECT 'Part does not exist';
END IF;
SELECT * from metal_red;
END IF;
END;

|
CREATE PROCEDURE sub_assemblies(IN pen_type VARCHAR(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
SELECT DISTINCT t1.part_name FROM
plastic_blue AS t1 LEFT JOIN plastic_blue as t2
ON t1.part_name = t2.parent
WHERE t2.part_name IS NOT NULL AND t1.parent IS NOT NULL;
ELSEIF pen_type = 'Plastic Red'
THEN
SELECT DISTINCT t1.part_name FROM
plastic_red AS t1 LEFT JOIN plastic_red as t2
ON t1.part_name = t2.parent
WHERE t2.part_name IS NOT NULL AND t1.parent IS NOT NULL;
ELSEIF pen_type = 'Metal Red'
THEN
SELECT DISTINCT t1.part_name FROM
metal_red AS t1 LEFT JOIN metal_red as t2
ON t1.part_name = t2.parent
WHERE t2.part_name IS NOT NULL AND t1.parent IS NOT NULL;
ELSE 
SELECT DISTINCT t1.part_name FROM
metal_blue AS t1 LEFT JOIN metal_blue as t2
ON t1.part_name = t2.parent
WHERE t2.part_name IS NOT NULL AND t1.parent IS NOT NULL;
END IF;
END;
|
CREATE PROCEDURE top_level_assemblies(IN pen_type VARCHAR(30))
BEGIN
IF pen_type = 'Plastic Blue'
THEN
SELECT DISTINCT t1.part_name from plastic_blue as t1 INNER JOIN plastic_blue as t2
ON t1.part_name = t2.parent WHERE t1.parent is NULL;
ELSEIF pen_type = 'Plastic Red'
THEN
SELECT DISTINCT t1.part_name from plastic_red as t1 INNER JOIN plastic_red as t2
ON t1.part_name = t2.parent WHERE t1.parent is NULL;
ELSEIF pen_type = 'Metal Blue'
THEN 
SELECT DISTINCT t1.part_name from metal_blue as t1 INNER JOIN metal_blue as t2
ON t1.part_name = t2.parent WHERE t1.parent is NULL;
ELSE 
SELECT DISTINCT t1.part_name from metal_red as t1 INNER JOIN metal_red as t2
ON t1.part_name = t2.parent WHERE t1.parent is NULL;
END IF;
END
|
