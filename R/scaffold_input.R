#' Create implementation scaffolding for a React.js-based Shiny input.
#'
#' Add the minimal code required to implement a React.js-based Shiny input to an
#' R package.
#'
#' @param name Name of input
#' @param npmPkgs Optional \href{https://npmjs.com/}{NPM} packages upon which
#'   this input is based which will be used to populate \code{package.json}.
#'   Should be a named list of names to
#'   \href{https://docs.npmjs.com/files/package.json#dependencies}{versions}.
#' @param edit Automatically open the input's source files after creating the
#'   scaffolding.
#'
#' @note This function must be executed from the root directory of the package
#'   you wish to add the input to.
#'
#' @export
scaffoldReactShinyInput <- function(name, npmPkgs = NULL, edit = interactive()) {
  assertNameValid(name)
  package <- getPackage()

  file <- renderFile(
    sprintf("R/%s.R", name),
    "templates/input_r.txt",
    "boilerplate for input constructor",
    list(
      name = name,
      capName = capitalize(name),
      package = package
    )
  )
  if (edit) fileEdit(file)

  renderFile(
    'package.json',
    'templates/package.json.txt',
    'project metadata',
    list(npmPkgs = toDepJSON(npmPkgs))
  )

  renderFile(
    'webpack.config.js',
    'templates/webpack.config.js.txt',
    'webpack configuration',
    list(
      name = name,
      outputPath = sprintf("inst/www/%s/%s", package, name)
    )
  )

  renderFile(
    sprintf('srcjs/%s.jsx', name),
    'templates/input_js.txt',
    'JavaScript implementation',
    list(
      name = name,
      package = package
    )
  )

  renderFile(
    'app.R',
    'templates/input_app.R.txt',
    'example app',
    list(
      name = name,
      package = package
    )
  )

  usethis::use_build_ignore(c("node_modules", "srcjs", "app.R", "package.json", "webpack.config.js", "yarn.lock"))
  usethis::use_git_ignore(c("node_modules"))
  lapply(c("htmltools", "shiny", "reactR"), usethis::use_package)

  message("To install dependencies from npm run: yarn install")
  message("To build JavaScript run: yarn run webpack --mode=development")
}

