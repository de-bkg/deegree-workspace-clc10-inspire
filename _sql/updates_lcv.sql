-- Constraints und Indizes
ALTER TABLE lcv.landcoverdataset_member ADD CONSTRAINT landcoverdataset_member_landcoverunit_fk FOREIGN KEY (landcoverunit_fk) REFERENCES lcv.landcoverunit (localid) ON UPDATE NO ACTION ON DELETE NO ACTION;

CREATE INDEX lcv_landcoverunit_area_idx ON lcv.landcoverunit (ST_Area(geometry));

-- Datenkorrekturen

UPDATE lcv.landcoverunit_landcoverobservation SET class_href = 'http://dd.eionet.europa.eu/vocabulary/landcover/clc/' || class_href ;

UPDATE lcv.landcoverdataset SET beginlifespanversion_nilreason = 'other:unpopulated' WHERE beginlifespanversion_nilreason = 'Unpopulated';
UPDATE lcv.landcoverdataset SET endlifespanversion_nilreason = 'other:unpopulated' WHERE endlifespanversion_nilreason = 'Unpopulated';
UPDATE lcv.landcoverdataset SET validfrom_nilreason = 'other:unpopulated' WHERE validfrom_nilreason = 'Unpopulated';
UPDATE lcv.landcoverdataset SET validto_nilreason = 'other:unpopulated' WHERE validto_nilreason = 'Unpopulated';
UPDATE lcv.landcoverunit SET endlifespanversion_nilreason = 'other:unpopulated' WHERE endlifespanversion_nilreason = 'Unpopulated';
UPDATE lcv.landcoverunit SET beginlifespanversion_nilreason = 'other:unpopulated' WHERE beginlifespanversion_nilreason = 'Unpopulated';
UPDATE lcv.landcoverunit_landcoverobservation SET observationdate_nilreason = 'other:unpopulated' WHERE observationdate_nilreason = 'Unpopulated';
UPDATE lcv.landcoverunit_landcoverobservation_mosaic SET nilreason = 'other:unpopulated' WHERE nilreason = 'Unpopulated';
UPDATE lcv.landcoverunit_landcoverobservation_mosaic SET landcovervalue_coveredpercentage_nilreason = 'other:unpopulated' WHERE landcovervalue_coveredpercentage_nilreason = 'unpopulated';

