

# A guide to small area estimation with geospatial data in R

Authors: <br>
Haoyi Chen (UNSD) <br>
Josh Merfeld (University of Queensland and IZA) <br>
David Newhouse (World Bank and IZA) <br>
Richard Pearce Tonkin (ESCAP) <br>



<img src="assets/escap.png" alt="drawing" width="200"/><br>

<img src="assets/wblogo.png" alt="drawing" width="200"/><br>

<img src="assets/unsd.png" alt="drawing" width="200"/><br>



Small area estimation (SAE) refers to a set of statistical methods that enable statisticians to create estimates for outcomes of interest at levels of aggregation when sample sizes are too small to generate reliable direct estimates. “Small area” typically refers to administrative or other geographic areas. However, it can also refer to subpopulations for which sample sizes are too small for reliable parameter estimation. 

SAE has been undergoing active development for several decades ([Ghosh, 2020](#1)), with several books written on the topic (the book by [Rao and Molina (2015)](#2) is a particularly good starting point). While there are many different implementations of SAE, all methods have a similar intuition. In all cases, the basic idea is to “augment” survey data using auxiliary data that is predictive of the outcome[^1].

This guide provides an [interactive how-to on the use of geospatial data for SAE](https://escap-sd.github.io/geospatialSAEhowto/). Its development was supported by ESCAP’s project on Big Data for Official Statistics, funded by the 2030 Agenda Sub-Fund of the UN Peace and Development Trust Fund. 

[^1]:For further information on different SAE methods and their implementation for official statistics, you can explore the SAE4SDGs wiki available here: https://unstats.un.org/wiki/spaces/SAE4SDG/overview 

## Small area estimation with geospatial data

Traditionally, SAE has relied on unit-level census data or high-quality administrative data that covers the entire population of interest, not just the surveyed areas. When available, such data can be highly predictive of many outcomes of interest, including poverty, unemployment, and other SDGs. However, a key problem many countries face is that they either do not have access to such data or it is out of date. This raises an important question: if we do not have access to administrative data, what data can we use that is: 

1. Predictive of the outcome of interest?
2. Available for all population areas throughout all areas of interest?

Geospatial data, derived from satellite imagery and other Earth Observation systems, is one such data source that meets these requirements. 
Advantages of geospatial data for SAE include:

- Global availability, including in data-scarce regions;
- High update frequency, often annually or more;
- Predictive strength for poverty and related outcomes (e.g., NDVI, nightlights, population density).

However, geospatial data is not without its challenges. First and foremost, many policymakers and employees in national statistics offices are not used to using geospatial data. In other words, there can be a relatively steep learning curve to using geospatial data, especially when it comes to accessing data through APIs and using alternative programming languages (principally R and Python).
A [Primer on Small Area Estimation with Geospatial Data](https://unstats.un.org/UNSDWebsite/statcom/session_56/documents/BG-3p-Geospatial_SAE_Primer-E.pdf) has been developed which provides a general overview and practical suggestions for using geospatial data in small area estimation (SAE). It discusses commonly used geospatial variables and publicly available repositories for this type of data.


## About this guide

This guide provides a step-by-step walkthrough of using geospatial data to perform small area estimation in R.

The guide is designed to complement the Primer mentioned above by focusing on the practical aspects of implementation. To support hands-on learning, code chunks are included throughout. This repository also contains all the necessary data. 

Readers are encouraged to copy and run the code to run on their own computer while following the guide. To facilitate this, an [interactive HTML version of this guide](https://escap-sd.github.io/geospatialSAEhowto/) is available. On the interactive version, you can click to copy code chunks and then insert them directly into your R console or script.

Throughout this guide, we will be using data from Northern Malawi[^2]. The survey data come from the [Fifth Integrated Household Survey (IHS5)](https://microdata.worldbank.org/index.php/catalog/3818), which is only considered representative at the district (admin 2) level. Our final goal will be to estimate poverty at the admin 3 level for Northern Malawi, which is not possible with the raw survey data – many admin 3 areas have no survey observations at all and those that do tend to have a small sample size.

[^2]:Throughout this guide, we sometimes use maps to visualize both geospatial data and outcomes. The boundaries and names shown and the designations used on these maps do not imply official endorsement or acceptance by the United Nations

While the guide uses example data for Malawi, the approach and code can be adapted to other countries and contexts. The examples assume a basic understanding of R, but the code is fully annotated for users to modify and build upon.

In addition to a [PDF version of the guide](howto.pdf), you can find all of the code and data used in this guide in the current repository. The relevant code are:

- [data](data): This folder contains the data used in this guide, including the survey data and geospatial data.
- [geoaggregation.R](geoaggregation.R): This script contains the code to aggregate the geospatial data for Northern Malawi. It is used in the guide to prepare the data for small area estimation.
- [geospatialpull.pynb](geospatialpull.ipynb): This Jupyter notebook contains the code to pull geospatial data using the Google Earth Engine API in Python. We suggest using Google Colab to run this code, as it is set up to work with the Google Earth Engine API. The notebook is designed to be run in a Jupyter environment, such as Google Colab or an installation on your local machine, and will pull the necessary geospatial data for Northern Malawi.
- [povmap-david3.zip](povmap-david3.zip): This zip file contains the exact version of the `povmap` package used in the guide. You can install it by running `devtools::install_local("PATH TO povmap-david3.zip")` (this assumes you have the `devtools` package installed; you will also need to change the path to the exact path of the .zip file on your machine).






# References

<a id="1"></a> Ghosh, Malay. 2020. “Small area estimation: Its evolution in five decades.” Statistics in Transition. New Series 21 (4): 1–22.

<a id="2"></a> Rao, John NK, and Isabel Molina. 2015. Small Area Estimation. John Wiley & Sons.
