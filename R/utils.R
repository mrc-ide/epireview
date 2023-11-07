#' Plotting theme for epireview
#' A standard theme for figures in epireview.
#' @inheritParams ggplot2::theme_bw
#' @importFrom ggplot2 update_geom_defaults
#' @importFrom ggplot2 theme_bw
#' @importFrom ggplot2 theme
#' @export
theme_epireview <- function(
  base_size = 11,
  base_family = "",
  base_line_size = base_size/22,
  base_rect_size = base_size/22) {

  update_geom_defaults("point", list(size = 3))
  update_geom_defaults("segment", list(lwd = 5, alpha = 0.4))
  update_geom_defaults("errorbar", list(lwd = 1, width = 0.4))
  th <- theme_bw(base_size, base_family, base_line_size, base_rect_size)
  th <- th + theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    plot.margin = margin(10, 20, 10, 20),
    panel.spacing = unit(1.5, "lines"),
    legend.position = "bottom"
  )

  th
}
