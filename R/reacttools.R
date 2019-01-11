isUpper <- function(s) {
  grepl("^[[:upper:]]+$", s)
}

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
  component <- htmltools::tag(name, varArgs)
  structure(component, class = c("reactR_component", oldClass(component)))
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

#' Prepare data that represents a single-element character vector, a React
#' component, or an htmltools tag for sending to the client.
#'
#' Tag lists as returned by \code{\link[htmltools]{tagList}} are not currently
#' supported.
#'
#' @param tag character vector or React component or
#'   \code{\link[htmltools]{tag}}
#'
#' @return
#' @export
reactMarkup <- function(tag) {
  stopifnot(inherits(tag, "shiny.tag")
            || (is.character(tag) && length(tag) == 1))
  list(tag = tag, class = "reactR_markup")
}

