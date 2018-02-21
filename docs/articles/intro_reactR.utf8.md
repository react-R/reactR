---
title: "Intro to reactR"
author: "Kent Russell"
date: "2018-02-20"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Intro to reactR}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

## Why reactR?

[`react`](https://facebook.github.io/react/) has become incredibly popular, and the ecosystem around `react` is robust.  `reactR` aims to allow `R` users to more easily incorporate `react` and `JSX`.

## Install

```
install.packages("reactR")

# for the latest development version
#  install from Github
# devtools::install_github("timelyportfolio/reactR")
```

## Quick Example

Let's use `react` to render a simple `h1` HTML element below.

<div id="react-heading-here"></div>


```r
library(reactR)
library(htmltools)

attachDependencies(
  tags$script(
  "
    ReactDOM.render(
      React.createElement(
        'h1',
        null,
        'Powered by React'
      ),
      document.getElementById('react-heading-here')
    )
  "
  ),
  html_dependency_react()
)
```

preserve152bd2f5d7127d49

## Blog Post

For more on how we can use R and React, see the blog post [React in R](http://www.jsinr.me/2017/11/19/react-in-r/).  Also, there are many more examples in the Github repo at [inst/examples](https://github.com/timelyportfolio/reactR/tree/master/inst/examples).

## Using JSX

[`JSX`](https://facebook.github.io/react/docs/jsx-in-depth.html) helps ease some of the burden caused by `React.createElement`.  `reactR` provides a `babel_transform()` function to use `JSX`.  Hopefully, in the future, we can convince RStudio to modify `htmltools` to work directly with `JSX` (see [issue](https://github.com/rstudio/htmltools/pull/72)).
