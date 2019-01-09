#' Create implementation scaffolding for a React.js-based HTML widget
#'
#' Add the minimal code required to implement a React.js-based HTML widget to an
#' R package.
#'
#' @param name Name of widget
#' @param npmPkg Optional \href{https://npmjs.com/}{NPM} package upon which this
#'   widget is based, as a two-element character vector of name and
#'   \href{https://docs.npmjs.com/files/package.json#dependencies}{version
#'   range}. If you specify this parameter the package will be added to the
#'   \code{dependency} section of the generated \code{package.json}.
#' @param edit Automatically open the widget's JavaScript source file after
#'   creating the scaffolding.
#'
#' @note This function must be executed from the root directory of the package
#'   you wish to add the widget to.
#'
#' @export
scaffoldReactWidget <- function(name, npmPkg = NULL, edit = interactive()){
  if (!file.exists('DESCRIPTION')){
    stop(
      "You need to create a package to house your widget first!",
      call. = F
    )
  }
  if (!file.exists('inst')){
    dir.create('inst')
  }
  package <- read.dcf('DESCRIPTION')[[1,"Package"]]
  addWidgetConstructor(name, package, edit)
  addWidgetYAML(name, edit)
  addPackageJSON(toDepJSON(npmPkg))
  addWebpackConfig(name)
  addWidgetJS(name, edit)
  addExampleApp(name)
  message("To install dependencies from npm run: yarn install")
  message("To build JavaScript run: yarn run webpack --mode=development")
}

toDepJSON <- function(npmPkg) {
  if (is.null(npmPkg)) {
    ""
  } else {
    do.call(sprintf, as.list(c('"%s": "%s"', npmPkg)))
  }
}

slurp <- function(file) {
  paste(readLines(
    system.file(file, package = 'reactR')
  ), collapse = "\n")
}

# Perform a series of pattern replacements on str.
# Example: renderTemplate("foo ${x} bar ${y} baz ${x}", list(x = 1, y = 2))
# Produces: "foo 1 bar 2 baz 1"
renderTemplate <- function(str, substitutions) {
  Reduce(function(str, name) {
    gsub(paste0("\\$\\{", name, "\\}"), substitutions[[name]], str)
  }, names(substitutions), str)
}

capName = function(name){
  paste0(toupper(substring(name, 1, 1)), substring(name, 2))
}

addWidgetConstructor <- function(name, package, edit){
  tpl <- slurp('templates/widget_r.txt')
  if (!file.exists(file_ <- sprintf("R/%s.R", name))){
    cat(
      renderTemplate(tpl, list(name = name, package = package, capName = capName(name))),
      file = file_
    )
    message('Created boilerplate for widget constructor ', file_)
  } else {
    message(file_, " already exists")
  }
  if (edit) fileEdit(file_)
}

addWidgetYAML <- function(name, edit){
  tpl <- "# (uncomment to add a dependency)
# dependencies:
#  - name:
#    version:
#    src:
#    script:
#    stylesheet:
"
  if (!file.exists('inst/htmlwidgets')){
    dir.create('inst/htmlwidgets')
  }
  if (!file.exists(file_ <- sprintf('inst/htmlwidgets/%s.yaml', name))){
    cat(tpl, file = file_)
    message('Created boilerplate for widget dependencies at ',
            sprintf('inst/htmlwidgets/%s.yaml', name)
    )
  } else {
    message(file_, " already exists")
  }
  if (edit) fileEdit(file_)
}

addPackageJSON <- function(npmPkg) {
  tpl <- renderTemplate(slurp('templates/widget_package.json.txt'), list(npmPkg = npmPkg))
  if (!file.exists('package.json')) {
    cat(tpl, file = 'package.json')
    message('Created package.json')
  } else {
    message("package.json already exists")
  }
}

addWebpackConfig <- function(name) {
  tpl <- renderTemplate(slurp('templates/widget_webpack.config.js.txt'), list(name = name))
  if (!file.exists('webpack.config.js')) {
    cat(tpl, file = 'webpack.config.js')
    message('Created webpack.config.js')
  } else {
    message("webpack.config.js already exists")
  }
}

addWidgetJS <- function(name, edit){
  tpl <- paste(readLines(
    system.file('templates/widget_js.txt', package = 'reactR')
  ), collapse = "\n")
  if (!file.exists('srcjs')){
    dir.create('srcjs')
  }
  if (!file.exists(file_ <- sprintf('srcjs/%s.js', name))){
    cat(renderTemplate(tpl, list(name = name)), file = file_)
    message('Created boilerplate for widget javascript bindings at ',
            sprintf('srcjs/%s.js', name)
    )
  } else {
    message(file_, " already exists")
  }
  if (edit) fileEdit(file_)
}

addExampleApp <- function(name) {
  tpl <- renderTemplate(slurp('templates/widget_app.R.txt'), list(name = name, capName = capName(name)))
  if (!file.exists('app.R')) {
    cat(tpl, file = 'app.R')
    message('Created example app.R')
  } else {
    message("app.R already exists")
  }
}

# invoke file.edit in a way that will bind to the RStudio editor
# when running inside RStudio
fileEdit <- function(file) {
  fileEditFunc <- eval(parse(text = "file.edit"), envir = globalenv())
  fileEditFunc(file)
}
