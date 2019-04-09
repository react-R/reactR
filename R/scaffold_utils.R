slurp <- function(file) {
  paste(readLines(
    system.file(file, package = 'reactR')
  ), collapse = "\n")
}

# invoke file.edit in a way that will bind to the RStudio editor
# when running inside RStudio
fileEdit <- function(file) {
  fileEditFunc <- eval(parse(text = "file.edit"), envir = globalenv())
  fileEditFunc(file)
}

# Perform a series of pattern replacements on str.
# Example: renderTemplate("foo ${x} bar ${y} baz ${x}", list(x = 1, y = 2))
# Produces: "foo 1 bar 2 baz 1"
renderTemplate <- function(str, substitutions) {
  Reduce(function(str, name) {
    gsub(paste0("\\$\\{", name, "\\}"), substitutions[[name]], str)
  }, names(substitutions), str)
}

capitalize <- function(s) {
  gsub("^(.)", perl = TRUE, replacement = '\\U\\1', s)
}

toDepJSON <- function(npmPkgs) {
  if (is.null(npmPkgs)) {
    ""
  } else if (!length(names(npmPkgs))) {
    stop("Must specify npm package names in the names attributes of npmPkgs")
  } else {
    paste0(sprintf('"%s": "%s"', names(npmPkgs), npmPkgs), collapse = ",\n")
  }
}

# Wraps renderTemplate for convenient use from scaffold functions.
renderFile <- function(outputFile, templateFile, description = '', substitutions = list()) {
  if (!file.exists(outputFile)) {
    dir.create(dirname(outputFile), recursive = TRUE, showWarnings = FALSE)
    cat(renderTemplate(slurp(templateFile), substitutions), file = outputFile)
    message("Created ", description, " ", outputFile)
  } else {
    message(outputFile, " already exists")
  }
  outputFile
}

getPackage <- function() {
  if (!file.exists('DESCRIPTION')) {
    stop("The current directory doesn't contain a package. You're either in the wrong directory, or need to create a package to house your widget.", call. = FALSE)
  }
  read.dcf('DESCRIPTION')[[1,"Package"]]
}

# Constraining names prevents the user from encountering obscure CSS problems
# and JavaScript errors after scaffolding.
assertNameValid <- function(name) {
  if (!grepl(robustName, name)) {
    msg <- sprintf("Name '%s' is invalid, names must begin with an alphabetic character and must contain only alphabetic and numeric characters", name)
    stop(msg, call. = FALSE)
  }
}
