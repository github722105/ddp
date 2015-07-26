#####
# Load required libraries.
#####
require(data.table)
# 
library(sqldf)
#
library(rCharts)
#
library(dplyr)
#
library(DT)
#

#####
# Read data from input files.
#####
data <- fread("./sets.csv")
#
head(data)
#
setnames(data, "t1", "theme")
setnames(data, "descr", "name")
setnames(data, "set_id", "setId")
# 
#####
# Exploratory data analysis
#####
#####0
sum(is.na(data)) 
#####10036
length(unique(data$setId)) 
#####1950 - 2015
table(data$year) 
#####64
length(table(data$year)) 
years <- sort(unique(data$year))
#####100
length(table(data$theme)) 
themes <- sort(unique(data$theme))



#####
# Group by year Piece results
#####
groupByYearPiece <- function(dt, minYear, maxYear, minPiece,
                             maxPiece, themes) {
    #
    result <- dt %>% filter(year >= minYear, year <= maxYear,
                            pieces >= minPiece, pieces <= maxPiece,
                            theme %in% themes) 
    #
    return(result)
}

#####
# Group by theme.
#####
groupByTheme <- function(dt, minYear, maxYear, 
                         minPiece, maxPiece, themes) {
    #
    dt <- groupByYearPiece(dt, minYear, maxYear, minPiece,
                           maxPiece, themes) 
    #
    result <- datatable(dt, options = list(iDisplayLength = 50))
    return(result)
}

#####
# Aggregate by year.
#####
groupByYearAgg <- function(dt, minYear, maxYear, minPiece,
                           maxPiece, themes) {
    dt <- groupByYearPiece(dt, minYear, maxYear, minPiece,
                      maxPiece, themes)
    #
    result <- dt %>% 
            group_by(year)  %>% 
            summarise(count = n()) %>%
            arrange(year)
    return(result)
}

#####
# Aggregate by grouping by average of  pieces.
#####
groupByPieceAvg <- function(dt,  minYear, maxYear, minPiece,
                            maxPiece, themes) {
    dt <- groupByYearPiece(dt, minYear, maxYear, minPiece,
                           maxPiece, themes)
    #
    result <- dt %>% 
            group_by(year) %>% 
            summarise(avg = mean(pieces)) %>%
            arrange(year)
    return(result)      
}

##### 
# Average by Piece Theme pieces.
#####
groupByPieceThemeAvg <- function(dt,  minYear, maxYear, minPiece,
                                 maxPiece, themes) {
    #
    dt <- groupByYearPiece(dt, minYear, maxYear, minPiece,
                           maxPiece, themes)
    #
    result <- dt %>% 
            group_by(theme) %>%
            summarise(avgPieces = mean(pieces)) %>%
            arrange(theme)
    #
    return(result)
}

#####
# Plot number of themes by year
#####
plotThemesCountByYear <- function(dt, dom = "themesByYear", 
                                  xAxisLabel = "Year",
                                  yAxisLabel = "Number of Themes") {
    themesByYear <- nPlot(
        count ~ year,
        data = dt,
        #type = "lineChart", 
        type = "multiBarChart",
        dom = dom, width = 650
    )
    themesByYear$chart(margin = list(left = 100))
    themesByYear$yAxis(axisLabel = yAxisLabel, width = 80)
    themesByYear$xAxis(axisLabel = xAxisLabel, width = 70)
    themesByYear
}

#####
# ' Plot number of pieces by year.
#####

plotPiecesByYear <- function(dt, dom = "piecesByYear", 
                             xAxisLabel = "Year", 
                             yAxisLabel = "Number of Pieces") {
    piecesByYear <- nPlot(
        pieces ~ year,
        data = dt,
        #         group = "year",
        type = "scatterChart",
        dom = dom, width = 650
    )
    #####
    #
    #####
    piecesByYear$chart(margin = list(left = 100), 
                       showDistX = TRUE,
                       showDistY = TRUE)
    piecesByYear$chart(color = c('green', 'orange', 'blue'))
    piecesByYear$chart(tooltipContent = "#! function(key, x, y, e){ 
  return '<h5><b>Set Name</b>: ' + e.point.name + '<br>'
    + '<b>Set ID</b>: ' + e.point.setId  
    + '</h5>'
    
} !#") # data[data$pieces==y&data$year==x, ]$name
    piecesByYear$yAxis(axisLabel = yAxisLabel, width = 80)
    piecesByYear$xAxis(axisLabel = xAxisLabel, width = 70)
    #     piecesByYear$chart(useInteractiveGuideline = TRUE)
    piecesByYear
}

#####
# Plot number of average pieces by year
#####
plotPiecesByYearAvg <- function(dt, dom = "piecesByYearAvg", 
                             xAxisLabel = "Year",
                             yAxisLabel = "Number of Pieces") {

    piecesByYearAvg <- nPlot(
        avg ~ year,
        data = dt,
        type = "lineChart",
        dom = dom, width = 650
    )
    piecesByYearAvg$chart(margin = list(left = 100))
    piecesByYearAvg$chart(color = c('orange', 'blue', 'green'))
    piecesByYearAvg$yAxis(axisLabel = yAxisLabel, width = 80)
    piecesByYearAvg$xAxis(axisLabel = xAxisLabel, width = 70)
    piecesByYearAvg
    
}

##### 
#Plot number of average pieces by theme
#####
plotPiecesByThemeAvg <- function(dt, dom = "piecesByThemeAvg", 
                                 xAxisLabel = "Themes", 
                                 yAxisLabel = "Number of Pieces") {
    #
    piecesByThemeAvg <- nPlot(
        avgPieces ~ theme,
        data = dt,
        type = "multiBarChart",
        dom = dom, width = 650
    )
    #
    piecesByThemeAvg$chart(margin = list(left = 100))
    #
    piecesByThemeAvg$chart(color = c('pink', 'blue', 'green'))
    #
    piecesByThemeAvg$yAxis(axisLabel = yAxisLabel, width = 80)
    #
    piecesByThemeAvg$xAxis(axisLabel = xAxisLabel, width = 200,
                           rotateLabels = -20, height = 200)
    #
    piecesByThemeAvg
    
}
