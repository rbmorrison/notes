## rankall
## 


rankall <- function(outcome, num = "best") {
        ## Read outcome data
        ## Check that state and outcome are valid
        
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
        
        ## For each state, find the hospital of the given rank
        ## Return a data frame with the hospital names and the
        ## (abbreviated) state name
        
        
        
        
}