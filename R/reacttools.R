isUpper <- function(s) {
  grepl("^[[:upper:]]+$", s)
}

#' React component builder functions
#'
#' Functions for creating React component, HTML, and SVG trees to send to the
#' browser for rendering.
#'
#' The \code{\link{component}} function creates a representation of a React
#' component instance to send to the browser for rendering. It is analagous to
#' \code{\link[htmltools]{tag}}.
#'
#' The \code{\link{React}} list is a special object that supports
#' \link[=InternalMethods]{extraction} syntax for creating React components.
#'
#' Once a component or tag has been created in R, it must be passed to
#' \code\{\link{reactData}} before being sent to the browser. In the case of
#' htmlwidgets, the return value of \code{reactData} should be passed as the
#' \code{x} argument of \code{\link{htmlwidgets::createWidget}}.
#'
#' Any React components named by \code{component} or \code{React} must have been
#' installed on the client using \code{reactR.reactWidget}. Alternatively, the
#' JSON representing the tag can be converted to a React component tree with
#' \code{reactR.hydrate}.
#'
#' @name builder
NULL

#' Create a React component
#'
#' @param name Name of the React component, which must start with an upper-case
#'   character.
#' @param varArgs Attributes and children of the element to pass along to
#'   \code{\link[htmltools]{tag}} as \code{varArgs}.
#'
#' @return An htmltools \code{\link[htmltools]{tag}} object
#' @export
#'
#' @examples
#' component("ParentComponent",
#'   list(
#'     x = 1,
#'     y = 2,
#'     component("ChildComponent"),
#'     component("OtherChildComponent")
#'   )
#' )
component <- function(name, varArgs = list()) {
  if (length(name) == 0 || !isUpper(substring(name, 1, 1))) {
    stop("Component name must be specified and start with an upper case character")
  }
  htmltools::tag(name, varArgs)
}

#' React component builder.
#'
#' \code{React} is a syntactically-convenient way to create instances of React
#' components that can be sent to the browser for display. It is a list for
#' which \link[=InternalMethods]{extract methods} are defined, allowing
#' object creation syntax like \code{React$MyComponent(x = 1)} where
#' \code{MyComponent} is a React component you have exposed to Shiny in
#' JavaScript.
#'
#' Internally, the \code{\link{component}} function is used to create the
#' component instance.
#'
#' @examples
#' # Create an instance of ParentComponent with two children,
#' # ChildComponent and OtherChildComponent.
#' React$ParentComponent(
#'   x = 1,
#'   y = 2,
#'   React$ChildComponent(),
#'   React$OtherChildComponent()
#' )
#' @export
React <- structure(
  list(),
  class = "react_component_builder"
)

#' @export
`$.react_component_builder` <- function(x, name) {
  function(...) {
    component(name, list(...))
  }
}

#' @export
`[[.react_component_builder` <- `$.react_component_builder`

#' @export
`$<-.react_component_builder` <- function(x, name, value) {
  stop("Assigning to a component constructor is not allowed")
}

#' @export
`[[<-.react_component_builder` <- `$<-.react_component_builder`

#' Create a data object for sending a React component to the client.
#'
#' @param tag React component or \code{\link[htmltools]{tag}}
#'
#' @return
#' @export
#'
#' @examples
reactData <- function(tag) {
  list(tag = tag)
}

