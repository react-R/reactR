library(htmltools)
library(reactR)
library(pipeR)

# run browserify standalone on blueprint core dist
#   and add to my forked github blueprint in docs as gh-pages
blueprint <- htmlDependency(
  name = "blueprint",
  version = "1.1.0",
  src = c(href="https://timelyportfolio.github.io/blueprint/"),
  script = c("blueprint.js","blueprint-table.js"),
  stylesheet = c("blueprint.css", "blueprint-table.css")
)

# make sure we have dependencies as expected
#  by adding react and blueprint to empty tagList
tagList() %>>%
  attachDependencies(
    list(html_dependency_react(offline=FALSE), blueprint)
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
const renderCell = (rowIndex, colIndex) => {
    var colname = Object.keys(mtcars)[colIndex]
    return <blueprintTable.Cell>{`${mtcars[colname][rowIndex]}`}</blueprintTable.Cell>
};

const columns = Object.keys(mtcars).map(function(colname) {
    return <blueprintTable.Column name={colname} renderCell={renderCell}/>
});

var tbl = <blueprintTable.Table numRows={mtcars["car"].length}>
  {columns}
</blueprintTable.Table>

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
  )
)%>>%
  attachDependencies(
    list(html_dependency_react(offline=FALSE), blueprint)
  ) %>>%
  browsable()
