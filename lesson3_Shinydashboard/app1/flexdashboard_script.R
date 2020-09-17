library(ggplot2)
library(dplyr)
# Shiny economics module 

# UI function

economicUI <- fluidPage(
  
    titlePanel("Widget"),
 
    fillCol(height = 400, flex = c(1,1), 
          inputPanel(
            selectInput(inputId = "variable",
                        label = "Select a column to display",
                        choices = colnames(economics)),
            numericInput(inputId ="jobless", 
                        label="Number of unemployed >=",
                        value=6000,min=6000, max=max(economics$unemploy),step=1000)
                      ),
        
          plotOutput("econoplot",height = "150%")
          #leafletOutput()
          #dataTableOutput()
          )
    )
    

# Server function
economic<- function(input,output,session) {
  
  dataset <- reactive({filter(economics,unemploy>=input$jobless)})
                                 
  output$econoplot <- renderPlot({
    ggplot(dataset(),aes_string(x=input$variable))+geom_histogram()})
}
shinyApp(ui=economicUI,server=economic)