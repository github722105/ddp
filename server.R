#####
# Using shiny library.
#####
library(shiny)

#####
# Load file written for processing input.
#####
source("processing.R")
#
themes <- sort(unique(data$theme))

#####
# Create Shiny server
#####
shinyServer(
  function(input, output) {
    #
    output$setid <- renderText({input$setid})
    
    #
    output$address <- renderText({
        input$goButtonAdd
        isolate(paste("http://brickset.com/sets/", 
                input$setid, sep=""))
        
    })
    
    #
    openPage <- function(url) {
        return(tags$a(href=url, "Click here!", target="_blank"))
    }
    
    #
    output$inc <- renderUI({ 
        input$goButtonDirect
        isolate(openPage(paste("http://brickset.com/sets/", 
                               input$setid, sep="")))
    })
    
    
    #####
    # Set up initial reactive values
    #####
    values <- reactiveValues()
    values$themes <- themes
    
    #####
    # Generate checkbox for  event type.
    #####
    output$themesControl <- renderUI({
        checkboxGroupInput('themes', 'LEGO Themes:', 
                           themes, selected = values$themes)
    })
    
    #####
    # Ceate select-all button for observer.
    #####
    observe({
        if(input$selectAll == 0) return()
        #
        values$themes <- themes
    })
    
    #####
    # Add clearall button and its observer.
    #####
    observe({
        #
        if(input$clearAll == 0) return()
        #
        values$themes <- c() # empty list
    })

    #####
    # Prepare dataset to be used.
    #####
    dataTable <- reactive({
        groupByTheme(data, input$timeline[1], 
                     input$timeline[2], input$pieces[1],
                     input$pieces[2], input$themes)
    })

    #####
    # Define data tables.
    #####
    dataTableByYear <- reactive({
        groupByYearAgg(data, input$timeline[1], 
                    input$timeline[2], input$pieces[1],
                    input$pieces[2], input$themes)
    })

    #
    dataTableByPiece <- reactive({
        groupByYearPiece(data, input$timeline[1], 
                       input$timeline[2], input$pieces[1],
                       input$pieces[2], input$themes)
    })

    #
    dataTableByPieceAvg <- reactive({
        groupByPieceAvg(data, input$timeline[1], 
                        input$timeline[2], input$pieces[1],
                        input$pieces[2], input$themes)
    })

    #
    dataTableByPieceThemeAvg <- reactive({
        groupByPieceThemeAvg(data, input$timeline[1], 
                             input$timeline[2], input$pieces[1],
                             input$pieces[2], input$themes)
    })
    
    #####
    # Render data table.
    #####
    output$dTable <- renderDataTable({
        dataTable()
    } #, options = list(bFilter = FALSE, iDisplayLength = 50)
    )
    
    #
    output$themesByYear <- renderChart({
        plotThemesCountByYear(dataTableByYear())
    })

    #
    output$piecesByYear <- renderChart({
        plotPiecesByYear(dataTableByPiece())
    })

    #
    output$piecesByYearAvg <- renderChart({
        plotPiecesByYearAvg(dataTableByPieceAvg())
    })

    #
    output$piecesByThemeAvg <- renderChart({
        plotPiecesByThemeAvg(dataTableByPieceThemeAvg())
    })
    
  } 
  # 
)
