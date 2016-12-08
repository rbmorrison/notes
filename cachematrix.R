## Matrix inversion is usually a costly computation.  Caching the
## inverse of a matrix can provide some benefits to efficiency.
## The following functions cache the inverse of a matrix.  These functions
## assume that the matrix is always a square invertible matrix
## (there is no error detection.)

## makeCacheMatrix: This function creates a special 
## "matrix" object that can cache its inverse.
makeCacheMatrix <- function(x = matrix()) {
        inv_mat <- NULL
        set <- function(y) {
                x <<- y
                inv_mat <<- NULL
        }
        get <- function() x
        setinverse <- function(inv) inv_mat <<- inv
        getinverse <- function() inv_mat
        list(set = set, 
             get = get,
             setinverse = setinverse,
             getinverse = getinverse)
}


## cacheSolve:  ## This function computes the inverse of a  
## "matrix" returned by makeCacheMatrix above. If the 
## inverse has already been calculated (and the matrix 
## has not changed), then cacheSolve should retrieve the 
## inverse from the cache.
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
        inv_mat <- x$getinverse()
        if(!is.null(inv_mat)) {
                message("getting cached data")
                return (inv_mat)
        }
        data <- x$get()
        inv_mat <- solve(data, ...)
        x$setinverse(inv_mat)
        inv_mat
}
