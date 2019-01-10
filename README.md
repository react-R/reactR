[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/reactR)](https://cran.r-project.org/package=reactR)
[![Travis-CI Build Status](https://travis-ci.org/react-R/reactR.svg?branch=master)](https://travis-ci.org/react-R/reactR)

<img style="height:100px;" alt="react-R logo" src="inst/logos/reactR-logo.png"/>

# reactR

A set of convenience function with local dependencies for using [`React`](https://facebook.github.io/react) in `R`.  This is modeled after the `html_dependency_*` functions from RStudio's [`rmarkdown`](https://github.com/rstudio/rmarkdown) package.

## Installation

You can install reactR from github with:

```R
# install.packages("devtools")
devtools::install_github("react-R/reactR")
```

## Example

```R
library(reactR)
library(htmltools)

browsable(tagList(
  tags$script(
  "
    ReactDOM.render(
      React.createElement(
        'h1',
        null,
        'Powered by React'
      ),
      document.body
    )
  "
  ),
  #add core-js first to work in RStudio Viewer
  html_dependency_corejs(),
  html_dependency_react()
))
```

`reactR` also uses `V8` if available to transform `JSX` and `ES2015` code.

```R
library(reactR)
library(htmltools)

browsable(
  tagList(
    tags$script(
      babel_transform('ReactDOM.render(<h1>Powered By React/JSX</h1>,document.body)')
    ),
    # add core-js shim first for React in RStudio Viewer
    html_dependency_corejs(),
    html_dependency_react()
  )
)
```

## Contributing and Code of Conduct

I welcome contributors.  Help make this package great.  Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
