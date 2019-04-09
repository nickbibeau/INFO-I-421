library(shiny)
library(ggplot2)
data(diamonds, package='ggplot2')

shinyServer(function(input, output, session)
{
  output$HistPlot <- renderPlot({
    ggplot(diamonds, aes_string(x=input$VarToPlot)) +
      geom_histogram(bins=30)
  })
})
