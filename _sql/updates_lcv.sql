-- Constraints und Indizes
ALTER TABLE lcv.landcoverdataset_member ADD CONSTRAINT landcoverdataset_member_landcoverunit_fk FOREIGN KEY (landcoverunit_fk) REFERENCES lcv.landcoverunit (localid) ON UPDATE NO ACTION ON DELETE NO ACTION;

CREATE INDEX lcv_landcoverunit_area_idx ON lcv.landcoverunit (ST_Area(geometry));

-- Datenkorrekturen

UPDATE lcv.landcoverunit_landcoverobservation SET class_href = 'http://dd.eionet.europa.eu/vocabulary/landcover/clc/' || class_href ;

-- predefine lcv:member URLs for better performance
ALTER TABLE lcv.landcoverdataset_member ADD COLUMN href_fixed text;
UPDATE lcv.landcoverdataset_member SET href = '#' || href, href_fixed = 'http://lsvpostcat0:8080/inspire/services/wfs_clc10?SERVICE=WFS&VERSION=2.0.0&REQUEST=GetFeature&STOREDQUERY_ID=urn:ogc:def:query:OGC-WFS::GetFeatureById&ID=' || regexp_replace( href, '^#', '');

UPDATE lcv.landcoverdataset_member SET href_fixed = href, href = replace( href, 'http://lsvpostcat0:8080/inspire/services/wfs_clc10?SERVICE=WFS&VERSION=2.0.0&REQUEST=GetFeature&STOREDQUERY_ID=urn:ogc:def:query:OGC-WFS::GetFeatureById&ID=', '#');
