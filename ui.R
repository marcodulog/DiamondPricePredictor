#
# Object: ui.R for DiamondPricePredictor
# Date: 2018-03-24
# PUrpose: Create an application that predicts the price of a diamond based upon 
# a sample of data provided by the ggplot2 dataset using a simple linear model containing
# cut, clarity, carat and color
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

#create a sample of data
set.seed(1000)
obs<-5000
sample<-diamonds[sample(1:length(diamonds$price), obs, replace=FALSE),]
# Define lists for values
cut.list <- list("Fair"="Fair"
                 , "Good" = "Good"
                 , "Very Good" = "Very Good"
                 , "Premium" = "Premium"
                 , "Ideal" = "Ideal")
color.list <-list("J - Worst" = "J"
                  , "I" = "I"
                  , "H" = "H"
                  , "G" = "G"
                  , "F" = "F"
                  , "E" = "E"
                  , "D - Best" = "D")
clarity.list<-list("I1 (worst)"= "I1"
                   , "SI1" = "SI1"
                   , "SI2" = "SI2"
                   , "VS1" = "VS1"
                   , "VS2" = "VS2"
                   , "VVS1" = "VVS1"
                   , "VVS2" = "VVS2"
                   , "IF (best)" = "IF")
select.list<-list("Cut"="cut"
                  , "Clarity"="clarity"
                  , "Color"="color")


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Diamond Price Predictor"),
  
  # Sidebar with inputs for variables needed to predict price 
  sidebarLayout(
    sidebarPanel(
      
       selectInput("cut", label="Cut:", choices=cut.list),
       selectInput("clarity", label="Clarity:", choices=clarity.list),
       selectInput("color", label="Color:", choices=color.list),

       selectInput("graphBy", label="Graph By:", choices=select.list, selected="cut"),
       sliderInput("carat",
                   "Carat:",
                   min = 0.2,
                   max = 5.01,
                   value = 5.01/2)
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       h4("The best price of a diamond based upon your choices:"),
       htmlOutput("fit"),
       tags$hr(),

       h4("Table of Fit, Lower and Upper Price Ranges:"),
       tableOutput("table"),
       
       h4("Upper and lower range comparison:"),
       plotOutput("boxPlot")
    )
  )
))
