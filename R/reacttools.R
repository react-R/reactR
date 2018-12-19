isUpper <- function(s) {
  grepl("^[[:upper:]]+$", s)
}

#' Create a React component
#'
#' @param name Name of the React component, which must start with an upper-case character.
#' @param ... Attributes and children of the element to pass along to \code{\link[htmltools]{tag}} as varArgs.
#'
#' @return An htmltools \code{\link[htmltools]{tag}} object
#' @export
#'
#' @examples
#' component("ParentComponent",
#'   x = 1,
#'   y = 2,
#'   component("ChildComponent"),
#'   component("OtherChildComponent")
#' )
component <- function(name, varArgs = list()) {
  if (length(name) == 0 || !isUpper(substring(name, 1, 1))) {
    stop("Component name must be specified and start with an upper case character")
  }
  htmltools::tag(name, varArgs)
}

#' @export
React <- structure(list(), class = "react_component_builder")

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

#' Create a data object for transporting a React component to the client.
#'
#' @param tag
#'
#' @return
#' @export
#'
#' @examples
reactData <- function(tag) {
  list(tag = tag)
}
