#' Title
#'
#' @param counts
#' @param cell_type
#' @param delta_sd
#' @param ground_sd
#'
#' @return
#' @export
#'
#' @examples
#'
peanutXdecontaminate <- function(counts,
                                 cell_type,
                                 delta_sd,
                                 ground_sd){

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
  out <- call_stan(dat, init)



  ## Process Stan output
  re <- process_stan_vb(out)


  return(re)

}
