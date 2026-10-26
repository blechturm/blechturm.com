# Publication helpers for static ggplot2 figures and Plotly line charts.
blechturm_palette <- function(mode = c("light", "dark")) {
  mode <- match.arg(mode)
  if (mode == "light") {
    list(
      paper = "#faf8f4", ink = "#2d3338", muted = "#62676b", rule = "#d9d3c9",
      series = c(copper = "#913f31", teal = "#276a62",
                 plum = "#65519b", ochre = "#8b661a")
    )
  } else {
    list(
      paper = "#1d2228", ink = "#eee9e0", muted = "#a6adb6", rule = "#424950",
      series = c(copper = "#e3a28f", teal = "#8ac2b1",
                 plum = "#bda8e0", ochre = "#dfc476")
    )
  }
}

theme_blechturm <- function(mode = c("light", "dark"), base_size = 14,
                           base_family = "serif") {
  p <- blechturm_palette(match.arg(mode))
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      text = ggplot2::element_text(colour = p$ink),
      axis.text = ggplot2::element_text(colour = p$ink),
      axis.title = ggplot2::element_text(colour = p$ink),
      axis.ticks = ggplot2::element_line(colour = p$muted, linewidth = 0.3),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_line(colour = p$rule, linewidth = 0.3),
      panel.background = ggplot2::element_rect(fill = p$paper, colour = NA),
      plot.background = ggplot2::element_rect(fill = p$paper, colour = NA),
      legend.background = ggplot2::element_rect(fill = p$paper, colour = NA),
      legend.key = ggplot2::element_rect(fill = p$paper, colour = NA),
      legend.position = "top",
      legend.title = ggplot2::element_blank(),
      plot.title.position = "plot",
      plot.caption = ggplot2::element_text(colour = p$muted, hjust = 0)
    )
}

scale_colour_blechturm <- function(mode = c("light", "dark"), ...) {
  p <- blechturm_palette(match.arg(mode))
  ggplot2::scale_colour_manual(..., values = unname(p$series), na.value = p$muted)
}

scale_fill_blechturm <- function(mode = c("light", "dark"), ...) {
  p <- blechturm_palette(match.arg(mode))
  ggplot2::scale_fill_manual(..., values = unname(p$series), na.value = p$muted)
}

layout_blechturm <- function(mode = c("light", "dark")) {
  p <- blechturm_palette(match.arg(mode))
  axis <- list(
    color = p$ink, gridcolor = p$rule, zeroline = FALSE,
    linecolor = p$muted, tickcolor = p$muted, ticks = "outside",
    ticklen = 4, automargin = TRUE
  )
  list(
    paper_bgcolor = p$paper, plot_bgcolor = p$paper,
    colorway = unname(p$series),
    font = list(family = "Georgia, Times New Roman, serif", size = 15, color = p$ink),
    xaxis = c(axis, list(showgrid = FALSE)),
    yaxis = c(axis, list(showgrid = TRUE)),
    legend = list(orientation = "h", x = 0, y = -0.22,
                  xanchor = "left", yanchor = "top", bgcolor = p$paper,
                  font = list(color = p$ink)),
    hoverlabel = list(bgcolor = p$paper, bordercolor = p$muted,
                      font = list(color = p$ink)),
    modebar = list(color = p$muted, activecolor = p$series[[1]]),
    margin = list(l = 65, r = 20, b = 110, t = 85),
    hovermode = "x unified"
  )
}

# Optional browser adaptation for up to four scatter/line traces.
# Recolors the existing chart; it does not execute R when the theme changes.
plotly_blechturm <- function(plot, mode = c("light", "dark"), adaptive = TRUE) {
  mode <- match.arg(mode)
  plot <- do.call(plotly::layout, c(list(p = plot), layout_blechturm(mode)))
  plot <- plotly::config(plot, displaylogo = FALSE, responsive = TRUE,
                         displayModeBar = TRUE, scrollZoom = FALSE,
                         modeBarButtons = list(c("zoom2d", "pan2d", "resetScale2d")))
  if (!adaptive) return(plot)
  plot <- plotly::plotly_build(plot)
  if (length(plot$x$data) > 4L ||
      any(vapply(plot$x$data, function(x) !identical(x$type, "scatter"), logical(1)))) {
    stop("Adaptive publication colors support up to four scatter/line traces.")
  }
  schemes <- lapply(c("light", "dark"), function(mode) {
    p <- blechturm_palette(mode)
    p$colors <- unname(p$series)
    p$series <- NULL
    p
  })
  names(schemes) <- c("light", "dark")
  htmlwidgets::onRender(plot, '
function(el, x, schemes) {
  var previous;
  function update() {
    if (!el.data || !window.Plotly) return;
    var mode = document.body.classList.contains("quarto-dark") ? "dark" : "light";
    if (mode === previous) return;
    previous = mode;
    var p = schemes[mode];
    var colors = el.data.map(function(trace, index) { return p.colors[index]; });
    Plotly.restyle(el, {"line.color": colors, "marker.color": colors}).then(function() {
      return Plotly.relayout(el, {
        "paper_bgcolor": p.paper, "plot_bgcolor": p.paper,
        "font.color": p.ink,
        "xaxis.color": p.ink, "yaxis.color": p.ink,
        "xaxis.gridcolor": p.rule, "yaxis.gridcolor": p.rule,
        "xaxis.linecolor": p.muted, "yaxis.linecolor": p.muted,
        "xaxis.tickcolor": p.muted, "yaxis.tickcolor": p.muted,
        "legend.font.color": p.ink, "legend.bgcolor": p.paper,
        "hoverlabel.bgcolor": p.paper, "hoverlabel.font.color": p.ink,
        "hoverlabel.bordercolor": p.muted,
        "modebar.color": p.muted, "modebar.activecolor": p.colors[0]
      });
    });
  }
  new MutationObserver(update).observe(document.body, {
    attributes: true, attributeFilter: ["class"]
  });
  update();
}', data = schemes)
}
