#!/usr/bin/env Rscript
# tryCatch.Rscript -- experiments with tryCatch

# Get any arguments
arguments <- commandArgs(trailingOnly=TRUE)
a <- arguments[1]

# Define a division function that can issue warnings and errors
myDivide <- function(d, a) {
  if (a == 'warning') {
    return_value <- 'myDivide warning result'
    warning("myDivide warning message")
  } else if (a == 'error') {
    return_value <- 'myDivide error result'
    stop("myDivide error message")
  } else {
    return_value = d / as.numeric(a)
  }
  return(return_value)
}

# Evalute the desired series of expressions inside of tryCatch
result <- tryCatch({
  
  b <- 2
  c <- b^2
  d <- c+2
  if (a == 'suppress-warnings') {
    e <- suppressWarnings(myDivide(d,a))
  } else {
    e <- myDivide(d,a) # 6/a
  }
  f <- e + 100
  
}, warning = function(war) {
  
  # warning handler picks up where error was generated
  print(paste("MY_WARNING:  ",war))
  b <- "changing 'b' inside the warning handler has no effect"
  e <- myDivide(d,0.1) # =60
  f <- e + 100
  return(f)
  
}, error = function(err) {
  
  # error handler picks up where error was generated
  print(paste("MY_ERROR:  ",err))
  b <- "changing 'b' inside the error handler has no effect"
  e <- myDivide(d,0.01) # =600
  f <- e + 100
  return(f)
  
}, finally = {
  
  print(paste("a =",a))
  print(paste("b =",b))
  print(paste("c =",c))
  print(paste("d =",d))
  # NOTE:  Finally is evaluated in the context of of the inital
  # NOTE:  tryCatch block and 'e' will not exist if a warning
  # NOTE:  or error occurred.
  #print(paste("e =",e))
  
}) # END tryCatch

print(paste("result =",result))
