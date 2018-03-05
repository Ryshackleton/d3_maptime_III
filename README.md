
### Data Wrangling

### Data Sources
[King County GIS data portal](https://www5.kingcounty.gov/gisdataportal/)

[Institute for Health Metrics and Evaluation - Global Health Data Exchange](http://ghdx.healthdata.org/record/united-states-king-county-washington-life-expectancy-and-cause-specific-mortality-census)

### Shapefile to TopoJSON

### Challenge 1: Use Mapshaper to figure out what attributes we have

#### [Mapshaper.org](http://mapshaper.org/) has an amazing web-based tool for reshaping map data, as well as a command line tool.

1. Go to [Mapshaper.org](http://mapshaper.org/)

1. Drag your shape files into the mapshaper import window (tracts10_shore.shp and tracts10_shore.dbf)

1. Notice that you can zoom, pan etc.  Click on the 'i' button on the top right.  Now you can mouse over your shapefile and see the attributes per census tract.

Notice that there are a bunch of extra data fields (GEO_ID_TRT, FEATURE_ID, etc) we don't really want.  We could either delete these using QGIS, or we could figure out how to let mapshaper do it for us.

### Challenge 2: Remove those extra data fields!

#### That extra data is nice, but all we need are the census tract numbers, which we'll use to join to IHME's `location_id` field.  Let's delete all fields EXCEPT the `TRACT_FLT` field, which represents the tract id as a decimal value

1. Click the "Console" button.  You'll get a prompt to type "tips" for examples.  Try it!
2. Try typing "help" or "help <command name>" to find commands.  You can also try the [Mapshaper command reference](https://github.com/mbloch/mapshaper/wiki/Command-Reference) for a web interface.
3. Figure out which command you need to remove ALL except the `TRACT_FLT` field.

### Challenge 2 Answer:

<details>
 <summary><strong>Challenge 2 Answer</strong></summary>
 <p>
  
 1. Type ```filter-fields 'TRACT_FLT'``` into the Mapshaper console.
 2. Now use the info button and mouse over each tract to be sure that only the `TRACT_FLT` field is still there.
 
 </p>
</details>

<details>
 <summary><strong>Challenge 3 Answer</strong></summary>
 <p>
```
join IHME_location_id_TO_tract_id.csv keys=TRACT_FLT,tract_id
```
</p>
</details>

<details>
 <summary><strong>How to build your own bash script to do this:</strong></summary>

* Download and install [Node.js](https://nodejs.org/en/)**
* Install mapshaper globally on your computer (-g flag)
```
npm install -g mapshaper
```
**you may see it recommended to install Node via Hombrew or other package manager, but I wouldn't.  Installing a package manager with another package manager isn't always the best idea.

* Start the command with ```mapshaper -i <filename>```
* Each additional command can be added as a ```-<command name> <arguments>```, so our Challenge 2 example would be:
```
mapshaper -i './tracts10_shore.shp' \
    -filter-fields 'TRACT_FLT' \
```
* And tell it what format, and what to output with ```-o format=topojson force king_county_census_transects.json```.  Notice that I have to add a `\` to escape the carriage return
</p>
</details>

