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

# Workaround for https://github.com/r-lib/usethis/issues/643, otherwise would
# use usethis::use_build_ignore
buildIgnoreDirs <- function(dirs) {
  usethis::write_union(".Rbuildignore", paste0("^", dirs))
}
