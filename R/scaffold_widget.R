#' Create implementation scaffolding for a React.js-based HTML widget
#'
#' Add the minimal code required to implement a React.js-based HTML widget to an
#' R package.
#'
#' @param name Name of widget
#' @param npmPkgs Optional \href{https://npmjs.com/}{NPM} packages upon which
#'   this widget is based which will be used to populate \code{package.json}.
#'   Should be a named list of names to
#'   \href{https://docs.npmjs.com/files/package.json#dependencies}{versions}.
#' @param edit Automatically open the widget's JavaScript source file after
#'   creating the scaffolding.
#'
#' @note This function must be executed from the root directory of the package
#'   you wish to add the widget to.
#'
#' @export
scaffoldReactWidget <- function(name, npmPkgs = NULL, edit = interactive()){
  assertNameValid(name)
  package <- getPackage()

  addWidgetConstructor(name, package, edit)
  addWidgetYAML(name, edit)
  addPackageJSON(toDepJSON(npmPkgs))
  addWebpackConfig(name)
  addWidgetJS(name, edit)
  addExampleApp(name)

  usethis::use_build_ignore(c("node_modules", "srcjs", "app.R", "package.json", "webpack.config.js", "yarn.lock"))
  usethis::use_git_ignore(c("node_modules"))
  lapply(c("htmltools", "htmlwidgets", "reactR"), usethis::use_package)

  message("To install dependencies from npm run: yarn install")
  message("To build JavaScript run: yarn run webpack --mode=development")
}

addWidgetConstructor <- function(name, package, edit){
  file <- renderFile(
    sprintf("R/%s.R", name),
    "templates/widget_r.txt",
    "boilerplate for widget constructor",
    list(
      name = name,
      package = package,
      capName = capitalize(name)
    )
  )
  if (edit) fileEdit(file)
}

addWidgetYAML <- function(name, edit){
  file <- renderFile(
    sprintf('inst/htmlwidgets/%s.yaml', name),
    "templates/widget_yaml.txt",
    "boilerplate for widget dependencies"
  )
  if (edit) fileEdit(file)
}

addPackageJSON <- function(npmPkgs) {
  renderFile(
    'package.json',
    'templates/package.json.txt',
    'project metadata',
    list(npmPkgs = npmPkgs)
  )
}

addWebpackConfig <- function(name) {
  renderFile(
    'webpack.config.js',
    'templates/webpack.config.js.txt',
    'webpack configuration',
    list(
      name = name,
      outputPath = 'inst/htmlwidgets'
    )
  )
}

addWidgetJS <- function(name, edit){
  file <- renderFile(
    sprintf('srcjs/%s.jsx', name),
    'templates/widget_js.txt',
    'boilerplate for widget JavaScript bindings',
    list(name = name)
  )
  if (edit) fileEdit(file)
}

addExampleApp <- function(name) {
  renderFile(
    'app.R',
    'templates/widget_app.R.txt',
    'example app',
    list(
      name = name,
      capName = capitalize(name)
    )
  )
}
