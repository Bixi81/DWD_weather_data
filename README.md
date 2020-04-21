# Download German weather data from Deutschwer Wetterdienst (DWD) using R

*Last update: 21 April 2020*

R scripts to download (open) weather data for Germany from Deutschwer Wetterdienst (DWD). 

**1. Data**

Deutscher Wetterdienst (DWD) provides [data open source](https://www.dwd.de/DE/leistungen/opendata/hilfe.html). However, there is no off the shelf API to download data to my best knowledge.

The following R scripts provide a very basic crawler to download "recent" weather data from DWD's archive.

Please note DWD's policy regarding open data usage: https://www.dwd.de/EN/service/copyright/templates_dwd_as_source.html.

**2. R Scripts**

DWD data can be accessed online: https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/. Data is ordered by i) type of measure and ii) measuring station (as zip file). Each zip file contains actual data (txt) and several files containing metadata.

In order to programmatically download (recent) weatherdata, all available files for selected type of measures are downloaded to a temporary filder, are unzipped, stored in a list of data frames and later aggregated to a single data frame.

At this stage, each data frame contains rbinded raw data as provided by DWD in *.txt files with name "product_...txt".

|STATIONS_ID|MESS_DATUM|QN_8|V_N_I| V_N|eor|
| --- | --- | --- | --- | --- | --- | 
        |430|2018101900|    3|   P|   7|eor|
        |430|2018101901|    3|   P|   7|eor|
