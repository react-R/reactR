library(htmltools)
library(reactR)
library(dplyr)

browsable(
  attachDependencies(
    tagList(
      mtcars %>%
        group_by(cyl) %>%
        summarize(hp = list(hp)) %>%
        knitr::kable(format="html") %>%
        HTML(),
      tags$script(HTML(
"
Array.prototype.map.call(
  document.querySelectorAll('tbody td:nth-child(2n+0)'),
  function(td){
    var data = td.innerText.split(',').map(function(d){return +d});
    var spk = React.createElement(
        ReactSparklines.Sparklines,
        {
          data: data,
          min: 0,
          max: 350,
          svgWidth: 400,
          svgHeight: 200
        },
        React.createElement(
          ReactSparklines.SparklinesBars,
{style:{stroke:'lightblue',strokeWidth:3, barWidth:15}}
        )
    );
    ReactDOM.render(spk, td);
  }
)
"
      ))
    ),
    list(
      html_dependency_react(),
      htmlDependency(
        name="react-sparklines",
        version="1.6.0",
        src=c(href="https://unpkg.com/react-sparklines"),
        script=""
      )
    )
  )
)


browsable(
  attachDependencies(
    tagList(
      tags$script(HTML(sprintf(
'
ReactDOM.render(
  React.createElement(
    ReactSparklines.Sparklines,
    {data:%s, svgHeight:300, svgWidth:500, min: 0, max:350, margin: 20},
    React.createElement(
      ReactSparklines.SparklinesBars,
      {style:{stroke:"lightblue",strokeWidth:2}}
    ),
    React.createElement(
      ReactSparklines.SparklinesLine,
      null
    )
  ),
  document.body
)
',
        jsonlite::toJSON(mtcars[which(mtcars$cyl==8),"hp"])
      )))
    )
    ,
    list(
      html_dependency_react(),
      htmlDependency(
        name="react-sparklines",
        version="1.6.0",
        #src = c(href="https://unpkg.com/react-sparklines"),
        #script = ""
        src=c(file="C:/Users/KENT/Dropbox/development/r/react-sparklines/build"),
        script="index.js"
      )
    )
  )
)
