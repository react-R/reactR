library(shiny)
library(sparklineswidget)
library(colourpicker)
# devtools::install_github("hadley/shinySignals")
library(shinySignals)

ui <- fluidPage(
  titlePanel("React Sparklines"),
  sparklineswidgetOutput('sparklines'),
  colourInput("color_curve", "Curve color", "#253e56"),
  colourInput("color_spots", "Spots color", "#56b45d")
)

nextWindow <- function(prev = round(runif(100, 0, 10)), t = NULL) {
  c(prev[-1], round(runif(1, 0, 10)))
}

server <- function(input, output, session) {

  data <- reducePast(fps(1), nextWindow, nextWindow())

  output$sparklines <- renderSparklineswidget(
    sparklineswidget(data = data(),
      curve(color = input$color_curve),
      spots(style = list(fill = input$color_spots)),
      reference_line(type = "avg")
    )
  )
}

shinyApp(ui, server)
