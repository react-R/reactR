# use the very nice rgithub
# devtools::install_github("cscheid/rgithub")

get_react_latest <- function(){
  gsub(
    x=github::get.latest.release("facebook", "react")$content$tag_name,
    pattern="v",
    replacement=""
  )
}

# get newest react
download.file(
  url=sprintf(
    "https://unpkg.com/react@%s/dist/react.min.js",
    get_react_latest()
  ),
  destfile="./inst/www/react/react.min.js"
)

# get newest react dom
download.file(
  url=sprintf(
    "https://unpkg.com/react-dom@%s/dist/react-dom.min.js",
    get_react_latest()
  ),
  destfile="./inst/www/react/react-dom.min.js"
)

# write function with newest version
#  for use when creating dependencies
cat(
  sprintf("#'@keywords internal\nreact_version <- function(){'%s'}", get_react_latest()),
  file = "./R/meta.R"
)
