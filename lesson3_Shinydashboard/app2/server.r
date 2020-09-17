library(shiny)
library(ggplot2)
library(leaflet)
library(shinydashboard)
library(magrittr)
library(shinyjs)

data("diamonds", package = "ggplot2")

root <- rprojroot::find_rstudio_root_file()

pizza <- jsonlite::fromJSON(file.path(root, "/lesson2_Flexdashboard/favoritespots.json")) %>% 
  tidyr::unnest()



shinyServer(function(input, output, session)
{
  output$HistPlot <- renderPlot({
    ggplot(diamonds, aes_string(x=input$VarToPlot))+ geom_histogram(bins = input$Histbins)
  })
  
  output$Densplot <- renderPlot({
    ggplot(diamonds, aes_string(x=input$VarToPlot))+geom_density(fill= "gray50")
  })
  
  output$theTable <- DT::renderDataTable({
    DT::datatable(diamonds, rownames = FALSE)
  },
  server = TRUE)
  
  theData <- reactive({
    if(is.null(input$fileUpload))
    {
      
      return(NULL)
    }
    
    readr::read_csv(input$fileUpload$datapath)
  })
  
  observe({
    
    updateCheckboxGroupInput(
      session = session,
      inputId = "colSelection",
      label = "Please choose column to display",
      choices = names(theData()),
      selected = names(theData())
    )
  })
  
  output$fileTable <- DT::renderDataTable({
    DT::datatable(theData()[,input$colSelection, drop = FALSE], rownames = FALSE)
  },
  server = TRUE)
  
  observeEvent(input$swapButton, {
    shinyjs::toggle(id='LeftText')
    shinyjs::toggle(id='RightText')
  })
  
  observeEvent(input$AlertButton, {
    shinyjs::alert('This is an alert')
  })
  
  observe({
    shinyjs::toggle(id='LuckyNumber', condition = input$NumGuest == 5)
    shinyjs::toggleState(id='alertButton', condition = input$NumGuest ==1)
  })
  
  output$PizzaTable <- DT::renderDataTable({
    DT::datatable(
      pizza,
      rownames = FALSE,
      options = list(scrollx = FALSE)
    )
  })
  
  output$PizzaMap <- renderLeaflet({
    leaflet(
        pizza %>% dplyr::slice(as.integer(input$PizzaTable_rows_selected))
      ) %>% 
        addTiles() %>% 
        addMarkers(
          lng = ~longitude,
          lat = ~latitude,
          popup = ~Name
      )
    
  })
    
  output$Report <- downloadHandler(
    filename = 'report.htlm',
    content = function(file){
      tempFile <- file.path(tempdir(), 'report.Rmd')
      file.copy('report.Rmd', to=tempFile, overwrite = TRUE)
      
      chosen <- pizza %>% 
        dplyr::slice(as.integer(input$PizzaTable_rows_selected)) %>% 
        dplyr::pull(Name)
      
      params <- list(places=chosen)
      
      rmarkdown::render(tempFile, output_file = file,  params= params, 
                        envir = new.env(parent = globalenv()))
    }
  )
  
})
