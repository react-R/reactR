library(reactR)
library(htmltools)
library(pipeR)
library(tibble)

react_virt <-  htmlDependency(
  name = "react-virtualized",
  version = "9.7.3",
  src = c(href = "https://unpkg.com/react-virtualized@9.7.3/"),
  script = "dist/umd/react-virtualized.js",
  stylesheet = "styles.css"
)

rand_tbl <- tibble(
  id = 1:10000,
  data = lapply(1:10000, function(d){runif(10)})
)

js_data <- tags$script(HTML(
sprintf(
'
var data = %s;
',
  jsonlite::toJSON(rand_tbl, dataframe="rows")
)
))

js <- tags$script(HTML(babel_transform(
sprintf(
"
function rowGetter(params) {
  return data[params.index];
}

function rowRenderCallback(x) {
  $('.sparkline').sparkline('html',{width:200})
}

class App extends React.Component {
  render() {
    return (
      <ReactVirtualized.Table
        rowGetter={rowGetter}
        rowCount={data.length}
        height={300}
        width={400}
        rowHeight={40}
        headerHeight={30}
        onRowsRendered={rowRenderCallback}
      >

        <ReactVirtualized.Column
          label='Index'
          cellDataGetter={
            ({ columnData, dataKey, rowData }) => rowData.id
          }
          dataKey='index'
          width={50}
        />

        <ReactVirtualized.Column
          disableSort
          label='Data'
          dataKey='data'
          cellRenderer={
            ({ cellData, columnData, dataKey, rowData, rowIndex }) => <span className='sparkline' values={cellData.join(',')}></span>
          }
          flexGrow={1}
          width={200}
        />

      </ReactVirtualized.Table>
    )
  }

}

const app = document.getElementById('rvtable');
ReactDOM.render(<App />, app);
"
)
)))

tagList(
  tags$div(id="rvtable"),
  js_data,
  js,
  html_dependency_react(),
  react_virt,
  htmlwidgets::getDependency('sparkline')[2:3]
) %>>%
  browsable()

