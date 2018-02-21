library(htmltools)
library(reactR)
library(pipeR)

# run browserify standalone on blueprint core dist
#   and add to my forked github blueprint in docs as gh-pages
blueprint <- htmlDependency(
  name = "blueprint",
  version = "1.1.4",
  src = c(href="https://unpkg.com/@blueprintjs/"),
  script = c("core/dist/core.bundle.js","table/dist/table.bundle.js"),
  stylesheet = c("core/lib/css/blueprint.css", "table/lib/css/table.css")
)

# make sure we have dependencies as expected
#  by adding react and blueprint to empty tagList
tagList(
  html_dependency_react(offline=FALSE),
  blueprint
) %>>%
  browsable()


# now let's try to do a React blueprint table
#  http://blueprintjs.com/docs/#components.table-js
tagList(
  tags$div(id="app-table", style = "width:700px; height:500px;"),
  tags$script(
    HTML(
      babel_transform(
        sprintf(
'
const mtcars = %s;
const cellRenderer = (rowIndex, colIndex) => {
    var colname = Object.keys(mtcars)[colIndex]
    return <Blueprint.Table.Cell>{`${mtcars[colname][rowIndex]}`}</Blueprint.Table.Cell>
};

const columns = Object.keys(mtcars).map(function(colname) {
    return <Blueprint.Table.Column name={colname} renderCell={cellRenderer}/>
});

var tbl = <Blueprint.Table.Table numRows={mtcars["car"].length}>
    {columns}
</Blueprint.Table.Table>

ReactDOM.render(tbl, document.querySelector("#app-table"));
'
          ,
          jsonlite::toJSON(
            tibble::rownames_to_column(mtcars,var="car"),
            dataframe="columns",
            auto_unbox=TRUE
          )
        )
      )
    )
  ),
  htmlDependency(
    name="classnames",
    version="2.2.5",
    src = c(href="https://unpkg.com/classnames"),
    script = ""
  ),
  html_dependency_react(),
  blueprint
) %>>%
  browsable()



# now let's try to do a React blueprint table
#  http://blueprintjs.com/docs/#components.table-js
tagList(
  tags$div(id="app-table", style = "width:700px; height:500px;"),
  tags$script(
    HTML(
      babel_transform(
"

var tbl = <Blueprint.Table.Table numRows={5}>
<Blueprint.Table.Column />
<Blueprint.Table.Column />
<Blueprint.Table.Column />
</Blueprint.Table.Table>

ReactDOM.render(tbl, document.querySelector('#app-table'));
"

      )
    )
  ),
  htmlDependency(
    name="classnames",
    version="2.2.5",
    src = c(href="https://unpkg.com/classnames"),
    script = ""
  ),
  html_dependency_react(),
  blueprint
) %>>%
  browsable()
