# Publication helpers for static ggplot2 figures and Plotly charts.
blechturm_palette <- function(mode = c("light", "dark")) {
  mode <- match.arg(mode)
  # Derived from the ledgr logo: navy #003366, blue #336699, orange #ff6633.
  # Adjust orange for light-background contrast and lift blues in dark mode.
  if (mode == "light") {
    list(
      paper = "#f8f8f8", ink = "#252525", muted = "#666666", rule = "#d8d8d8",
      series = c(navy = "#003366", blue = "#336699",
                 orange = "#bb431b", graphite = "#666666")
    )
  } else {
    list(
      paper = "#1b1b1b", ink = "#ededed", muted = "#aaaaaa", rule = "#444444",
      series = c(navy = "#a5c4e3", blue = "#6097ce",
                 orange = "#ff6633", graphite = "#b7b7b7")
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

# Optional browser adaptation for up to four line, OHLC, candle, or bar traces.
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
      any(vapply(plot$x$data, function(x) !x$type %in% c("scatter", "ohlc", "candlestick", "bar"), logical(1)))) {
    stop("Adaptive publication colors support up to four line, OHLC, candle, or bar traces.")
  }
  schemes <- lapply(c("light", "dark"), function(mode) {
    p <- blechturm_palette(mode)
    p$up <- unname(p$series[["blue"]])
    p$down <- unname(p$series[["orange"]])
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
    var updates = el.data.map(function(trace, index) {
      var change;
      if (trace.type === "candlestick" || trace.type === "ohlc") {
        var direction = (trace.meta || {}).blechturm_direction;
        var up = direction === "down" ? p.down : p.up;
        var down = direction === "up" ? p.up : p.down;
        change = {"increasing.line.color": up, "decreasing.line.color": down};
        if (trace.type === "candlestick") {
          change["increasing.fillcolor"] = direction === "down" ? p.down : p.paper;
          change["decreasing.fillcolor"] = direction === "up" ? p.paper : p.down;
        }
      } else if (trace.type === "bar") {
        var directions = (trace.meta || {}).blechturm_directions;
        change = {"marker.color": directions ? [directions.map(function(d) {
          return d === "up" ? p.up : p.down;
        })] : p.colors[index]};
      } else {
        change = {"line.color": p.colors[index], "marker.color": p.colors[index]};
      }
      return Plotly.restyle(el, change, [index]);
    });
    Promise.all(updates).then(function() {
      var layout = {
        "paper_bgcolor": p.paper, "plot_bgcolor": p.paper,
        "font.color": p.ink,
        "legend.font.color": p.ink, "legend.bgcolor": p.paper,
        "hoverlabel.bgcolor": p.paper, "hoverlabel.font.color": p.ink,
        "hoverlabel.bordercolor": p.muted,
        "modebar.color": p.muted, "modebar.activecolor": p.colors[0]
      };
      Object.keys(el.layout).filter(function(key) {
        return /^(x|y)axis[0-9]*$/.test(key);
      }).forEach(function(axis) {
        layout[axis + ".color"] = p.ink;
        layout[axis + ".gridcolor"] = p.rule;
        layout[axis + ".linecolor"] = p.muted;
        layout[axis + ".tickcolor"] = p.muted;
      });
      return Plotly.relayout(el, layout);
    });
  }
  new MutationObserver(update).observe(document.body, {
    attributes: true, attributeFilter: ["class"]
  });
  update();
}', data = schemes)
}
