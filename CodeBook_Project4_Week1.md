---
title: "Codebook_Project4_Week1"
author: "Rich Morrison"
date: "April 8, 2016"
output:
  html_document:
    keep_md: yes
---


## Project Description
This assignment uses data from the UC Irvine Machine Learning Repository, a popular repository for machine learning datasets. In particular, we will be using the "Individual household electric power consumption Data Set" which I have made available on the course web site.  Our overall goal here is simply to examine how household energy usage varies over a 2-day period in February, 2007. Your task is to reconstruct the following plots below, all of which were constructed using the base plotting system.

##Study design and data processing
1.) First you will need to fork and clone the following GitHub repository: https://github.com/rdpeng/ExData_Plotting1

2.) For each plot you should:

- Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
- Name each of the plot files as plot1.png, plot2.png, etc.
- Create a separate R code file (plot1.R, plot2.R, etc.) that constructs the corresponding plot, i.e. code in plot1.R constructs the plot1.png plot. Your code file should include code for reading the data so that the plot can be fully reproduced. You must also include the code that creates the PNG file.
- Add the PNG file and R code file to the top-level folder of your git repository (no need for separate sub-folders)
- When you are finished with the assignment, push your git repository to GitHub so that the GitHub version of your repository is up to date. There should be four PNG files and four R code files, a total of eight files in the top-level folder of the repo.

###Collection of the raw data
Dataset: Electric power consumption [20Mb]
https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

Description: Measurements of electric power consumption in one household with a one-minute sampling rate over a period of almost 4 years. Different electrical quantities and some sub-metering values are available.

###Notes on the original (raw) data 
The dataset has 2,075,259 rows and 9 columns.

The following descriptions of the 9 variables in the raw dataset are taken from the UCI web site:

Date: Date in format dd/mm/yyyy

Time: time in format hh:mm:ss

Global_active_power: household global minute-averaged active power (in kilowatt)

Global_reactive_power: household global minute-averaged reactive power (in kilowatt)

Voltage: minute-averaged voltage (in volt)

Global_intensity: household global minute-averaged current intensity (in ampere)

Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).

Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.

Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.


##Creating the tidy datafile

###Guide to create the tidy data file
1. Calculate Memory Reqs as:  NROWS x NCOLS x (8 bytes/numeric)  and 
2^20 bytes/MB and 2^10 MB per GB.  The overhead is about twice as much memory
to read in the data frame.
- For this project the data size is estimated to be:
2,075,259 x 9 x (8 bytes) = 149,418,648 bytes = 142.5 MB = 0.14 GB
- To read in the dataset, approximate memory required is:  0.28 GB (285 MB)

2. Download the data.

3. Convert Date and Time variables into Date/Time classes.

4. Change the missing values from "?" to "NA"

###Cleaning of the data
File is downloaded and cleaned at begining of the script.

##Description of the variables in the tiny_data.txt file
General description of the file including:
 - Dimensions of the dataset
 - Summary of the data
 - Variables present in the dataset

(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)

##Sources
Sources you used if any, otherise leave out.

##Annex
If you used any code in the codebook that had the echo=FALSE attribute post this here (make sure you set the results parameter to 'hide' as you do not want the results to show again)