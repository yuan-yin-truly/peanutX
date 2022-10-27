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
plotDensity <- function(counts,
                        decontaminated_counts,
                        features,
                        file_name) {
  pdf(paste0(file_name, ".pdf"))


  for (i in 1:length(features)) {
    feature <- features[i]


    df <- data.frame(con = counts[feature,],
                     decon = decontaminated_counts[feature,])
    df.m <- reshape2::melt(df)



    # Plot
    p1 <- ggplot2::ggplot(df.m, aes(value, fill = variable)) +
      geom_density(alpha = 0.7) +
      scale_x_continuous(trans = scales::pseudo_log_trans(),
                         breaks = c(1, 5, 10 ^ (1:4))) +
      scale_fill_manual(labels = c('Raw', 'Decontaminated')) +
      ggtitle(feature) +
      labs(x = "", fill = "") +
      theme_classic() +
      theme(
        axis.text.x = element_text(
          angle = 45,
          vjust = 1,
          hjust = 0.9
        ),
        # legend.title = element_blank(),
        legend.margin = margin(t = -10)
      )

    ylimit <- layer_scales(p1)$y$get_limits()
    ylimit[2] <- min(ylimit[2], 5)
    p1 <- p1 + coord_cartesian(ylim = ylimit)


    print(p1)

  }
  dev.off()
}
