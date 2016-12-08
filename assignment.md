# Reproducible Research: Peer Assessment 2
Rich Morrison  
May 18, 2016  

## Population Health and Economic Impacts from Storm Events in the U.S.

### Introduction
Storms and other severe weather events can cause both public health and economic problems for communities and municipalities. Many severe events can result in fatalities, injuries, and property damage. Preventing or mitigating such outcomes is a key concern. This project explores the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database to answer these two questions of interest:  

1. Across the United States, which types of events are most harmful with respect to population health?
2. Across the United States, which types of events have the greatest economic consequences?

### Synopsis
The NOAA Storm Event database tracks characteristics of major storms and weather events in the United States, including when and where they occur, as well as estimates of any fatalities, injuries, and property damage.  It includes events starting in 1950 and ending November 2011.  The earlier years of the database contain fewer recorded events, most likely due to lack of good records.  

The results of the analysis show the leading storm event types causing fatality/injury to persons and economic damage to property and crops.


### Loading and Processing Raw Data
The data is obtained from the NOAA Storm Database publically available. The raw data file is a commma-separated file compressed via bzip2. 
[Link to data file](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2). The file size is 48Mb and may take several minutes to download and read into a data.frame. A more complete explanation of the data is provided in the National Weather Service [documentation](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf) and the National Climatic Data Center [Storm Events FAQ](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf).  

#### Reading in the data
We start by downloading the data file and reviewing the size, format, and data types included.


```r
# read data
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", temp)
#temp <- "StormData.csv.bz2"
dat <- read.csv(temp, header=TRUE, sep=",", 
                check.names=FALSE, comment.char="", 
                stringsAsFactors=FALSE)
unlink(temp)

# check the data
dim(dat)
```

```
## [1] 902297     37
```

```r
head(dat)
```

```
##   STATE__           BGN_DATE BGN_TIME TIME_ZONE COUNTY COUNTYNAME STATE
## 1       1  4/18/1950 0:00:00     0130       CST     97     MOBILE    AL
## 2       1  4/18/1950 0:00:00     0145       CST      3    BALDWIN    AL
## 3       1  2/20/1951 0:00:00     1600       CST     57    FAYETTE    AL
## 4       1   6/8/1951 0:00:00     0900       CST     89    MADISON    AL
## 5       1 11/15/1951 0:00:00     1500       CST     43    CULLMAN    AL
## 6       1 11/15/1951 0:00:00     2000       CST     77 LAUDERDALE    AL
##    EVTYPE BGN_RANGE BGN_AZI BGN_LOCATI END_DATE END_TIME COUNTY_END
## 1 TORNADO         0                                               0
## 2 TORNADO         0                                               0
## 3 TORNADO         0                                               0
## 4 TORNADO         0                                               0
## 5 TORNADO         0                                               0
## 6 TORNADO         0                                               0
##   COUNTYENDN END_RANGE END_AZI END_LOCATI LENGTH WIDTH F MAG FATALITIES
## 1         NA         0                      14.0   100 3   0          0
## 2         NA         0                       2.0   150 2   0          0
## 3         NA         0                       0.1   123 2   0          0
## 4         NA         0                       0.0   100 2   0          0
## 5         NA         0                       0.0   150 2   0          0
## 6         NA         0                       1.5   177 2   0          0
##   INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO STATEOFFIC ZONENAMES
## 1       15    25.0          K       0                                    
## 2        0     2.5          K       0                                    
## 3        2    25.0          K       0                                    
## 4        2     2.5          K       0                                    
## 5        2     2.5          K       0                                    
## 6        6     2.5          K       0                                    
##   LATITUDE LONGITUDE LATITUDE_E LONGITUDE_ REMARKS REFNUM
## 1     3040      8812       3051       8806              1
## 2     3042      8755          0          0              2
## 3     3340      8742          0          0              3
## 4     3458      8626          0          0              4
## 5     3412      8642          0          0              5
## 6     3450      8748          0          0              6
```

```r
str(dat)
```

```
## 'data.frame':	902297 obs. of  37 variables:
##  $ STATE__   : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : chr  "4/18/1950 0:00:00" "4/18/1950 0:00:00" "2/20/1951 0:00:00" "6/8/1951 0:00:00" ...
##  $ BGN_TIME  : chr  "0130" "0145" "1600" "0900" ...
##  $ TIME_ZONE : chr  "CST" "CST" "CST" "CST" ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: chr  "MOBILE" "BALDWIN" "FAYETTE" "MADISON" ...
##  $ STATE     : chr  "AL" "AL" "AL" "AL" ...
##  $ EVTYPE    : chr  "TORNADO" "TORNADO" "TORNADO" "TORNADO" ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : chr  "" "" "" "" ...
##  $ BGN_LOCATI: chr  "" "" "" "" ...
##  $ END_DATE  : chr  "" "" "" "" ...
##  $ END_TIME  : chr  "" "" "" "" ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI   : chr  "" "" "" "" ...
##  $ END_LOCATI: chr  "" "" "" "" ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F         : int  3 2 2 2 2 2 2 1 3 3 ...
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: chr  "K" "K" "K" "K" ...
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP: chr  "" "" "" "" ...
##  $ WFO       : chr  "" "" "" "" ...
##  $ STATEOFFIC: chr  "" "" "" "" ...
##  $ ZONENAMES : chr  "" "" "" "" ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : chr  "" "" "" "" ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10 ...
```

#### Pre-Processing: Subset Variables of Interest
For the questions of interest, only a subset of the raw data is required for analysis. The following variables are retained for the analysis data set:  

* EVTYPE
* FATALTIES
* INJURIES
* PROPDMG
* PROPDMGEXP
* CROPDMG
* CROPDMGEXP


```r
# subset the raw data to eliminate unneeded columns for analysis
stormdat <- dat[c("EVTYPE","FATALITIES","INJURIES","PROPDMG",
                  "PROPDMGEXP","CROPDMG","CROPDMGEXP")]
# check the header names 
head(stormdat)
```

```
##    EVTYPE FATALITIES INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP
## 1 TORNADO          0       15    25.0          K       0           
## 2 TORNADO          0        0     2.5          K       0           
## 3 TORNADO          0        2    25.0          K       0           
## 4 TORNADO          0        2     2.5          K       0           
## 5 TORNADO          0        2     2.5          K       0           
## 6 TORNADO          0        6     2.5          K       0
```

```r
# How many missing values?
sum(is.na(stormdat))  
```

```
## [1] 0
```

```r
# check summary stats for the selected variables
summary(stormdat)
```

```
##     EVTYPE            FATALITIES          INJURIES        
##  Length:902297      Min.   :  0.0000   Min.   :   0.0000  
##  Class :character   1st Qu.:  0.0000   1st Qu.:   0.0000  
##  Mode  :character   Median :  0.0000   Median :   0.0000  
##                     Mean   :  0.0168   Mean   :   0.1557  
##                     3rd Qu.:  0.0000   3rd Qu.:   0.0000  
##                     Max.   :583.0000   Max.   :1700.0000  
##     PROPDMG         PROPDMGEXP           CROPDMG         CROPDMGEXP       
##  Min.   :   0.00   Length:902297      Min.   :  0.000   Length:902297     
##  1st Qu.:   0.00   Class :character   1st Qu.:  0.000   Class :character  
##  Median :   0.00   Mode  :character   Median :  0.000   Mode  :character  
##  Mean   :  12.06                      Mean   :  1.527                     
##  3rd Qu.:   0.50                      3rd Qu.:  0.000                     
##  Max.   :5000.00                      Max.   :990.000
```

#### Pre-Processing: Damage Estimate Values
Next the damage estimates for property and crops are transformed to provide numerical values from the 2-column value-character pairs that are in the original dataset. Section 2.7 of the National Weather Service documentation gives the valid damage magnitude codes as "K" for thousands, "M" for millions, and "B" for billions.  There are only a small number of events that list invalid codes.  The event rows with valid codes and multipliers are transformed to numeric damage cost estimate values.


```r
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 3.2.4
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
# set exponent codes and their multipliers that are accepted as valid
exp_codes <- c("K","k","M","m","B","b","")
exp_mult <- c(1000, 1000, 1000000, 1000000, 1000000000, 1000000000, 0)
exp_vals <- data.frame(exp_codes, exp_mult)

# check low proportion/number rows with invaliid damage magnitude values
nrow(stormdat[!stormdat$PROPDMGEXP %in% exp_codes,])
```

```
## [1] 321
```

```r
nrow(stormdat[!stormdat$CROPDMGEXP %in% exp_codes,])
```

```
## [1] 27
```

```r
# retain only the rows with valid codes since number invalid is low
stormdat <- stormdat[stormdat$PROPDMGEXP %in% exp_codes,]
stormdat <- stormdat[stormdat$CROPDMGEXP %in% exp_codes,]

# Calculate the damage amounts
stormdat2 <- stormdat

# Note:  the following method looks repetitive, but was found to be much
# faster and smaller output than using merge() from dplyr package.
stormdat$propdamage <- NA
stormdat$cropdamage <- NA
stormdat$propdamage[stormdat$PROPDMGEXP %in% c("K", "k")] <- 
        1000 * stormdat$PROPDMG[stormdat$PROPDMGEXP %in% c("K", "k")]
stormdat$propdamage[stormdat$PROPDMGEXP %in% c("M", "m")] <- 
        1000000 * stormdat$PROPDMG[stormdat$PROPDMGEXP %in% c("M", "m")]
stormdat$propdamage[stormdat$PROPDMGEXP %in% c("B", "b")] <- 
        1000000000 * stormdat$PROPDMG[stormdat$PROPDMGEXP %in% c("B", "b")]
stormdat$cropdamage[stormdat$CROPDMGEXP %in% c("K", "k")] <- 
        1000 * stormdat$CROPDMG[stormdat$CROPDMGEXP %in% c("K", "k")]
stormdat$cropdamage[stormdat$CROPDMGEXP %in% c("M", "m")] <- 
        1000000 * stormdat$CROPDMG[stormdat$CROPDMGEXP %in% c("M", "m")]
stormdat$cropdamage[stormdat$CROPDMGEXP %in% c("B", "b")] <- 
        1000000000 * stormdat$CROPDMG[stormdat$CROPDMGEXP %in% c("B", "b")]
```

#### Pre-Processing: Event Type Categories
There appear to be many human entered values for the event type field (EVTYPE). According to the National Weather Service documentation:  

>Section 2.1 Permitted Storm Events. The only events permitted in _Storm Data_ are listed in Table 1. Storm Data Event Table.  

Table 2.1 has a list of 48 storm event types.  There are 981 unique values for event type in the data set which is problematic for reasonably classifying the causes of damage, injury, and fatality.

```r
# Unique values of EVTYPE are problematic for reasonably aggregating data 
u <- unique(stormdat$EVTYPE)
head(u[order(u)],30)
```

```
##  [1] "   HIGH SURF ADVISORY"          " COASTAL FLOOD"                
##  [3] " FLASH FLOOD"                   " LIGHTNING"                    
##  [5] " TSTM WIND"                     " TSTM WIND (G45)"              
##  [7] " WATERSPOUT"                    " WIND"                         
##  [9] "?"                              "ABNORMAL WARMTH"               
## [11] "ABNORMALLY DRY"                 "ABNORMALLY WET"                
## [13] "ACCUMULATED SNOWFALL"           "AGRICULTURAL FREEZE"           
## [15] "APACHE COUNTY"                  "ASTRONOMICAL HIGH TIDE"        
## [17] "ASTRONOMICAL LOW TIDE"          "AVALANCE"                      
## [19] "AVALANCHE"                      "BEACH EROSIN"                  
## [21] "Beach Erosion"                  "BEACH EROSION"                 
## [23] "BEACH EROSION/COASTAL FLOOD"    "BEACH FLOOD"                   
## [25] "BELOW NORMAL PRECIPITATION"     "BITTER WIND CHILL"             
## [27] "BITTER WIND CHILL TEMPERATURES" "Black Ice"                     
## [29] "BLACK ICE"                      "BLIZZARD"
```

```r
tail(u[order(u)],30)
```

```
##  [1] "WILD/FOREST FIRES"       "WILDFIRE"               
##  [3] "WILDFIRES"               "Wind"                   
##  [5] "WIND"                    "WIND ADVISORY"          
##  [7] "WIND AND WAVE"           "WIND CHILL"             
##  [9] "WIND CHILL/HIGH WIND"    "Wind Damage"            
## [11] "WIND DAMAGE"             "WIND GUSTS"             
## [13] "WIND STORM"              "WIND/HAIL"              
## [15] "WINDS"                   "WINTER MIX"             
## [17] "WINTER STORM"            "WINTER STORM HIGH WINDS"
## [19] "WINTER STORM/HIGH WIND"  "WINTER STORM/HIGH WINDS"
## [21] "WINTER STORMS"           "Winter Weather"         
## [23] "WINTER WEATHER"          "WINTER WEATHER MIX"     
## [25] "WINTER WEATHER/MIX"      "WINTERY MIX"            
## [27] "Wintry mix"              "Wintry Mix"             
## [29] "WINTRY MIX"              "WND"
```

In order to better classify causes to answer the questions of interest, the data is transformed by aggregating similar event type labels to more closely follow the National Weather Service standard storm event table.

```r
# list of NWS categories
events <- c("Avalanche",
            "Coastal Flood/Erosion",
            "Cold/Wind Chill",
            "Debris Flow",
            "Drought",
            "Dust Devil/Storm",
            "Heat",
            "Fire/Smoke",
            "Flood",
            "Frost/Freeze",
            "Funnel Cloud",
            "Fog",
            "Hail",
            "Heat",
            "Rain",
            "Snow",
            "Surf",
            "Hurricane/Typhoon",
            "Ice",
            "Snow",
            "Flood",
            "Lightning",
            "Rip Current",
            "Seiche",
            "Sleet",
            "Storm Surge",
            "Wind",
            "Thunderstorm",
            "Tide",
            "Tornado",
            "Tropical Depression/Storm",
            "Tsunami",
            "Volcanic Ash",
            "Waterspout",
            "Wildfire",
            "Winter Storm/Blizzard",
            "Winter Weather")

length(events)
```

```
## [1] 37
```

```r
# aggregate similar categories
stormdat$EVTYPE[grep(".*summary.*", stormdat$EVTYPE, ignore.case=TRUE)] <- NA
stormdat$EVTYPE[grep(".*wind chill.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Cold/Chill"
stormdat$EVTYPE[grep(".*BLIZZ.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Winter Storm/Blizzard"
stormdat$EVTYPE[grep(".*snow.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Snow"
stormdat$EVTYPE[grep(".*tsun.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Tsunami"
stormdat$EVTYPE[grep(".*typh.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Hurricane/Typhoon"
stormdat$EVTYPE[grep(".*hurric.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Hurricane/Typhoon"
stormdat$EVTYPE[grep(".*floyd.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Hurricane/Typhoon"
stormdat$EVTYPE[grep(".*avalan.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Avalanche"
stormdat$EVTYPE[grep(".*Volcan.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Volcanic Ash"
stormdat$EVTYPE[grep(".*storm surge.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Storm Surge"
stormdat$EVTYPE[grep(".*tide.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Tide"
stormdat$EVTYPE[grep(".*surf.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Surf"
stormdat$EVTYPE[grep(".*current.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Rip Current"
stormdat$EVTYPE[grep(".*tropical.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Tropical Depression/Storm"
stormdat$EVTYPE[grep(".*coastal.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Coastal Flood/Erosion"
stormdat$EVTYPE[grep(".*flood.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Flood"
stormdat$EVTYPE[grep(".*smoke.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Fire/Smoke"
stormdat$EVTYPE[grep(".*fire.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Fire/Smoke"
stormdat$EVTYPE[grep(".*winter.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Winter Storm/Blizzard"
stormdat$EVTYPE[grep(".*lightn.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Lightning"
stormdat$EVTYPE[grep(".*ice.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Ice"
stormdat$EVTYPE[grep(".*icy.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Ice"
stormdat$EVTYPE[grep(".*frost.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Frost/Freeze"
stormdat$EVTYPE[grep(".*freez.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Frost/Freeze"
stormdat$EVTYPE[grep(".*glaze.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Frost/Freeze"
stormdat$EVTYPE[grep(".*drought.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Drought"
stormdat$EVTYPE[grep(".*heat.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Heat"
stormdat$EVTYPE[grep(".*dust.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Dust Devil/Storm"
stormdat$EVTYPE[grep(".*heat.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Heat"
stormdat$EVTYPE[grep(".*fog.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Fog"
stormdat$EVTYPE[grep(".*rain.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Rain"
stormdat$EVTYPE[grep(".*hail.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Hail"
stormdat$EVTYPE[grep(".*sleet.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Sleet"
stormdat$EVTYPE[grep(".*torn.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Tornado"
stormdat$EVTYPE[grep(".*slide.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Debris Flow"
stormdat$EVTYPE[grep(".*Waterspout.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Waterspout"
stormdat$EVTYPE[grep(".*tstm.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Thunderstorm"
stormdat$EVTYPE[grep(".*thunderstorm.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Thunderstorm"
stormdat$EVTYPE[grep(".*funnel.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Funnel Cloud"
stormdat$EVTYPE[grep(".*beach.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Beach Erosion"
stormdat$EVTYPE[grep(".*cold.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Cold/Chill"
stormdat$EVTYPE[grep(".*hypoth.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Cold/Chill"
stormdat$EVTYPE[grep(".*landslump.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Debris Flow"
stormdat$EVTYPE[grep(".*landspout.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Funnel Cloud"
stormdat$EVTYPE[grep(".*cloud.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Funnel Cloud"
stormdat$EVTYPE[grep(".*dry.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Drought"
stormdat$EVTYPE[grep(".*urban.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Flood"
stormdat$EVTYPE[grep(".*high water.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Flood"
stormdat$EVTYPE[grep(".*microburst.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Wind"
stormdat$EVTYPE[grep(".*wnd.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Wind"
stormdat$EVTYPE[grep(".*seas", stormdat$EVTYPE, ignore.case=TRUE)] <- "Surf"
stormdat$EVTYPE[grep(".*wave.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Surf"
stormdat$EVTYPE[grep(".*swells.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Surf"
stormdat$EVTYPE[grep(".*warm.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Heat"
stormdat$EVTYPE[grep(".*hot.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Heat"
stormdat$EVTYPE[grep(".*heat.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Heat"
stormdat$EVTYPE[grep(".*warm.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Heat"
stormdat$EVTYPE[grep(".*burst.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Wind"
stormdat$EVTYPE[grep(".*wet.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Rain"
stormdat$EVTYPE[grep(".*heavy.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Rain"
stormdat$EVTYPE[grep(".*precip.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Rain"
stormdat$EVTYPE[grep(".*flood.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Flood"
stormdat$EVTYPE[grep(".*wind.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Wind"
stormdat$EVTYPE[grep("Cold/Chill", stormdat$EVTYPE, ignore.case=TRUE)] <- "Cold/Wind Chill"
stormdat$EVTYPE[grep(".*seiche.*", stormdat$EVTYPE, ignore.case=TRUE)] <- "Seiche"


# check the new number of unique values for event types
u <- unique(stormdat$EVTYPE)
write.csv(u,"eventtypes.csv")
length(u)
```

```
## [1] 85
```

```r
u
```

```
##  [1] "Tornado"                   "Thunderstorm"             
##  [3] "Hail"                      "Frost/Freeze"             
##  [5] "Snow"                      "Flood"                    
##  [7] "Winter Storm/Blizzard"     "Hurricane/Typhoon"        
##  [9] "Cold/Wind Chill"           "Rain"                     
## [11] "Lightning"                 "Fog"                      
## [13] "Rip Current"               "Wind"                     
## [15] "Funnel Cloud"              "Heat"                     
## [17] "LIGHTING"                  "Waterspout"               
## [19] "Tide"                      "RECORD HIGH TEMPERATURE"  
## [21] "RECORD HIGH"               "Ice"                      
## [23] "RECORD LOW"                "LOW TEMPERATURE RECORD"   
## [25] "Avalanche"                 "MARINE MISHAP"            
## [27] "HIGH TEMPERATURE RECORD"   "RECORD HIGH TEMPERATURES" 
## [29] "Surf"                      "SEVERE TURBULENCE"        
## [31] "Dust Devil/Storm"          "APACHE COUNTY"            
## [33] "Sleet"                     "Fire/Smoke"               
## [35] "HIGH"                      "WATER SPOUT"              
## [37] "Debris Flow"               "Drought"                  
## [39] "GUSTNADO AND"              "WINTRY MIX"               
## [41] "Storm Surge"               "Tropical Depression/Storm"
## [43] "WAYTERSPOUT"               "LIGNTNING"                
## [45] "SMALL STREAM AND"          "GUSTNADO"                 
## [47] "RECORD TEMPERATURES"       "OTHER"                    
## [49] "DAM FAILURE"               "SOUTHEAST"                
## [51] "Beach Erosion"             "LOW TEMPERATURE"          
## [53] "RAPIDLY RISING WATER"      "FLASH FLOOODING"          
## [55] "EXCESSIVE"                 "?"                        
## [57] "MILD PATTERN"              "SMALL STREAM"             
## [59] "Other"                     "Temperature record"       
## [61] "Marine Accident"           "Wintry Mix"               
## [63] "Record temperature"        NA                         
## [65] "Metro Storm, May 26"       "No Severe Weather"        
## [67] "Record Temperatures"       "Sml Stream Fld"           
## [69] "Volcanic Ash"              "NONE"                     
## [71] "DAM BREAK"                 "Wintry mix"               
## [73] "Record High"               "Seiche"                   
## [75] "HYPERTHERMIA/EXPOSURE"     "RECORD COOL"              
## [77] "RECORD TEMPERATURE"        "COOL SPELL"               
## [79] "VOG"                       "MONTHLY TEMPERATURE"      
## [81] "DRIEST MONTH"              "RED FLAG CRITERIA"        
## [83] "NORTHERN LIGHTS"           "DROWNING"                 
## [85] "Tsunami"
```

```r
# check event types labeled different than the standard list
length(stormdat$EVTYPE[!stormdat$EVTYPE %in% events])
```

```
## [1] 372
```

```r
table(stormdat$EVTYPE[!stormdat$EVTYPE %in% events])
```

```
## 
##                        ?            APACHE COUNTY            Beach Erosion 
##                        1                        1                        5 
##               COOL SPELL                DAM BREAK              DAM FAILURE 
##                        1                        4                        1 
##             DRIEST MONTH                 DROWNING                EXCESSIVE 
##                        1                        1                        1 
##          FLASH FLOOODING                 GUSTNADO             GUSTNADO AND 
##                        1                        6                        1 
##                     HIGH  HIGH TEMPERATURE RECORD    HYPERTHERMIA/EXPOSURE 
##                        1                        3                        1 
##                 LIGHTING                LIGNTNING          LOW TEMPERATURE 
##                        3                        1                        7 
##   LOW TEMPERATURE RECORD          Marine Accident            MARINE MISHAP 
##                        1                        1                        2 
##      Metro Storm, May 26             MILD PATTERN      MONTHLY TEMPERATURE 
##                        1                        1                        4 
##        No Severe Weather                     NONE          NORTHERN LIGHTS 
##                        1                        2                        1 
##                    Other                    OTHER     RAPIDLY RISING WATER 
##                        4                       48                        1 
##              RECORD COOL              Record High              RECORD HIGH 
##                        5                        2                        5 
##  RECORD HIGH TEMPERATURE RECORD HIGH TEMPERATURES               RECORD LOW 
##                        3                        1                        4 
##       Record temperature       RECORD TEMPERATURE      Record Temperatures 
##                       11                        5                        2 
##      RECORD TEMPERATURES        RED FLAG CRITERIA        SEVERE TURBULENCE 
##                        3                        2                        1 
##             SMALL STREAM         SMALL STREAM AND           Sml Stream Fld 
##                        1                        1                        2 
##                SOUTHEAST       Temperature record                      VOG 
##                        1                       43                        1 
##              WATER SPOUT              WAYTERSPOUT               Wintry mix 
##                        1                        1                        3 
##               Wintry Mix               WINTRY MIX 
##                        1                       90
```

```r
# since the small number remaining entries are ambiguous, set event type NA
stormdat$EVTYPE[!stormdat$EVTYPE %in% events] <- NA
u <- unique(stormdat$EVTYPE)
write.csv(u,"eventtypesFinal.csv")
length(u)
```

```
## [1] 32
```

```r
u
```

```
##  [1] "Tornado"                   "Thunderstorm"             
##  [3] "Hail"                      "Frost/Freeze"             
##  [5] "Snow"                      "Flood"                    
##  [7] "Winter Storm/Blizzard"     "Hurricane/Typhoon"        
##  [9] "Cold/Wind Chill"           "Rain"                     
## [11] "Lightning"                 "Fog"                      
## [13] "Rip Current"               "Wind"                     
## [15] "Funnel Cloud"              "Heat"                     
## [17] NA                          "Waterspout"               
## [19] "Tide"                      "Ice"                      
## [21] "Avalanche"                 "Surf"                     
## [23] "Dust Devil/Storm"          "Sleet"                    
## [25] "Fire/Smoke"                "Debris Flow"              
## [27] "Drought"                   "Storm Surge"              
## [29] "Tropical Depression/Storm" "Volcanic Ash"             
## [31] "Seiche"                    "Tsunami"
```

```r
table(stormdat$EVTYPE)
```

```
## 
##                 Avalanche           Cold/Wind Chill 
##                       387                      2481 
##               Debris Flow                   Drought 
##                       648                      2811 
##          Dust Devil/Storm                Fire/Smoke 
##                       589                      4261 
##                     Flood                       Fog 
##                     86123                      1835 
##              Frost/Freeze              Funnel Cloud 
##                      1930                      6999 
##                      Hail                      Heat 
##                    290363                      2817 
##         Hurricane/Typhoon                       Ice 
##                       301                      2133 
##                 Lightning                      Rain 
##                     15753                     11982 
##               Rip Current                    Seiche 
##                       774                        21 
##                     Sleet                      Snow 
##                        71                     17694 
##               Storm Surge                      Surf 
##                       409                      1268 
##              Thunderstorm                      Tide 
##                    335445                       282 
##                   Tornado Tropical Depression/Storm 
##                     60676                       757 
##                   Tsunami              Volcanic Ash 
##                        20                        29 
##                Waterspout                      Wind 
##                      3846                     26531 
##     Winter Storm/Blizzard 
##                     22341
```
The data has been transformed to match 32 categories of Event Type (EVTYPE). This set can be better analyzed for meaningful insights to the two questions of interest at the top.

#### Analysis:  Aggregating Property Damage, Crop Damage, Injuries, and Fatalities
The data is aggregated along the cleaned event type list for damage, injury, and fatality totals to provide the relative severity of each type of weather event.


```r
#agregate on the damage amounts and fatality/injury numbers
propdmg <- aggregate(propdamage ~ EVTYPE, dat=stormdat, sum)
cropdmg <- aggregate(cropdamage ~ EVTYPE, dat=stormdat, sum)
damage <- merge(propdmg, cropdmg, by.x="EVTYPE", by.y="EVTYPE")
fatal <- aggregate(FATALITIES ~ EVTYPE, dat=stormdat, sum)
injured <- aggregate(INJURIES ~ EVTYPE, dat=stormdat, sum)

# sort the data.frames from high to low damage, fatalities, or injuries
propdmg <- arrange(propdmg, desc(propdamage))
cropdmg <- arrange(cropdmg, desc(cropdamage))
fatal <- arrange(fatal, desc(FATALITIES))
injured <- arrange(injured, desc(INJURIES))

damage <- arrange(damage, desc(propdamage+cropdamage))
damage
```

```
##                       EVTYPE   propdamage  cropdamage
## 1                      Flood 167582381020 12387987200
## 2          Hurricane/Typhoon  85356410010  5516117800
## 3                    Tornado  56992923230   364958360
## 4                Storm Surge  47964724000      855000
## 5                       Hail  17619985720  3089212850
## 6                    Drought   1053038600 13972636780
## 7               Thunderstorm  10929743030  1206846150
## 8                        Ice   3962345510  5022110800
## 9                 Fire/Smoke   8501728500   403281630
## 10 Tropical Depression/Storm   7716127550   694896000
## 11     Winter Storm/Blizzard   7441209200   159504000
## 12                      Wind   6072627990   767320400
## 13                      Rain   3221993190   951662800
## 14              Frost/Freeze     31174500  1997061000
## 15           Cold/Wind Chill    245579400  1416765500
## 16                      Snow   1027799740   134683100
## 17                 Lightning    934007780    12097090
## 18                      Heat     20125750   904413500
## 19               Debris Flow    327396100    20017000
## 20                   Tsunami    144062000       20000
## 21                      Surf    116560500     1510000
## 22                       Fog     22829500           0
## 23          Dust Devil/Storm      6338130     3600000
## 24                      Tide      9745000           0
## 25                Waterspout      9564200           0
## 26                 Avalanche      3721800           0
## 27                    Seiche       980000           0
## 28              Volcanic Ash       500000           0
## 29              Funnel Cloud       201600           0
## 30               Rip Current       163000           0
## 31                     Sleet            0           0
```

### Results

#### Population Health Impacts of Storms  

**_Question 1: Across the United States, which types of events are most harmful with respect to population health?_**

When comparing the total number of fatalities and injuries across the storm event categories, these five categories lead in both fatality and injury numbers:  

* Tornado
* Heat
* Flood
* Lightning
* Thunderstorm


```r
options("scipen" = 20)
par(mar=c(10,6,4,2))
barplot(fatal$FATALITIES, 
        names=fatal$EVTYPE,
        xlab="",
        ylab="Number Fatalities",
        main="U.S. Storm Event Fatalities (1950-2011)",
        las=2)
```

![](assignment_files/figure-html/fatal_injured_compare-1.png)

```r
par(mar=c(10,6,4,2))
barplot(injured$INJURIES, 
        names=injured$EVTYPE,
        xlab="",
        ylab="Number Injured",
        main="U.S. Storm Event Injuries (1950-2011)",
        las=2)
```

![](assignment_files/figure-html/fatal_injured_compare-2.png)

#### Econcomic Impacts of Storm  

**_Question 2: Across the United States, which types of events have the greatest economic consequences?_**

The total damage to property and crops was used to get a rough look at the magnitude of damage caused by each category of storm event.  The most severe storm events causing the most economic consequences are:  

* Flood
* Hurricane/Typhoon
* Tornado
* Storm Surge


```r
par(mar=c(10,6,4,2))
barplot((damage$propdamage+damage$cropdamage)/1000000000,
        names=damage$EVTYPE,
        xlab="",
        ylab="Total Property and Crop Damage (US $Billions)",
        main="U.S. Storm Event Property Damage (1950-2011)",
        las=2)
```

![](assignment_files/figure-html/prop_crop_damage_compare-1.png)

### Conclusions
After a quick look at the National Weather Service data for damage, injuries and fatalities caused by storm events in the United States, the leading storm events with impacts were displayed. Further risk analysis could produce a comparison of frequency of storm events and the impact levels per storm event.  Regional distinctions in storm event severity and frequency could also be produced.

