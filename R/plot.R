#' Density of each ADT, raw counts overlapped with decontaminated counts
#'
#' @param counts raw count matrix
#' @param decontaminated_counts decontaminated count matrix
#' @param features names of ADT to plot
#' @param file_name output file name
#'
#' @return pdf in working directory
#' @export
#'
#' @examples
#'
plotDensity <- function(counts,
                        decontaminated_counts,
                        features,
                        file_name) {
  grDevices::pdf(paste0(file_name, ".pdf"))


  for (i in 1:length(features)) {
    feature <- features[i]


    df <- data.frame(con = counts[feature,],
                     decon = decontaminated_counts[feature,])
    df.m <- reshape2::melt(df)



    # Plot
    p1 <- ggplot2::ggplot(df.m,
                          ggplot2::aes_string("value", fill = "variable")) +
      ggplot2::geom_density(alpha = 0.7) +
      ggplot2::scale_x_continuous(trans = scales::pseudo_log_trans(),
                         breaks = c(1, 5, 10 ^ (1:4))) +
      ggplot2::scale_fill_manual(values = c("#E64B35B2", "#4DBBD5B2"),
                                 labels = c('Raw', 'Decontaminated')) +
      ggplot2::ggtitle(feature) +
      ggplot2::labs(x = "", fill = "") +
      ggplot2::theme_classic() +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(
          angle = 45,
          vjust = 1,
          hjust = 0.9
        ),
        # legend.title = element_blank(),
        legend.margin = ggplot2::margin(t = -10)
      )

    ylimit <- ggplot2::layer_scales(p1)$y$get_limits()
    ylimit[2] <- min(ylimit[2], 5)
    p1 <- p1 + ggplot2::coord_cartesian(ylim = ylimit)


    print(p1)

  }
  grDevices::dev.off()
}
