#
# Object: server.R for DiamondPricePredictor
# Date: 2018-03-24
# Purpose: provide the backend functions for:
# o creating the model
# o running the options through the model
# o creating the graph

# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
data(diamonds)
library(ggplot2)

# prepdata for creating the model
#create a sample of data
set.seed(1000)
obs<-5000
sample<-diamonds[sample(1:length(diamonds$price), obs, replace=FALSE),]
fitPrice<-0.00

model.lm <- lm(price ~ (cut + carat + color + clarity + x + y + z), data=sample)
model.cccc <-lm(price ~(cut + carat + color + clarity), data=sample)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$table <- renderTable({
    a_clarity<-input$clarity
    a_color<-input$color
    a_cut<-input$cut
    a_carat<-as.double(input$carat)

    thisDiamond = data.frame(carat = a_carat
                             , cut = a_cut
                             , color = a_color
                             , clarity=a_clarity
                             )
    
    est<-predict(model.cccc, newdata = thisDiamond, interval="prediction", level=.95)
    est1<-as.data.frame(est)
    names(est1)<-c("Best Fit Price", "Lower Price", "Upper Price")
    fitPrice <- as.character(est1[,1])
    output$fit <- renderText({fitPrice})
    lower<-est1$`Lower Price`
    upper<-est1$`Upper Price`
    
    #display the graph based upon what the graphing selection is based upon
    graphText <-  toupper(input$graphBy)
    print(graphText)
        if (graphText == "CUT"){
            output$boxPlot<-renderPlot({
            boxplot(price~cut, data=filter(sample, price >= lower, price <= upper),ylab="PRICE", xlab=graphText)
            })
        }

        if (graphText == "COLOR"){
            output$boxPlot<-renderPlot({
            boxplot(price~color, data=filter(sample, price >= lower, price <= upper),ylab="PRICE", xlab=graphText)
          })
        }
    
        if (graphText == "CLARITY"){
          output$boxPlot<-renderPlot({
            boxplot(price~clarity, data=filter(sample, price >= lower, price <= upper),ylab="PRICE", xlab=graphText)
          })
        }
    
        
    est1
    })
  
  
  output$clarity <- renderText({input$clarity})
  output$color <- renderText({input$color})
  output$carat <- renderText({input$carat})
  output$cut <- renderText({input$cut})
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
