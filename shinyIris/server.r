library(shiny)
library(ggplot2)
library(tidyverse)

cpu <- read_csv("https://www.iun.edu/~cisjw/ds/files/data/cpu.csv", na = "NA")



shinyServer(function(input, output, session)
{
  output$HistPlot <- renderPlot({
    ggplot(cpu, aes_string(x=input$VarToPlot)) +
      geom_histogram(bins=30)
  })
})
