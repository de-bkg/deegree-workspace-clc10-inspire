-- join for performance
DROP TABLE IF EXISTS lcv.landcoverunit_view_lod;
CREATE TABLE lcv.landcoverunit_view_lod AS  
  SELECT 
    u.localid, 
    u.geometry,
    ST_CollectionExtract(ST_Simplify(u.geometry,0.001), 3) AS geom_lod1, 
    ST_CollectionExtract(ST_Simplify(u.geometry,0.0025), 3) AS geom_lod2, 
    ST_CollectionExtract(ST_Simplify(u.geometry,0.005), 3) AS geom_lod3, 
    ST_CollectionExtract(ST_Simplify(u.geometry,0.01), 3) AS geom_lod4, 
    ST_CollectionExtract(ST_Simplify(u.geometry,0.015), 3) AS geom_lod5, 
    ST_CollectionExtract(ST_Simplify(u.geometry,0.02), 3) AS geom_lod6, 
    u.beginlifespanversion, u.beginlifespanversion_nilreason, u.beginlifespanversion_nil, 
    u.endlifespanversion, u.endlifespanversion_nilreason, u.endlifespanversion_nil,
    c.class_nilreason, c.class_href, c.observationdate, c.observationdate_nilreason, c.observationdate_nil 
  FROM 
    lcv.landcoverunit u
    LEFT JOIN lcv.landcoverunit_landcoverobservation c ON u.localid = c.parentfk;
ALTER TABLE lcv.landcoverunit_view_lod OWNER TO inspire;

UPDATE lcv.landcoverunit_view_lod SET geom_lod1 = ST_MakeValid(geom_lod1) WHERE NOT ST_isValid(geom_lod1);
UPDATE lcv.landcoverunit_view_lod SET geom_lod2 = ST_MakeValid(geom_lod2) WHERE NOT ST_isValid(geom_lod2);
UPDATE lcv.landcoverunit_view_lod SET geom_lod3 = ST_MakeValid(geom_lod3) WHERE NOT ST_isValid(geom_lod3);
UPDATE lcv.landcoverunit_view_lod SET geom_lod4 = ST_MakeValid(geom_lod4) WHERE NOT ST_isValid(geom_lod4);
UPDATE lcv.landcoverunit_view_lod SET geom_lod5 = ST_MakeValid(geom_lod5) WHERE NOT ST_isValid(geom_lod5);
UPDATE lcv.landcoverunit_view_lod SET geom_lod6 = ST_MakeValid(geom_lod6) WHERE NOT ST_isValid(geom_lod6);

CREATE INDEX landcoverunit_view_geom_lod1_geometry_idx ON lcv.landcoverunit_view_lod USING gist (geom_lod1);
CREATE INDEX landcoverunit_view_geom_lod2_geometry_idx ON lcv.landcoverunit_view_lod USING gist (geom_lod2);
CREATE INDEX landcoverunit_view_geom_lod3_geometry_idx ON lcv.landcoverunit_view_lod USING gist (geom_lod3);
CREATE INDEX landcoverunit_view_geom_lod4_geometry_idx ON lcv.landcoverunit_view_lod USING gist (geom_lod4);
CREATE INDEX landcoverunit_view_geom_lod5_geometry_idx ON lcv.landcoverunit_view_lod USING gist (geom_lod5);
CREATE INDEX landcoverunit_view_geom_lod6_geometry_idx ON lcv.landcoverunit_view_lod USING gist (geom_lod6);

-- TODO: union features? preserve small geometries for gaps?

-- table for simplified feature set for scales smaller than 1:2.000.000
-- for that scale pixel size is 0.0050316559106932 deegree per pixel
DROP TABLE IF EXISTS lcv.landcoverunit_view_2000k;
CREATE TABLE lcv.landcoverunit_view_2000k (
    id serial PRIMARY KEY,
    beginlifespanversion timestamp,
    beginlifespanversion_nilreason text DEFAULT 'other:unpopulated',
    beginlifespanversion_nil boolean DEFAULT TRUE,
    endlifespanversion timestamp,
    endlifespanversion_nilreason text DEFAULT 'other:unpopulated',
    endlifespanversion_nil boolean DEFAULT TRUE,
    class_nilreason text,
    class_href text,
    observationdate timestamp,
    observationdate_nilreason text DEFAULT 'other:unpopulated',
    observationdate_nil boolean DEFAULT TRUE
);
ALTER TABLE lcv.landcoverunit_view_2000k OWNER TO inspire;

SELECT ADDGEOMETRYCOLUMN('lcv', 'landcoverunit_view_2000k','geometry','4258','GEOMETRY', 2);
CREATE INDEX landcoverunit_view_2000k_geometry_idx ON lcv.landcoverunit_view_2000k USING GIST (geometry);
CREATE INDEX landcoverunit_view_2000k_area_idx ON lcv.landcoverunit_view_2000k (ST_Area(geometry));


-- 1:10h
INSERT INTO lcv.landcoverunit_view_2000k (class_href, geometry)
  SELECT 
     class_href,
    (ST_Dump(ST_Union(ST_Buffer(geometry, 0.0025158279553466)))).geom 
  FROM lcv.landcoverunit_view_lod
  GROUP BY class_href;
-- 1:12h
UPDATE lcv.landcoverunit_view_2000k SET geometry = ST_Buffer(geometry, -0.0025158279553466);
UPDATE lcv.landcoverunit_view_2000k SET geometry = ST_CollectionExtract(ST_Simplify(geometry, 0.005),3);
  
  
-- table for simplified feature set for scales smaller than 1:100.000
-- for that scale pixel size is 0.0000251528279553466
DROP TABLE IF EXISTS lcv.landcoverunit_view_100k;
CREATE TABLE lcv.landcoverunit_view_100k (
    id serial PRIMARY KEY,
    beginlifespanversion timestamp,
    beginlifespanversion_nilreason text DEFAULT 'other:unpopulated',
    beginlifespanversion_nil boolean DEFAULT TRUE,
    endlifespanversion timestamp,
    endlifespanversion_nilreason text DEFAULT 'other:unpopulated',
    endlifespanversion_nil boolean DEFAULT TRUE,
    class_nilreason text,
    class_href text,
    observationdate timestamp,
    observationdate_nilreason text DEFAULT 'other:unpopulated',
    observationdate_nil boolean DEFAULT TRUE
);
ALTER TABLE lcv.landcoverunit_view_100k OWNER TO inspire;

SELECT ADDGEOMETRYCOLUMN('lcv', 'landcoverunit_view_100k','geometry','4258','GEOMETRY', 2);
CREATE INDEX landcoverunit_view_100k_geometry_idx ON lcv.landcoverunit_view_100k USING GIST (geometry);
CREATE INDEX landcoverunit_view_100k_area_idx ON lcv.landcoverunit_view_100k (ST_Area(geometry));
-- 1:19
INSERT INTO lcv.landcoverunit_view_100k (class_href, geometry)
  SELECT 
     class_href,
     ST_CollectionExtract(ST_Simplify(ST_Buffer((ST_Dump(ST_Union(ST_Buffer(geometry, 0.0000125)))).geom, -0.0000125), 0.000025),3) 
  FROM lcv.landcoverunit_view_lod
  GROUP BY class_href;