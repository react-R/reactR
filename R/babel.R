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
#' library(reactR)
#' babel_transform('<div>react div</div>')
babel_transform <- function(code=""){
  stopifnot(require(V8), is.character(code))

  ctx <- v8()
  ctx$source('https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/6.10.3/babel.min.js')
  ctx$assign('code', code)
  ctx$get('Babel.transform(code,{ presets: ["es2015","react"] }).code')
}
