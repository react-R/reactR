#' @export
curve <- function(...) {
  reactR::React$SparklinesCurve(...)
}

#' @export
spots <- function(...) {
  reactR::React$SparklinesSpots(...)
}

#' @export
reference_line <- function(...) {
  reactR::React$SparklinesReferenceLine(...)
}

#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
sparklineswidget <- function(data, ...) {
  htmlwidgets::createWidget(
    'sparklineswidget',
    reactR::reactData(reactR::component("Sparklines", c(list(data = data, ...)))),
    width = NULL,
    height = NULL,
    package = 'sparklineswidget',
    elementId = NULL
  )
}

#' Shiny bindings for sparklineswidget
#'
#' Output and render functions for using sparklineswidget within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a sparklineswidget
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name sparklineswidget-shiny
#'
#' @export
sparklineswidgetOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'sparklineswidget', width, height, package = 'sparklineswidget')
}

#' @rdname sparklineswidget-shiny
#' @export
renderSparklineswidget <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, sparklineswidgetOutput, env, quoted = TRUE)
}

# Magical
sparklineswidget_html <- function(id, style, class, ...) {
  tagList(
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    tags$span(id = id, class = class)
  )
}
