# demonstrate a quick example using the wonderful
#   new JavaScript implementation of Leland Wilkinson's
#   Grammar of Graphics

library(htmltools)
library(reactR)
library(tidyr)

# bizcharts from unpkg as umd
bizcharts <- htmlDependency(
  name = "bizcharts",
  version = "3.0.3",
  src = c(href = "https://unpkg.com/bizcharts@3.0.3/umd/"),
  script = "BizCharts.min.js"
)

# also need DataSet from unpkg
dataset <- htmlDependency(
  name = "dataset",
  version = "0.6.2",
  src = c(href = "https://unpkg.com/@antv/data-set@0.6.2/build"),
  script = "data-set.js"
)

# check dependencies
#  BizCharts should be available on window
browsable(
  tagList(
    reactR::html_dependency_react(offline=FALSE),
    bizcharts
  )
)

scr <- "
const { Chart, Axis, Geom, Tooltip } = window.BizCharts;
const data = [
{ year: '1951', sales: 38 },
{ year: '1952', sales: 52 },
{ year: '1956', sales: 61 },
{ year: '1957', sales: 145 },
{ year: '1958', sales: 48 },
{ year: '1959', sales: 38 },
{ year: '1960', sales: 38 },
{ year: '1962', sales: 38 },
];
const cols = {
'sales': {tickInterval: 20},
};
ReactDOM.render((
<Chart height={400} data={data} scale={cols} forceFit>
<Axis name='year' />
<Axis name='value' />
<Tooltip crosshairs={{type : 'y'}}/>
<Geom type='interval' position='year*sales' />
</Chart>
), document.getElementById('mountNode'));
"


browsable(
  tagList(
    reactR::html_dependency_react(offline=FALSE),
    dataset,
    bizcharts,
    HTML('<div id="mountNode"></div>'),
    tags$script(HTML(babel_transform(scr)))
  )
)
