<img src="assets/escap.png" alt="drawing" width="200"/>

# A guide to small area estimation with geospatial data in R

Small area estimation (SAE) refers to a set of statistical methods that enable statisticians to create estimates for outcomes of interest at levels of aggregation when sample sizes are too small to generate reliable direct estimates. “Small area” typically refers to administrative or other geographic areas. However, it can also refer to subpopulations for which sample sizes are too small for reliable parameter estimation. 

SAE has been undergoing active development for several decades [@ghosh2020small], with several books written on the topic (the book by @rao2015small is a particularly good starting point). While there are many different implementations of SAE, all methods have a similar intuition. In all cases, the basic idea is to “augment” survey data using auxiliary data that is predictive of the outcome.

For more information on different SAE methods and their implementation for official statistics, you can explore the SAE4SDGs wiki available here: https://unstats.un.org/wiki/spaces/SAE4SDG/overview 

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

The guide is designed to complement the Primer mentioned above by focusing on the practical aspects of implementation. To support hands-on learning, code chunks are included throughout. Readers are encouraged to copy and run the code to run on their own computer while following the guide. To facilitate this, it is recommended to use the HTML version of this guide, available on the GitHub repository. This repository also contains all the necessary data. 

Throughout this guide, we will be using data from Northern Malawi. The survey data come from the [Fifth Integrated Household Survey (IHS5)](https://microdata.worldbank.org/index.php/catalog/3818), which is only considered representative at the district (admin 2) level. Our final goal will be to estimate poverty at the admin 3 level for Northern Malawi, which is not possible with the raw survey data – many admin 3 areas have no survey observations at all and those that do tend to have a small sample size.

To do this, we have three different options. First, we could estimate the model at the household level, connecting the survey data to the geospatial data. Second, we could estimate the model at the admin 4 (enumeration area (EA) in the case of Malawi) level, aggregating the survey data to the admin 4 level and pulling geospatial data at the same level. A final option is to create a grid that covers all of Northern Malawi, and aggregate all data to the grid level in order to estimate poverty. By the end of this guide, we hope you have the tools in order to estimate any one of the three options. 

In practice, which option you choose often depends on the shapefiles available to you. For example, if you do not have household geocoordinates (GPS longitude/latitude) but you do have an admin identifier you can use to match to a shapefile, you would not be able to estimate a model at the grid level, but you could estimate a household-level model and then aggregate estimates up. Similarly, if you do not have shapefiles at the admin 4 level, you would not be able to estimate a model at that level, but might be able to estimate a household- or grid-level model.

While the guide uses example data for Malawi, the approach and code can be adapted to other countries and contexts. The examples assume a basic understanding of R, but the code is fully annotated for users to modify and build upon.

For brevity, we will not go into detail on `R` itself – except as it applies to the specific tasks at hand. In other words, we assume readers have a basic understanding of R and its syntax. While we will be showing all of the code we use, we will not always explain details of the syntax. The guide will also not go into detail on the theory of small area estimation – to learn more about this, it is suggested to refer to the SAE4SDGs wiki and the other references highlighted above.



## Structure of the guide

The initial sections of this guide go through the basic packages we will be using in `R` as well as the different types of data required for geospatial SAE. . In @sec-R, we discuss the setup of `R` and the packages that we will use, including the integrated development environment (IDE) we will use (`RStudio`, @sec-Rsetup), as well as all packages that we will use in this guide (@sec-Rpackages). 

We then turn to the different data formats: shapefiles (vector files) and rasters. Geospatial data are usually stored in formats that some users may not have seen, let alone used, before. As such, we spend substantial time discussing these data formats and learning how to work with them in `R`. In @sec-vectorfiles, we discuss how to read and plot vector files -- which we generally refer to as shapefiles in the present context -- as well as where to find them. We will be using the `R` package `terra` for both shapefiles and rasters. In @sec-rasters, we discuss how to read and plot rasters, as well as how to extract raster data into shapefiles. We will also discuss how to create grids if a shapefile is not available but we have GPS coordinates in the survey data.

There are specific requirements for the survey data in order to be able to match the survey to geospatial data. In @sec-surveydata, we discuss how to perform this matching, as well as the steps to prepare the survey. 

We then turn to a discussion of choosing which predictors to use in an SAE model. The workhorse SAE models nowadays tend to be linear models, meaning we need to be cautious about including too many predictors, both to prevent overfitting (predicting "noise" in the data) as well as to simply be able to estimate the model (if there are more predictors than there are observations, estimation is not possible). As such, in @sec-features, we discuss how to choose features, create new features, and think about transformations. We will also discuss how to use the `glmnet` package to perform lasso for feature selection.

We then turn to the estimation of SAE models. In @sec-estimating, we discuss how to estimate the model using the `povmap` package, as well as how to specify options, verify assumptions, and evaluate results.

Finally, in @sec-mapping, we discuss how to map poverty using the estimates we have obtained. We will create tables and maps to visualize the results.

You can find all of the code and data used on the GitHub repository for this guide, [here](https://github.com/JoshMerfeld/geospatialSAEhowto).


