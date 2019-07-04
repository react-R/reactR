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

#' Dependencies for 'mobx'
#'
#' Add JavaScript 'mobx' and 'mobx-react' dependency.  When using with 'react', the order
#' of the dependencies is important, so please add \code{html_dependency_react()} before
#' \code{html_dependency_mobx()}.
#'
#' @param react \code{logical} to add react 'mobx' dependencies.
#'
#' @return \code{\link[htmltools]{htmlDependency}}
#' @importFrom htmltools htmlDependency
#' @export
#'
#' @examples
#' if(interactive()) {
#'
#' library(htmltools)
#' library(reactR)
#'
#' browsable(
#'   tagList(
#'     html_dependency_mobx(react = FALSE),
#'     div(id="test"),
#'     tags$script(HTML(
#' "
#'   var obs = mobx.observable({val: null})
#'   mobx.autorun(function() {
#'     document.querySelector('#test').innerText = obs.val
#'   })
#'   setInterval(
#'     function() {obs.val++},
#'     1000
#'   )
#' "
#'     ))
#'   )
#' )
#' }
#'
#' \dontrun{
#' # use with react
#' library(htmltools)
#' library(reactR)
#'
#' browsable(
#'   tagList(
#'     html_dependency_react(),
#'     html_dependency_mobx(),
#'     div(id="test"),
#'     tags$script(HTML(babel_transform(
#' "
#'   var obs = mobx.observable({val: null})
#'   var App = mobxReact.observer((props) => <div>{props.obs.val}</div>)
#'
#'   ReactDOM.render(<App obs = {obs}/>, document.querySelector('#test'))
#'
#'   setInterval(
#'     function() {obs.val++},
#'     1000
#'   )
#' "
#'     )))
#'   )
#' )
#' }

html_dependency_mobx <- function(react = TRUE){
  hd <- htmltools::htmlDependency(
    name = "mobx",
    version = "4.11.0",
    src = system.file("www/mobx",package="reactR"),
    script = c("mobx.umd.min.js")
  )

  if(react) {
     hd$script <- c(hd$script,"mobx-react-lite.js", "mobx-react.umd.js")
  }

  hd
}
