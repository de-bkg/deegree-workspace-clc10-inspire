
-- Script for updating identifiers. This will generate gml:identifier and inspireId colums.

DROP FUNCTION IF EXISTS add_inspire_id_cols(regclass, text) CASCADE;
CREATE FUNCTION add_inspire_id_cols(t regclass, gml_prefix text) RETURNS void AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_attribute WHERE attrelid = t AND attname = 'gml_identifier' AND NOT attisdropped) THEN
      EXECUTE 'ALTER TABLE '|| t ||' ADD COLUMN gml_identifier text;';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_attribute WHERE attrelid = t AND attname = 'inspire_id' AND NOT attisdropped) THEN
      EXECUTE 'ALTER TABLE '|| t ||' ADD COLUMN inspire_id text;';
    END IF;
   
   EXECUTE 'UPDATE '|| t ||' SET 
      gml_identifier = ''https://registry.gdi-de.org/id/de.bund.bkg.inspire.clc10/' || gml_prefix ||''' || localid,
      inspire_id = ''' || gml_prefix ||''' || localid';
END;
$$ LANGUAGE PLPGSQL;


SELECT add_inspire_id_cols('lcv.landcoverdataset', 'LandCoverDataset_');
SELECT add_inspire_id_cols('lcv.landcoverunit', 'LandCoverUnit_');
        
