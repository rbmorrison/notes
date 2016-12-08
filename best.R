## best:  function takes two arguments 
## (2-character abbreviated name of state, and outcome name)
## The function returns the name of the hospital that has the
## best (i.e. lowest) 30-day mortality for the specified outcome
## in that state.  Excludes hospitals with nod data (NA)
## Ties are reported in alphabetical order

best <- function(state, outcome) {
        ## Read outcome data
        state_to_check <- state
        outcome_to_check <- outcome
        
        ## Check that state is valid
        if ( is.null(state) || (!state %in% state.abb) ) {
                stop("invalid state")
        }
                
                
        ## Check that outcome is valid
        if ( is.null(outcome) || (!outcome %in% c("heart attack", 
                                                  "heart failure",
                                                  "pneumonia") ) ) {
                stop("invalid outcome")
        }
        
        
        ## Return hospital name in that state with lowest 30-day death rate
        data <- read.csv("outcome-of-care-measures.csv", 
                         colClasses ='character')
        low <- data.frame()   
        lowest <- data.frame()
        
        ## subset the rows with correct state abbreviation
        low <- data[data$State==state,]        
        
        if (outcome == "heart attack") {
                ## Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
                ## change the column to numeric (coerces "Not Available" to NA)
               low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack <-
                   suppressWarnings(
                       as.numeric(low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)                
                   )
               
               ##  find the row(s) with lowest scores for the outcome
               lowest<- low[which(
                        low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
                        == min(
                        low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack,
                        na.rm=TRUE)
                        ),]
        }
        else if (outcome == "heart failure") {
                
                ## Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure 
                ## change the column to numeric (coerces "Not Available" to NA)
                low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure <-
                   suppressWarnings(
                        as.numeric(low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)
                   )
                
                ##  find the row(s) with lowest scores for the outcome
                lowest<- low[which(
                        low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
                        == min(
                        low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure, 
                        na.rm=TRUE)
                        ),]            
                
        }
        else if (outcome == "pneumonia") {
                ## Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
                ## change the column to numeric (coerces "Not Available" to NA)
                low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia <- 
                   suppressWarnings(
                        as.numeric(low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)
                   )
                
                ##  find the row(s) with lowest scores for the outcome
                lowest<- low[which(
                        low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia 
                        == min(
                        low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia, 
                        na.rm=TRUE)
                        ),] 
        }
        
        ## if there is only one entry return 
        ## if there is a tie send the alphabetized top one
        lowest <- head(lowest[order(lowest$Hospital.Name),],1)
        
        lowest$Hospital.Name
        
}