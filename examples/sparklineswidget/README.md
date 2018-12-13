# react-sparklines HTMLWidget

This project demonstrates creating an [htmlwidget](https://www.htmlwidgets.org/) around the [react-sparklines](http://borisyankov.github.io/react-sparklines/) library.

A [Makefile](Makefile) is used to orchestrate building the Javascript implementation of the widget. The Javascript implementation file is [sparklineswidget.js](inst/htmlwidgets/sparklineswidget.js).

[Babel](https://babeljs.io/) is used to compile `sparklineswidget.js` into a Javascript file that should work in most modern browsers including IE11. [browserify](http://browserify.org/) is used to package the `react-sparklines` dependency from npm into the compiled Javascript.

# Building

Because this package includes Javascript source code that requires a compilation step, package installation is in two phases: Javascript tools build the Javascript, and the usual R tools build and install the package. The R package includes the built Javascript assets.

## Javascript Build Requirements

Building Javascript should work on macOS, Linux, and Windows. The following tools are necessary regardless of your platform:

- [Node.js](https://nodejs.org/en/)
- [Yarn](https://yarnpkg.com/en/)
- GNU Make: On macOS by default and installed easily on most Linux distributions. On Windows, consider using [chocolately](https://chocolatey.org/packages/make)

After you've installed Node.js and Yarn, run the following command to resolve dependencies:

```
yarn install
```

Now, run `make` to build `inst/htmlwidgets/sparklineswidget.js`:

```
make
```

Now that the Javascript is built, you can install the R package:

```
devtools::document()
devtools::install()
```

Finally you can try the example app by running [app.R](app.R).
