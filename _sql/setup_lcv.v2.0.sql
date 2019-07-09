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
    gml_identifier text,                  -- = 'https://registry.gdi-de.org/id/de.bund.bkg.inspire.clc10/LandCoverDataset_' || localid
    inspire_id text,                      -- = 'LandCoverDataset_' || localid
    beginlifespanversion timestamp,
    beginlifespanversion_nilreason text,  -- if nil: 'other:unpopulated'
    beginlifespanversion_nil boolean,
    endlifespanversion timestamp,
    endlifespanversion_nilreason text,    -- if nil: 'other:unpopulated'
    endlifespanversion_nil boolean,
    name text,
    nomenclature_fk text,
    validfrom date,
    validfrom_nilreason text,             -- if nil: 'other:unpopulated'
    validfrom_nil boolean,
    validto date,
    validto_nilreason text,               -- if nil: 'other:unpopulated'
    validto_nil boolean,
    CONSTRAINT landcoverdataset_pkey PRIMARY KEY (localid)
);
ALTER TABLE lcv.landcoverdataset OWNER TO inspire;

CREATE TABLE lcv.landcoverdataset_member (
    id serial PRIMARY KEY,
    parentfk text NOT NULL REFERENCES lcv.landcoverdataset ON DELETE CASCADE,
    nilreason text,                     -- obsolet?
    landcoverunit_fk text,
    href text                           -- = '#LandCoverUnit_' || landcoverunit_fk
);
ALTER TABLE lcv.landcoverdataset_member OWNER TO inspire;

CREATE INDEX landcoverdataset_member_parentfk_idx ON lcv.landcoverdataset_member (parentfk ASC NULLS LAST);

-- == lcv:LandCoverUnit ==
CREATE TABLE lcv.landcoverunit (
    localid text,
    gml_identifier text,                  -- = 'https://registry.gdi-de.org/id/de.bund.bkg.inspire.clc10/LandCoverUnit_' || localid
    inspire_id text,                      -- = 'LandCoverUnit_' || localid
    beginlifespanversion timestamp,
    beginlifespanversion_nilreason text,  -- if nil: 'other:unpopulated'
    beginlifespanversion_nil boolean,
    endlifespanversion timestamp,
    endlifespanversion_nilreason text,    -- if nil: 'other:unpopulated'
    endlifespanversion_nil boolean,
    geometry(GEOMETRY, 4258),
    class_nilreason text,                 -- if nil: 'other:unpopulated'
    class_href text,                      -- 'http://dd.eionet.europa.eu/vocabulary/landcover/clc/${class}'
    observationdate timestamp,
    observationdate_nilreason text,       -- if nil: 'other:unpopulated'
    observationdate_nil boolean,    
    mosaic_nilreason text,                -- if nil: 'other:unpopulated'
    mosaic_nil boolean,
    mosaic_landcovervalue_class_nilreason text,  -- if nil: 'other:unpopulated'
    mosaic_landcovervalue_class_href text,       -- = 'http://dd.eionet.europa.eu/vocabulary/landcover/clc/${class}'
    mosaic_landcovervalue_coveredpercentage integer,
    mosaic_landcovervalue_coveredpercentage_nilreason text,  -- if nil: 'other:unpopulated'
    mosaic_landcovervalue_coveredpercentage_nil boolean
    CONSTRAINT landcoverunit_pkey PRIMARY KEY (localid)
);
ALTER TABLE lcv.landcoverunit OWNER TO inspire;

CREATE INDEX landcoverunit_geometry_idx ON lcv.landcoverunit USING GIST (geometry);
CREATE INDEX landcoverunit_gml_identifier_idx ON lcv.landcoverunit (gml_identifier);
CREATE INDEX landcoverunit_inspire_id_idx ON lcv.landcoverunit (inspire_id);
CREATE INDEX landcoverunit_class_href_idx ON lcv.landcoverunit (class_href);


