---
layout: tut
title: "Mapping with D3.js - v2.0"
---

# Intro
[D3](http://d3js.org/) is a powerful data visualization library written by [Mike Bostock](https://bost.ocks.org/mike/) that helps connect data to graphical elements, and then apply data-driven transformations to those elements. The basic idea is that when the data is bound to graphics, you can produce more portable graphics and much more dynamic visualization with less effort.

So *why use D3 for maps?* Maps are fundamentally graphical objects based on data, and D3 has built in support for map projections and transformations. D3 is actually the backend renderer for SVG images in the [OpenStreetMap editor iD](https://github.com/openstreetmap/iD), so that's a pretty good endorsement for D3 mapping!

So *why not use another library like [Leaflet.js](http://leafletjs.com/)?* The short answer is that D3 will be advantageous when you really want to customize interactivity and dynamic visualization. The tradeoff is in ease-of-creation: D3 will take more time to customize the map to what you want. That said, there's really no reason you can't use both D3 and Leaflet together! Here is a great tutorial [example](https://bost.ocks.org/mike/leaflet/) using D3 to create dynamic overlays on a Leaflet map.

### What can I create with D3?

Check out these links for some examples of D3 visualizations:

[The full gallery of D3 visualizations](https://github.com/d3/d3/wiki/Gallery)

[Geographic Projections: animated](https://bl.ocks.org/mbostock/3711652), and [draggable](https://www.jasondavies.com/maps/transition/)

[The famous "Wealth of Nations" Viz](https://bost.ocks.org/mike/nations/)

[Earthquake Energy Release Visualizations using D3/Leaflet (by Ryan)](https://ryshackleton.github.io/seismic_energy_viz/)

# D3 - Data Driven Documents
D3 stands for **Data Driven Documents**. We will unpack this title in three parts.

## Data
D3 has straightforward functions to grab data from a variety of sources including XMLHttpRequests, text files, JSON blobs, HTML document fragments, XML document fragments, comma-separated values (CSV) files, and tab-separated values (TSV) files. Part of the tremendous power of D3 is that it can take data from a variety of sources, merge different data sources, and then join data elements to the visual elements that represent the data.

## Driven

**Driven** is actually one of the defining characteristics of D3: the graphical elements are defined by the data.  In other words, each circle, line, or polygon also contains the data they are defined by. A desktop GIS software works in the same way while you're working on your map, but when you export the map, the vector-based features lose the data that defines them. If you export a raster image those attributes are completely converted to color values and the data is detached completely.

That type of thing doesn't happen in D3. Not only does your data define the elements in your graphic, the data is also bound (joined) to the elements in your document. A circle isn't just a circle element with an x,y and radius, it's also the data that originated the element in the first place. This characteristic of D3 allows data to drive your visualization, not only upon creation, but throughout its life cycle.

## Documents

At its core, D3 takes your information and transforms it into a visual output. That output is usually a [Scalable Vector Graphic, or SVG](http://www.w3.org/TR/SVG/) that lives in an HTML document. SVG is a file format that encodes vector data for use in a wide array of applications. SVGs are used all over the place to display all kinds of data. If you've ever exported a map from [desktop GIS](http://www.qgis.org/en/site/) and styled it in a [graphics program](https://inkscape.org/en/), chances are your data was stored as SVG at some stage of the process.

SVGs are human readable, which works well for us because we aren't computers. This is an SVG in code:

```HTML
<svg width="400" height="120">
  <circle cx="40" cy="60" r="10"></circle>
  <circle cx="80" cy="60" r="10"></circle>
  <circle cx="120" cy="60" r="10"></circle>
</svg>
```

And this is the rendered version of that code:

<img src="https://bl.ocks.org/mbostock/raw/3019563/">

SVG's work similarly to html pages, where tags represent objects that can have *objects nested within them*: each circle is an element *nested within* the SVG. Each circle contains some coordinates of the object's center (cx, cy), and radius (r), so the SVG is just a set of instructions defining the geometry of each object, where to put each object, and how to style the objects in [the SVG coordinate space](https://bl.ocks.org/mbostock/3019563).

<img src="https://ryshackleton.github.io/d3_maptime_III/images/svg_coordinate_system.svg">

It's also worth noting that D3 has the ability to select, write, and edit any element on the [HTML DOM](https://www.w3schools.com/js/js_htmldom.asp), and [any of the SVG shape elements](https://www.w3schools.com/graphics/svg_examples.asp) like rectangles and lines.  Later we'll learn to use D3 to create [`<path>` elements](https://www.w3schools.com/graphics/svg_path.asp)  to draw complex country boundaries on our map.

# Tutorial Time!

### What do I need for this tutorial?

To successfully follow this tutorial you need a text editor (such as Notepad++, Brackets, or Sublime Text). Go ahead and use your personal favorite, or if you don't have one installed, download [Brackets](http://brackets.io), it's free.

You will also need a local web server.  Here are 2 good options:
1. Here's a [Chrome app](https://chrome.google.com/webstore/detail/web-server-for-chrome/ofhbbkphhbklhfoeikjpcbhemlocgigb/related?hl=en) that's lightweight and works great. Upon opening the app, it will prompt you to choose a folder to serve files from.
2. [MAMP](https://www.mamp.info/en/) is a free apache webserver for MacOS and Windows. (on MacOS, you'll put your files in `/Applications/MAMP/htdocs/`, and usually access your files via http://localhost:8888/)

## What map are we making?
With any luck, today we will produce **[this map](https://bl.ocks.org/Ryshackleton/52c97ff17236c2accccdadc47b122228/71e8c79a711b532565b97a16c83dc222246568d2)**, which displays [a GeoJSON feed of daily earthquakes around the world](https://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php).  We'll do this in steps:


## Tips

* The learning curve can be pretty steep. Stay positive.  Ask lots of questions.
* Start simple, add complexity piece by piece
* Refer to [documentation](https://github.com/d3/d3/blob/master/API.md) / [tutorials](https://github.com/d3/d3/wiki/Tutorials)
* **Cannibalize code** wherever/whenever you can. D3 has [great examples](https://bl.ocks.org/) and most the code is freely accessible.
* In this tutorial, **SOLUTIONS ARE PROVIDED AT THE END OF EVERY STEP** under headings like this:
	### nth Challenge Solution Here
	### Or [clone this git repo](https://github.com/Ryshackleton/d3_maptime.git) to get all of the starter/solution files ahead of time
## Data Wrangling

### Data Sources
[King County GIS data portal](https://www5.kingcounty.gov/gisdataportal/)
[Census Tracts Shapefile](http://www5.kingcounty.gov/sdc/Metadata.aspx?Layer=tracts10_shore)

[King County Neighborhood data](https://gis-kingcounty.opendata.arcgis.com/datasets/metro-neighborhoods-in-king-county--neighborhood-area?geometry=-122.918%2C47.536%2C-121.748%2C47.698)

[Institute for Health Metrics and Evaluation - Global Health Data Exchange](http://ghdx.healthdata.org/record/united-states-king-county-washington-life-expectancy-and-cause-specific-mortality-census)

### Shapefile to TopoJSON

### Challenge 1: Use Mapshaper to figure out what attributes we have

#### [Mapshaper](http://mapshaper.org/) is an amazing command-line tool for reshaping map data, and has an amazing web-based tool to get started. This challenge will show you the basics.

1. Go to [Mapshaper.org](http://mapshaper.org/)

2. Drag your shape files into the mapshaper import window (tracts10_shore.shp and tracts10_shore.dbf)

3. Notice that you can zoom, pan etc.  Click on the 'i' button on the top right.
4. Mouse over your shapefile to get a tooltip that  shows the attributes for each census tract.

<details>
 <summary><strong>Challenge 1 Answer</strong></summary>
 <p>

If you can see the attributes in the tooltip, you succeeded!

 </p>
</details>

Notice that there are a bunch of extra data fields (GEO_ID_TRT, FEATURE_ID, etc) we don't really want.  We could either delete these using QGIS, or we could figure out how to let mapshaper do it for us.

### Challenge 2: Remove those extra data fields!

#### That extra data is nice, but all we need are the census tract numbers, which we'll use to join to IHME's `location_id` field.  Let's delete all fields EXCEPT the `TRACT_FLT` field, which represents the tract id as a decimal value

1. Click the "Console" button.  You'll get a prompt to type "tips" for examples.  Try it!
2. Try typing "help" or "help <command name>" to find commands.  You can also try the [Mapshaper command reference](https://github.com/mbloch/mapshaper/wiki/Command-Reference) for a web interface.
3. Figure out which command you need to remove ALL except the `TRACT_FLT` field.

<details>
 <summary><strong>Challenge 2 Answer</strong></summary>
 <p>
  
 1. Type ```filter-fields 'TRACT_FLT'``` into the Mapshaper console.
 2. Now use the info button and mouse over each tract to be sure that only the `TRACT_FLT` field is still there.
 
 </p>
</details>

### Challenge 3: Join Census Tract Number `TRACT_FLT` to IHME `location_id`

#### IHME data is indexed by IHME's own `location_id`, so ideally our topojson file will need to have `location_id` instead of `TRACT_FLT`.  Let's make that happen in mapshaper.
1. From the repo, open `./king_county_data_parsed/IHME_location_id_TO_tract_id.csv' in a text editor or in Excel
2. 

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

* Add the bash tag
* Start the command with ```mapshaper -i <filename>``` to tell mapshaper which file to open
* Each additional command can be added as a ```-<command name> <arguments>```, so our Challenge 2 example would be:
```bash
#!/usr/bin/env bash

mapshaper -i './tracts10_shore.shp' \
    -filter-fields 'TRACT_FLT' \
```
* And finally, tell it what format, and what to output with ```-o format=topojson force king_county_census_transects.json```.  Notice that I have to add a `\` to escape the carriage return
```bash
#!/usr/bin/env bash

mapshaper -i './tracts10_shore.shp' \
    -filter-fields 'TRACT_FLT' \
    -o format=topojson force king_county_census_transects.json
```

</p>
</details>

## Making the D3 Map

### Links
[TopoJSON](https://github.com/topojson/topojson-client/blob/master/README.md#feature)

