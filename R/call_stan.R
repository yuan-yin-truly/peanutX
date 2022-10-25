#' Title
#'
#' @param data
#' @param initial_condition
#'
#' @return
#'
#' @examples
call_stan <- function(data, initial_condition){

  out <- rstan::vb(object = stanmodels$shrinkage,
                   init = initial_condition,
                   data = data,
                   seed = 12345,
                   iter = 50000)

  return(out)
}
