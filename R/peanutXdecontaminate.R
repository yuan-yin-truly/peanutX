#' peanutX decontamination
#'
#' @param counts NxM sparse matrix, N ADTs and M droplets.
#' @param cell_type vector length M. 1 based.
#' @param background_sd
#' @param delta_sd
#'
#' @return A list of decontamination estimation.
#' @export
#'
#' @examples
#'
peanutXdecontaminate <- function(counts,
                                 cell_type,
                                 delta_sd,
                                 background_sd){

  ## Prep data
  N <- nrow(counts)
  M <- ncol(counts)

  p <- matrixStats::rowSums2(counts)
  p <- p/sum(p)

  OC <- matrixStats::colSums2(counts)

  counts <- as.matrix(counts)

  dat <- list(N = N,
             M = M,
             K = length(unique(cell_type)),
             cell_type = cell_type,
             counts = counts,
             OC = OC,
             p = p,
             delta_sd = delta_sd,
             background_sd = background_sd)


  init <- list(delta = matrix(rep(1e-4, N*M,
                            nrow = M,
                            ncol = N),
             background = matrix(rep(1e-2, N*M),
                                 nrow = N,
                                 ncol = M)))




  ## Call inference
  out <- call_stan_vb(dat, init)



  ## Process Stan output
  re <- process_stan_vb_out(out, dat)


  return(re)

}
