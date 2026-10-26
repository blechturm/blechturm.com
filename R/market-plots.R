# Read-only publication plots for a single instrument's OHLCV observations.
read_market_bars <- function(path) {
  bars <- utils::read.csv(
    path, colClasses = c("character", "character", rep("numeric", 5))
  )
  expected <- c("ts_utc", "instrument_id", "open", "high", "low", "close", "volume")
  stopifnot(identical(names(bars), expected))
  bars$ts_utc <- as.POSIXct(bars$ts_utc, format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  stopifnot(
    nrow(bars) > 1, !anyNA(bars), length(unique(bars$instrument_id)) == 1,
    !anyDuplicated(bars$ts_utc), all(diff(as.numeric(bars$ts_utc)) > 0),
    all(as.matrix(bars[c("open", "high", "low", "close")]) > 0),
    all(bars$high >= pmax(bars$open, bars$close)),
    all(bars$low <= pmin(bars$open, bars$close)), all(bars$volume >= 0)
  )
  bars
}

market_plot_data <- function(bars) {
  bars$direction <- factor(
    ifelse(bars$close >= bars$open, "Up / flat", "Down"),
    levels = c("Up / flat", "Down")
  )
  half_width <- min(diff(as.numeric(bars$ts_utc))) * 0.3
  bars$left <- bars$ts_utc - half_width
  bars$right <- bars$ts_utc + half_width
  bars
}

plot_market_bars <- function(bars, style = c("hollow", "filled", "ohlc"),
                             mode = c("light", "dark")) {
  style <- match.arg(style)
  mode <- match.arg(mode)
  p <- blechturm_palette(mode)
  d <- market_plot_data(bars)
  colors <- c("Up / flat" = p$series[["blue"]], Down = p$series[["orange"]])
  fills <- if (style == "hollow") c("Up / flat" = p$paper, Down = colors[["Down"]]) else colors
  limits <- range(c(d$left, d$right))
  xscale <- function() ggplot2::scale_x_datetime(
    limits = limits, date_breaks = "1 week", date_labels = "%b %d",
    timezone = "UTC", expand = ggplot2::expansion(mult = 0.01)
  )
  price <- ggplot2::ggplot(d, ggplot2::aes(x = ts_utc, colour = direction)) +
    ggplot2::geom_segment(ggplot2::aes(xend = ts_utc, y = low, yend = high), linewidth = 0.55)
  if (style == "ohlc") {
    price <- price +
      ggplot2::geom_segment(ggplot2::aes(x = left, xend = ts_utc, y = open, yend = open), linewidth = 0.7) +
      ggplot2::geom_segment(ggplot2::aes(xend = right, y = close, yend = close), linewidth = 0.7)
  } else {
    price <- price +
      ggplot2::geom_rect(ggplot2::aes(
        xmin = left, xmax = right, ymin = pmin(open, close),
        ymax = pmax(open, close), fill = direction
      ), linewidth = 0.55) +
      ggplot2::geom_segment(
        data = d[d$open == d$close, ],
        ggplot2::aes(x = left, xend = right, y = open, yend = close), linewidth = 0.7
      ) +
      ggplot2::scale_fill_manual(values = fills, guide = "none")
  }
  price <- price + xscale() + ggplot2::scale_colour_manual(values = colors) +
    ggplot2::labs(x = NULL, y = "Price", colour = NULL) + theme_blechturm(mode) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(), plot.margin = ggplot2::margin(5, 8, 0, 5)
    )
  if (style != "ohlc") {
    price <- price + ggplot2::guides(colour = ggplot2::guide_legend(
      override.aes = list(fill = unname(fills[levels(droplevels(d$direction))]))
    ))
  }
  volume <- ggplot2::ggplot(d, ggplot2::aes(ts_utc, volume / 1000, fill = direction)) +
    ggplot2::geom_col(width = 2 * as.numeric(d$right[1] - d$ts_utc[1], units = "secs")) +
    xscale() + ggplot2::scale_fill_manual(values = colors, guide = "none") +
    ggplot2::labs(x = "Bar timestamp (UTC)", y = "Volume\n(thousands)") +
    theme_blechturm(mode) +
    ggplot2::theme(plot.margin = ggplot2::margin(0, 8, 5, 5))
  price_grob <- ggplot2::ggplotGrob(price)
  volume_grob <- ggplot2::ggplotGrob(volume)
  widths <- grid::unit.pmax(price_grob$widths, volume_grob$widths)
  price_grob$widths <- volume_grob$widths <- widths
  grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout = grid::grid.layout(
    2, 1, heights = grid::unit(c(3.5, 1.3), "null")
  )))
  grid::pushViewport(grid::viewport(layout.pos.row = 1))
  grid::grid.draw(price_grob)
  grid::popViewport()
  grid::pushViewport(grid::viewport(layout.pos.row = 2))
  grid::grid.draw(volume_grob)
  grid::popViewport(2)
  invisible(NULL)
}

market_candles_widget <- function(bars, mode = c("light", "dark"), visible = 30L) {
  mode <- match.arg(mode)
  p <- blechturm_palette(mode)
  d <- market_plot_data(bars)
  timestamps <- format(d$ts_utc, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  up <- d$close >= d$open
  colors <- ifelse(up, p$series[["blue"]], p$series[["orange"]])
  hover <- sprintf(
    "%s<br>%s UTC<br>Open %.4f<br>High %.4f<br>Low %.4f<br>Close %.4f<br>Volume %s",
    d$instrument_id, format(d$ts_utc, "%Y-%m-%d %H:%M", tz = "UTC"),
    d$open, d$high, d$low, d$close, format(d$volume, big.mark = ",", scientific = FALSE)
  )
  price <- plotly::plot_ly()
  for (direction in c("up", "down")) {
    keep <- if (direction == "up") up else !up
    color <- if (direction == "up") p$series[["blue"]] else p$series[["orange"]]
    fill <- if (direction == "up") p$paper else color
    styled <- list(line = list(color = color, width = 1.3), fillcolor = fill)
    price <- plotly::add_trace(
      price, x = timestamps, type = "candlestick",
      open = ifelse(keep, d$open, NA_real_),
      high = ifelse(keep, d$high, NA_real_),
      low = ifelse(keep, d$low, NA_real_),
      close = ifelse(keep, d$close, NA_real_),
      increasing = styled, decreasing = styled,
      text = hover, hoverinfo = "text", showlegend = FALSE,
      meta = list(blechturm_direction = direction), name = direction
    )
  }
  volume <- plotly::plot_ly(
    x = timestamps, y = d$volume, type = "bar",
    marker = list(color = colors), showlegend = FALSE,
    meta = list(blechturm_directions = ifelse(up, "up", "down")),
    hovertemplate = "%{x|%Y-%m-%d}<br>Volume %{y:,.0f}<extra></extra>"
  )
  widget <- plotly::subplot(price, volume, nrows = 2, shareX = TRUE,
                            heights = c(0.75, 0.25), margin = 0.035)
  window <- range(tail(d$ts_utc, min(visible, nrow(d))))
  half_width <- as.numeric(d$right[1] - d$ts_utc[1], units = "secs")
  plotly::layout(
    plotly_blechturm(widget, mode),
    xaxis = list(
      type = "date", rangeslider = list(visible = FALSE),
      range = format(window + c(-half_width, half_width),
                     "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
      title = "Bar timestamp (UTC)"
    ),
    yaxis = list(title = "Price"),
    yaxis2 = c(layout_blechturm(mode)$yaxis, list(title = "Volume", tickformat = ".2s")),
    margin = list(l = 75, r = 20, b = 55, t = 85), showlegend = FALSE
  )
}