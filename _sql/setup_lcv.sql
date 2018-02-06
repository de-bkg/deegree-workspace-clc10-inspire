-- Schema: lcv (landcover)

-- DROP SCHEMA lcv;

CREATE SCHEMA lcv AUTHORIZATION inspire;

COMMENT ON SCHEMA lcv IS 'INSPIRE Schemata für Landcover';

-- == lcn:LandCoverNomenclature ==
CREATE TABLE lcv.nomenclature_responsible (
    id text,
    individual text, 
    individual_nilreason text, 
    organisation text, 
    organisation_nilreason text, 
    position text, 
    position_nilreason text, 
    role text, 
    role_nilreason text, 
    CONSTRAINT nomenclature_responsible_pkey PRIMARY KEY (id)
);
ALTER TABLE lcv.nomenclature_responsible OWNER TO inspire;

CREATE TABLE lcv.nomenclature (
    id text,
    codelist text,
    responsible_fk text REFERENCES lcv.nomenclature_responsible,  -- NOT NULL  ON DELETE CASCADE,
    CONSTRAINT nomenclature_pkey PRIMARY KEY (id)
);
ALTER TABLE lcv.nomenclature OWNER TO inspire;

-- == lcv:LandCoverDataset ==
CREATE TABLE lcv.landcoverdataset (
    localid text,
    beginlifespanversion timestamp,
    beginlifespanversion_nilreason text,
    beginlifespanversion_nil boolean,
    endlifespanversion timestamp,
    endlifespanversion_nilreason text,
    endlifespanversion_nil boolean,
    name text,
    nomenclature_fk text,
    validfrom date,
    validfrom_nilreason text,
    validfrom_nil boolean,
    validto date,
    validto_nilreason text,
    validto_nil boolean,
    CONSTRAINT landcoverdataset_pkey PRIMARY KEY (localid)
);
ALTER TABLE lcv.landcoverdataset OWNER TO inspire;

CREATE TABLE lcv.landcoverdataset_member (
    id serial PRIMARY KEY,
    parentfk text NOT NULL REFERENCES lcv.landcoverdataset ON DELETE CASCADE,
    nilreason text,
    landcoverunit_fk text,
    href text
);
ALTER TABLE lcv.landcoverdataset_member OWNER TO inspire;

-- == lcv:LandCoverUnit ==
CREATE TABLE lcv.landcoverunit (
    localid text,
    beginlifespanversion timestamp,
    beginlifespanversion_nilreason text,
    beginlifespanversion_nil boolean,
    endlifespanversion timestamp,
    endlifespanversion_nilreason text,
    endlifespanversion_nil boolean,
    CONSTRAINT landcoverunit_pkey PRIMARY KEY (localid)
);
ALTER TABLE lcv.landcoverunit OWNER TO inspire;

SELECT ADDGEOMETRYCOLUMN('lcv', 'landcoverunit','geometry','4258','GEOMETRY', 2);
CREATE INDEX landcoverunit_geometry_idx ON lcv.landcoverunit USING GIST (geometry);

CREATE TABLE lcv.landcoverunit_landcoverobservation (
    id serial PRIMARY KEY,
    parentfk text NOT NULL REFERENCES lcv.landcoverunit ON DELETE CASCADE,
    class_nilreason text,
    class_href text,
    observationdate timestamp,
    observationdate_nilreason text,
    observationdate_nil boolean
);
ALTER TABLE lcv.landcoverunit_landcoverobservation OWNER TO inspire;

CREATE TABLE lcv.landcoverunit_landcoverobservation_mosaic (
    id serial PRIMARY KEY,
    parentfk integer NOT NULL REFERENCES lcv.landcoverunit_landcoverobservation ON DELETE CASCADE,
    nilreason text,
    nil boolean,
    landcovervalue_class_nilreason text,
    landcovervalue_class_href text,
    landcovervalue_coveredpercentage integer,
    landcovervalue_coveredpercentage_nilreason text,
    landcovervalue_coveredpercentage_nil boolean
);
ALTER TABLE lcv.landcoverunit_landcoverobservation_mosaic OWNER TO inspire;

-- additional indizes
CREATE INDEX landcoverdataset_member_parentfk_idx ON lcv.landcoverdataset_member (parentfk ASC NULLS LAST);

CREATE INDEX landcoverunit_landcoverobservation_parentfk_idx ON lcv.landcoverunit_landcoverobservation (parentfk ASC NULLS LAST);
CREATE INDEX landcoverunit_landcoverobservation_mosaic_parentfk_idx ON lcv.landcoverunit_landcoverobservation_mosaic (parentfk ASC NULLS LAST);

