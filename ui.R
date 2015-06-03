
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(pageWithSidebar(
  headerPanel('Analyse Consommation'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', listeBanque, selected = listeBanque),
    selectInput('ycol', 'Y Variable', names(out$sssrv),
                selected=names(iris)[[2]]),
    numericInput('clusters', 'Cluster count', 3,
                 min = 1, max = 9)
  ),
  mainPanel(
    plotOutput('plot1')
  )
)
)
