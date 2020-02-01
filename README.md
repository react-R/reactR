
# reactR <img src="vignettes/logo.svg" alt="reactR logo" width="100px" />

<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/reactR)](https://cran.r-project.org/package=reactR)
[![Travis-CI Build
Status](https://travis-ci.org/react-R/reactR.svg?branch=master)](https://travis-ci.org/react-R/reactR)
[![Slack
Status](https://reactr-slackin.herokuapp.com/badge.svg)](https://reactr-slackin.herokuapp.com/)

`reactR` provides a set of convenience functions for using
[`React`](https://facebook.github.io/react) in `R` with `htmlwidget`
constructor templates and local JavaScript dependencies. The `React`
ecosystem is rich with components that can enhance `R` web and Shiny
apps. `scaffoldReactWidget()` helps build `htmlwidgets` to integrate
these `React` components as `R` `htmlwidgets`.
`scaffoldReactShinyInput()` does the same for `Shiny` inputs. The local
dependency functions are modeled after the `html_dependency_*` functions
from RStudio’s [`rmarkdown`](https://github.com/rstudio/rmarkdown)
package.

## Installation

You can install reactR from CRAN with `install.packages("reactR")`. For
the development version, please use `devtools` as shown below.

``` r
# install.packages("devtools")
devtools::install_github("react-R/reactR")
```

## Creating htmlwidgets with React Components

To wrap a `React` component as an `htmlwidget`, please see the tutorial
[htmlwidgets with
reactR](https://react-r.github.io/reactR/articles/intro_htmlwidgets.html).
Also, there are a variety of examples in the [react-R Github
organization](https://github.com/react-R).

[`reactable`](https://github.com/glin/reactable) is a very well-built
`htmlwidget` leveraging this functionality.

## Shiny Outputs and Inputs

`htmlwidgets` built with `reactR` work well in Shiny as outputs. In
version `0.4.0` Alan Dipert has added the ability to easily create
React-based official `Shiny` inputs with helpers and scaffolds. Please
see the
[tutorial](https://react-r.github.io/reactR/articles/intro_inputs.html)
for more details.

## Examples

Below are examples of using `reactR` directly.

``` r
library(reactR)
library(htmltools)

browsable(tagList(
  tags$div(id = "app"),
  tags$script(
  "
    ReactDOM.render(
      React.createElement(
        'h1',
        null,
        'Powered by React'
      ),
      document.getElementById('app')
    )
  "
  ),
  #add core-js first to work in RStudio Viewer
  html_dependency_corejs(),
  html_dependency_react()
))
```

`reactR` uses the `V8` package if available to transform `JSX` and
`ES2015` code with `babel`.

``` r
library(reactR)
library(htmltools)

browsable(
  tagList(
    tags$div(id = "app"),
    tags$script(
      babel_transform('ReactDOM.render(<h1>Powered By React/JSX</h1>,document.getElementById("app"))')
    ),
    # add core-js shim first for React in older versions of RStudio Viewer
    #html_dependency_corejs(),
    html_dependency_react()
  )
)
```

## Contributing and Code of Conduct

We welcome contributors and would love your participation. Please note
that this project is released with a [Contributor Code of
Conduct](https://github.com/react-R/reactR/blob/master/CONDUCT.md). By
participating in this project you agree to abide by the terms.
