## rankhospital:  function takes three arguments 
## (2-character abbreviated name of state, an outcome name, rank)
## The function returns the name of the hospital that has the
## specified rank for 30-day mortality for the specified outcome
## in that state.  
## the rank can be "best", "worst" or an integer value
## Excludes hospitals with no data (NA).
## Ties are reported as first hospital in alphabetical order



rankhospital <- function(state, outcome, num = "best") {

        ## Read outcome data
        state_to_check <- state
        outcome_to_check <- outcome
        num_to_check <- num
        
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
        
        
        ## Return hospital name in that state with the given rank
        data <- read.csv("outcome-of-care-measures.csv", colClasses="character")
        low <- data.frame()   
        answer <- data.frame()
        
        ## subset the rows with correct state abbreviation
        low <- data[data$State==state,]        
        
        if (outcome == "heart attack") {
                ## Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
                ## change the column to numeric (coerces "Not Available" to NA)
                low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack <-
                        suppressWarnings(
                                as.numeric(low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)                
                        )

                ##  find the row(s) with rank for the outcome
                if (num == "best") {
                        answer <- low[which(
                        low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
                        == min(
                                low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack,
                                na.rm=TRUE)
                                      ),]
                }
                else if (num == "worst") {
                        answer <- low[which(
                                low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
                                == max(
                                        low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack,
                                        na.rm=TRUE)
                        ),]                        
                }
                else {
                        ## find the rank number given
                        ##low_ranked <- transform(low, rank=ave(
                        ##        low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack,
                        ##        FUN=function(x) rank(x,ties.method="min")))
                        ##answer <- low_ranked[low_ranked$rank == num,]
                        
                        ## order the outcome valuesr
                        order.scores <- order(low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)
                        low <- low[order.scores,]
                        low$rank <- rank(low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack, ties.method="min")
                        
                        answer <- cbind(low$Hospital.Name, low$rank)
                        
                        print(low)
                        print(answer)
                }

        }
        else if (outcome == "heart failure") {
                
                ## Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure 
                ## change the column to numeric (coerces "Not Available" to NA)
                low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure <-
                        suppressWarnings(
                                as.numeric(low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)
                        )
                
                ##  find the row(s) with rank for the outcome
                if (num == "best") {
                        answer <- low[which(
                                low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
                                == min(
                                        low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure,
                                        na.rm=TRUE)
                        ),]
                }
                else if (num == "worst") {
                        answer <- low[which(
                                low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
                                == max(
                                        low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure,
                                        na.rm=TRUE)
                        ),]                        
                }
                else {
                        ## find the rank number given
                        low_ranked <- transform(low, rank=ave(
                                low$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure,
                                FUN=function(x) rank(x,ties.method="min")))
                        answer <- low_ranked[low_ranked$rank == num,]
                } 
                
        }
        else if (outcome == "pneumonia") {
                ## Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
                ## change the column to numeric (coerces "Not Available" to NA)
                low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia <- 
                        suppressWarnings(
                                as.numeric(low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)
                        )
                
                ##  find the row(s) with rank for the outcome
                if (num == "best") {
                        answer <- low[which(
                                low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
                                == min(
                                        low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia,
                                        na.rm=TRUE)
                        ),]
                }
                else if (num == "worst") {
                        answer <- low[which(
                                low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
                                == max(
                                        low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia,
                                        na.rm=TRUE)
                        ),]                        
                }
                else {
                        ## find the rank number given
                        low_ranked <- transform(low, rank=ave(
                                low$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia,
                                FUN=function(x) rank(x,ties.method="min")))
                        answer <- low_ranked[low_ranked$rank == num,]
                        
                        yy <- cbind(low_ranked$Hospital.Name,low_ranked$rank)
                        
                        yy <- yy[sort.list(yy[,2]),]
                        
                        print(yy)
                } 
        }
        
        
        ## 30-day death rate
        ## if best, worst or the number return that
        ## tie breaker:  if there is a tie send the alphabetized top one
        ##answer <- head(answer[order(answer$Hospital.Name),],1)
        
        answer$Hospital.Name
        
}