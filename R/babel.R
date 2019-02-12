#' Transform Code with Babel
#'
#' Helper function to use \code{V8} with \code{Babel} so we can
#' avoid a JSX transformer with using \code{reactR}.
#'
#' @param code \code{character}
#'
#' @return transformed \code{character}
#' @export
#'
#' @examples
#' \dontrun{
#' library(reactR)
#' babel_transform('<div>react div</div>')
#' }
babel_transform <- function(code=""){
  stopifnot(requireNamespace("V8"), is.character(code))

  ctx <- V8::v8()
  ctx$source(
    system.file(
      "www/babel/babel.min.js",
      package = "reactR"
    )
  )
  ctx$assign('code', code)
  ctx$get('Babel.transform(code,{ presets: [["es2015", {modules: false}],"react"] }).code')
}
