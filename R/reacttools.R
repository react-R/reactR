# A robust name string is a valid
# - CSS class
# - JavaScript variable name
# - R variable name
robustName <- "^[[:alpha:]_][[:alnum:]_]*$"

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
#' Tag lists as returned by \code{htmltools tagList} are not currently
#' supported.
#'
#' @param tag character vector or React component or
#'   \code{\link[htmltools]{tag}}
#'
#' @return A reactR markup object suitable for being passed to
#'   \code{\link[htmlwidgets]{createWidget}} as widget instance data.
#' @export
reactMarkup <- function(tag) {
  stopifnot(inherits(tag, "shiny.tag")
            || (is.character(tag) && length(tag) == 1))
  list(tag = tag, class = "reactR_markup")
}

#' Create a React-based input
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param class Space-delimited list of CSS class names that should identify
#'   this input type in the browser.
#' @param dependencies HTML dependencies to include in addition to those
#'   supporting React. Must contain at least one dependency, that of the input's
#'   implementation.
#' @param default Initial value.
#' @param configuration Static configuration data.
#' @param container Function to generate an HTML element to contain the input.
#'
#' @return Shiny input suitable for inclusion in a UI.
#' @export
#'
#' @examples
#' myInput <- function(inputId, default = "") {
#'   # The value of createReactShinyInput should be returned from input constructor functions.
#'   createReactShinyInput(
#'     inputId,
#'     "myinput",
#'     # At least one htmlDependency must be provided -- the JavaScript implementation of the input.
#'     htmlDependency(
#'       name = "my-input",
#'       version = "1.0.0",
#'       src = "www/mypackage/myinput",
#'       package = "mypackage",
#'       script = "myinput.js"
#'     ),
#'     default
#'   )
#' }
createReactShinyInput <- function(inputId,
                             class,
                             dependencies,
                             default = NULL,
                             configuration = list(),
                             container = htmltools::tags$div) {
  if(length(dependencies) < 1) stop("Must include at least one HTML dependency.")
  value <- shiny::restoreInput(id = inputId, default = default)
  htmltools::tagList(
    html_dependency_corejs(),
    html_dependency_react(),
    html_dependency_reacttools(),
    container(id = inputId, class = class),
    htmltools::tags$script(id = sprintf("%s_value", inputId),
                           type = "application/json",
                           jsonlite::toJSON(value, auto_unbox = TRUE, null = "null")),
    htmltools::tags$script(id = sprintf("%s_configuration", inputId),
                           type = "application/json",
                           jsonlite::toJSON(configuration, auto_unbox = TRUE, null = "null")),
    dependencies
  )
}
