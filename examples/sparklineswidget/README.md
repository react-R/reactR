# react-sparklines HTMLWidget

This example demonstrates creating an [htmlwidget](https://www.htmlwidgets.org/) wrapper around the [react-sparklines](http://borisyankov.github.io/react-sparklines/) library.

# Building

Because this package includes Javascript source code that requires a compilation step, package installation is in two phases: Javascript tools build the Javascript, and R tools build and install the package. The R package includes the built Javascript files in the `inst/` directory.

## Javascript Build Requirements

Building Javascript should work on macOS, Linux, and Windows. The following tools are necessary regardless of your platform:

- [Node.js](https://nodejs.org/en/)
- [Yarn](https://yarnpkg.com/en/)

## R Build Requirements

You should install the parent `reactR` package if you haven't, as this widget depends on it.

## Development Workflow

After you've installed Node.js and Yarn, run the following command to resolve and download dependencies:

```
yarn install
```

Now, run `yarn` to build `inst/htmlwidgets/sparklineswidget.js`:

```
yarn run webpack --mode=development
```

> To run `yarn webpack` automatically whenever sources change, use the command `yarn run webpack --mode=development --watch`

Now that the Javascript is built, you can install the R package:

```
devtools::document()
devtools::install()
```

Finally you can try the example app by running [app.R](app.R).
