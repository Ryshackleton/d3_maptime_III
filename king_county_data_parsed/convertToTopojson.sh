#!/usr/bin/env bash

mapshaper -i './tracts10_shore.shp' \
    -proj match=tracts10_shore \
    -filter-fields 'TRACT_FLT' \
    -join './IHME_location_id_TO_tract_id.csv' keys=TRACT_FLT,tract_id \
    -simplify 0.1 keep-shapes \
    -rename-layers 'census_tracts' \
    -o format=topojson force king_county_census_tracts.json

