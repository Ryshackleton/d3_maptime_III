#!/usr/bin/env bash

mapshaper -i '../census_tract_shapefiles/tracts10_shore.shp' \
    -proj crs=wgs84 \
    -simplify 0.1 keep-shapes \
    -filter-fields 'TRACT_FLT' \
    -join '../IHME_location_id_TO_tract_id.csv' keys=TRACT_FLT,tract_id \
    -rename-layers census_tracts \
    -o format=topojson force '../expected_outputfile/king_county_census_tracts.json'
