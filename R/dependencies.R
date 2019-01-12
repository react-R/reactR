#' Dependencies for React
#'
#' Add JavaScript 'React' dependency.  For this to work in RStudio Viewer, also include
#' \code{\link{html_dependency_corejs}}.
#'
#' @param offline \code{logical} to use local file dependencies.  If \code{FALSE},
#'          then the dependencies use the Facebook cdn as its \code{src}.
#'          To use with \code{JSX} see \code{\link{babel_transform}}.
#'
#' @return \code{\link[htmltools]{htmlDependency}}
#' @importFrom htmltools htmlDependency
#' @export
#'
#' @examples
#' library(reactR)
#' library(htmltools)
#'
#' tagList(
#'   tags$script(
#'   "
#'     ReactDOM.render(
#'       React.createElement(
#'         'h1',
#'         null,
#'         'Powered by React'
#'       ),
#'       document.body
#'     )
#'   "
#'   ),
#'    #add core-js first to work in RStudio Viewer
#'   html_dependency_corejs(),
#'   html_dependency_react() #offline=FALSE for CDN
#' )
html_dependency_react <- function(offline=TRUE){
  hd <- htmltools::htmlDependency(
    name = "react",
    version = react_version(),
    src = system.file("www/react",package="reactR"),
    script = c("react.min.js", "react-dom.min.js")
  )

  if(!offline) {
    hd$src <- list(href="//unpkg.com")

    hd$script <- c(
      "react/umd/react.production.min.js",
      "react-dom/umd/react-dom.production.min.js"
    )
  }

  hd
}


#' Shim Dependency for React in RStudio Viewer
#'
#' Add this first for 'React' to work in RStudio Viewer.
#'
#' @return \code{\link[htmltools]{htmlDependency}}
#' @importFrom htmltools htmlDependency
#' @export
html_dependency_corejs <- function() {
  #shim/polyfill for ES5 and ES6 so react will show up in RStudio Viewer
  #https://unpkg.com/core-js@2.5.3/
  htmltools::htmlDependency(
    name = "core-js",
    version = "2.5.3",
    src = c(file=system.file("www/core-js/", package="reactR")),
    script = "shim.min.js"
  )
}

#' Adds window.reactR.exposeComponents and window.reactR.hydrate
#'
#' @return \code{\link[htmltools]{htmlDependency}}
#' @importFrom htmltools htmlDependency
#' @export
html_dependency_reacttools <- function(){
  htmltools::htmlDependency(
    name = "reactwidget",
    src = "www/react-tools",
    version = "1.0.0",
    package = "reactR",
    script = c("react-tools.js")
  )
}
