# use the very nice rgithub
# devtools::install_github("cscheid/rgithub")

get_react_latest <- function(){
  gsub(
    x=github::get.latest.release("facebook", "react")$content$tag_name,
    pattern="v",
    replacement=""
  )
}

get_babel_latest <- function(){
  gsub(
    x=github::get.latest.release("babel", "babel-standalone")$content$tag_name,
    pattern="release-",
    replacement=""
  )
}

# get newest react
download.file(
  url=sprintf(
    "https://unpkg.com/react@%s/umd/react.production.min.js",
    get_react_latest()
  ),
  destfile="./inst/www/react/react.min.js"
)

# get newest react dom
download.file(
  url=sprintf(
    "https://unpkg.com/react-dom@%s/umd/react-dom.production.min.js",
    get_react_latest()
  ),
  destfile="./inst/www/react/react-dom.min.js"
)

# get newest babel
download.file(
  url=sprintf(
    "https://unpkg.com/babel-standalone@%s/babel.min.js",
    get_babel_latest()
  ),
  destfile="./inst/www/babel/babel.min.js"
)

# write function with newest version
#  for use when creating dependencies
cat(
  sprintf(
    "#'@keywords internal\nreact_version <- function(){'%s'}\nbabel_version <- function(){'%s'}",
    get_react_latest(),
    get_babel_latest()
  ),
  file = "./R/meta.R"
)
