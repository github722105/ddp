#####
# Load the required and necessary libraries and modules.
#####
#
library(dplyr)
#####
library(shiny)
#
library(DT)
#####
library(BH)
#
library(rCharts)
#####
require(markdown)
#
require(data.table)
#

#####
# Define the shiny user interface.
#####
shinyUI(
    navbarPage("LEGO Set Visualizer", 
    #####
    # Create the navigation bar of a multiple-page user interface.
    #####
        tabPanel("Explore the Data",
        #
             sidebarPanel(
                #
                sliderInput("timeline", 
                            "Timeline:", 
                            min = 1950,
                            max = 2015,
                            value = c(1996, 2015)),
                #
                sliderInput("pieces", 
                            "Number of Pieces:",
                            min = -1,
                            max = 5922,
                            value = c(271, 2448) 
                ),
                            #format = "####"),
                uiOutput("themesControl"), # the id
                #
                actionButton(inputId = "clearAll", 
                             label = "Clear selection", 
                             icon = icon("square-o")),
                #
                actionButton(inputId = "selectAll", 
                             label = "Select all", 
                             icon = icon("check-square-o"))
        
             ),
             #
             mainPanel(
                 tabsetPanel(
                   # For the data.
                   tabPanel(p(icon("table"), "Dataset"),
                            dataTableOutput(outputId="dTable")
                   ),
                   tabPanel(p(icon("line-chart"), "Visualize the Data"), 
                            #
                            h4('Number of Themes by Year', align = "center"),
                            #
                            showOutput("themesByYear", "nvd3"),
                            #
                            h4('Number of Pieces by Year', align = "center"),
                            #
                            h5('Please hover over each point to see the Set Name and ID.', 
                               align ="center"),
                            #
                            showOutput("piecesByYear", "nvd3"),
                            #
                            h4('Number of Average Pieces by Year', align = "center"),
                            #
                            showOutput("piecesByYearAvg", "nvd3"),
                            #
                            h4('Number of Average Pieces by Theme', align = "center"),
                            #
                            showOutput("piecesByThemeAvg", "nvd3")
                   )
                 )
            )     
        ),
    
        #####
        # Define the main panel for the Brickset website.
        #####
        tabPanel(p(icon("search"), "LookUp on Brickset Website"),
             #
             mainPanel(
                 #
                 h4("The page popped-up is the LEGO set database on Brickset.com."),
                 #
                 h4("Step 1. Please type the Set ID below and press the 'Go!' button:"),
                 #
                 textInput(inputId="setid", label = "Input Set ID"),
                 #
                 #p('Output Set ID:'),
                 #
                 #textOutput('setid'),
                 #
                 actionButton("goButtonAdd", "Go!"),
                 #
                 h5('Output Address:'),
                 #
                 textOutput("address"),
                 #
                 p(""),
                 #
                 h4("Step 2. Please click the button below. 
                    The link to the Set's page is being generated."),
                 #
                 p(""),
                 #
                 actionButton("goButtonDirect", "Generate Link Below!"),
                 #
                 p(""),
                 #
                 htmlOutput("inc"),
                 #
             )         
        ),
        
        #####
        # Create About tab panel.
        #####
        tabPanel("About",
                 mainPanel(
                   includeMarkdown("about.md")
                 )
        )
    )
  
)
