# Download German weather data from Deutschwer Wetterdienst (DWD) using R

*Last update: 21 April 2020*

R scripts to download (open) weather data for Germany from [Deutscher Wetterdienst (DWD)](https://www.dwd.de/EN/Home/home_node.html). 

**1. Data**

Deutscher Wetterdienst (DWD) provides [data open source](https://www.dwd.de/DE/leistungen/opendata/hilfe.html). However, there is no off the shelf API to download data to my best knowledge.

The following R scripts provide a very basic crawler to download "recent" weather data from DWD's archive.

Please note DWD's policy regarding open data usage: https://www.dwd.de/EN/service/copyright/templates_dwd_as_source.html.

**2. R-Scripts**

**2.1 Download Data**

Find the R-script to download data [here](https://github.com/Bixi81/DWD_weather_data/blob/master/dwd_download_data.R).

DWD data can be accessed online: https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/. Data is ordered by i) type of measure and ii) measuring station (as zip file). Each zip file contains actual data (txt) and several files containing metadata.

In order to programmatically download (recent) weatherdata, all available files for selected type of measures are downloaded to a temporary filder, are unzipped, stored in a list of data frames and later aggregated to a single data frame.

At this stage, each data frame contains rbinded raw data as provided by DWD in * .txt files with name "product_...txt" in each of the [zip files found in the archives](https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/cloudiness/recent/).

|STATIONS_ID|MESS_DATUM|QN_8|V_N_I| V_N|eor|
| --- | --- | --- | --- | --- | --- | 
|430|2018101900|    3|   P|   7|eor|
|430|2018101901|    3|   P|   7|eor|
|...|...|...|...|...|...|

- STATIONS_ID is the ID of the respective [measuring station](https://www.dwd.de/DE/leistungen/klimadatendeutschland/statliste/statlex_html.html?view=nasPublication&nn=16102).
- MESS_DATUM is the date/time. Note that the date format is yyyymmddhhmm. 
- For remaining data, please refer to the respective metadata.

Data downloaded from the DWD page will be stored temporarily in some local directory (name and location can be provided) and are deleted after downloading and rbinding data has been finished. 

**2.2 Retrieve Metadata**

Find the R-script to download metadata [here](https://github.com/Bixi81/DWD_weather_data/blob/master/dwd_merge_data_metadata.R)

Find metadata as CSV (as of 21 April 2020) [here](https://github.com/Bixi81/DWD_weather_data/blob/master/dwd_metadata.csv).

In order to identify the location of each measurement, data collected in 2.1 will be merged with [station metadata](https://www.dwd.de/DE/leistungen/klimadatendeutschland/statliste/statlex_html.html?view=nasPublication&nn=16102). 

**2.3 Merge Weather Data and Metadata**

Find the R-script to merge actual weather data and stations metadata [here](https://github.com/Bixi81/DWD_weather_data/blob/master/dwd_merge_data_metadata.R)

As a result, there will be one data frame per type of measure, including station meta data in each row.

|STATIONS_ID| column_label| MESS_DATUM | QN_9 |TT_TU| RF_TU |eor |  mtype.x |name |      mtype.y |stationskennung |  lat |  lon |height |flussgebiet |state |start | end|  
| 1  |        44  |         19 |2018101703 |    3 | 11.5 |   97 |eor |  TU  |    Großenkne~ |EB  |    01510  |          52.9 | 8.24 |    44  |    564030| NI |   01.01~ |16.0~|
| 2 |         71  |         14 |2018101703 |    3 |  7.6 |   85 |eor |  TU  |    Albstadt-~ |EB  |    02928  |          48.2 | 8.98 |   759  |    710390| BW |   01.07~ |31.1~|
|...|...|...|...|...|...|...|...|...|...|...|...|...|...|...|...|...|...|




