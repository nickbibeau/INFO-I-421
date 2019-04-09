library(shiny)
library(shinydashboard)
library(htmltools)
dashHeader <- dashboardHeader(title='Simple Dashboard')
dashSidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Home', tabName='HomeTab',
             icon=icon('dashboard')
    ),
    menuItem('Graphs', tabName='GraphsTab',
             icon=icon('bar-chart-o')
    )
  )
)
dashBody <- dashboardBody(
  tabItems(
    tabItem(tabName='HomeTab',
            h1('Landing Page!'),
            p('This is the landing page for the dashboard.'),
            em('This text is emphasized')
    ),
    tabItem(tabName='GraphsTab',
            h1('Graphs!'),
            selectInput(inputId='VarToPlot',
                        label='Choose a Variable',
                        choices=c('MYCT', 'MMIN',
                                  'MMAX', 'CACH', 'CHMIN', 'CHMAX', 'PERFORMANCE'),
                        selected='MYCT'),
            plotOutput(outputId='HistPlot')
    )
  )
)
dashboardPage(
  header=dashHeader,
  sidebar=dashSidebar,
  body=dashBody,
  title='Example Dashboard'
)