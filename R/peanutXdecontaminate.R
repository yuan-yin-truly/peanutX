#' Decontaminate using peanutX
#'
#' @param object Data matrix NxM of single cell experiment class
#' @param cell_type 1xM vector of cell_type. 1-based.
#' @param delta_sd Prior for delta. Set to 2e-5 for now.
#' @param background_sd Prior for background. Set to 2e-6 for now.
#' @param ...
#'
#' @return A list of decontaminated counts, and estimated parameters.
#' @export
#'
#' @examples
setGeneric("peanutXdecontaminate", function(object,
                                            cell_type,
                                            delta_sd,
                                            background_sd,
                                            ...) standardGeneric("peanutXdecontaminate"))



setMethod("peanutXdecontaminate", "SingleCellExperiment", function(object,
                                                                   cell_type,
                                                                   delta_sd,
                                                                   background_sd,
                                                                   ...){
  counts <- SummarizedExperiment::assay(object, 'counts')
  output <- .peanutXdecontaminate(counts,
                                cell_type,
                                delta_sd,
                                background_sd)

})


setMethod("peanutXdecontaminate", "ANY", function(object,
                                                  cell_type,
                                                  delta_sd,
                                                  background_sd,
                                                  ...){
  output <- .peanutXdecontaminate(object,
                                  cell_type,
                                  delta_sd,
                                  background_sd)

})





.peanutXdecontaminate <- function(counts,
                                 cell_type,
                                 delta_sd,
                                 background_sd){

  ## Prep data
  N <- nrow(counts)
  M <- ncol(counts)

  p <- rowSums(counts)
  p <- p/sum(p)

  OC <- colSums(counts)

  counts <- as.matrix(counts)

  dat <- list(N = N,
             M = M,
             K = length(unique(cell_type)),
             cell_type = cell_type,
             counts = counts,
             OC = OC,
             p = p,
             run_estimation = 1,
             delta_sd = delta_sd,
             background_sd = background_sd)


  init <- list(delta = matrix(rep(1e-4, N*M),
                            nrow = M,
                            ncol = N),
               background = matrix(rep(1e-2, N*M),
                                 nrow = N,
                                 ncol = M))




  ## Call inference
  out <- .call_stan_vb(dat, init)



  ## Process Stan output
  re <- .process_stan_vb_out(out, dat)


  return(re)

}
