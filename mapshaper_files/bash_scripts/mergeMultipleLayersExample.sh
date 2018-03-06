#!/usr/bin/env bash

mapshaper -i '../census_tract_shapefiles/tracts10_shore.shp' \
    -dissolve \
    -simplify 0.1 keep-shapes \
    -proj crs=wgs84 \
    -o format=geojson force outer_boundary.geojson

mapshaper -i '../census_tract_shapefiles/tracts10_shore.shp' \
    -proj crs=wgs84 \
    -filter-fields 'TRACT_FLT' \
    -join '../IHME_location_id_TO_tract_id.csv' keys=TRACT_FLT,tract_id \
    -simplify 0.1 keep-shapes \
    -o format=geojson force census_tracts.geojson

mapshaper -i census_tracts.geojson outer_boundary.geojson combine-files encoding=utf8 \
    -o format=topojson force '../expected_outputfile/king_county_census_tracts.json'

rm outer_boundary.geojson census_tracts.geojson
