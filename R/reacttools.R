isUpper <- function(s) {
  grepl("^[[:upper:]]+$", s)
}

#' Create a React component represented by an htmltools \code{\link[htmltools]{tag}}.
#'
#' @param name Name of the React component, which must start with an upper-case character.
#' @param ... Attributes and children of the element to pass along to \code{\link[htmltools]{tag}} as varArgs.
#'
#' @return
#' @export
#'
#' @examples
component <- function(name, ...) {
  if (length(name) == 0 || !isUpper(substring(name, 1, 1))) {
    stop("Component name must be specified and start with an upper case character")
  }
  htmltools::tag(name, list(...))
}
