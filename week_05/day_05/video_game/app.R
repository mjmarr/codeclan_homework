library(shinydashboard)
library(tidyverse)

games_sales <- CodeClanData::game_sales
platforms <- unique(games_sales$platform)
genres <- unique(games_sales$genre)
publishers <- unique(games_sales$publisher)

games_per_genre <- games_sales %>% 
  group_by(genre) %>% 
  summarize(number_of_games_genre = n()) %>% 
  arrange(genre)

#ui stuff

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Data View", tabName = "dashboard"),
    menuItem("Best Sellers", tabName = "widgets"),
    menuItem("Games Genres", tabName = "market_share")
    
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "dashboard",
            h2("Video Games data overview"),
            fluidRow(
              column(width = 3,
                     p('Use the selections below to filter the dataset.'),
                selectInput(
                  "genre_input",
                  h3("Genre Filter :"),
                  choices = genres,
                  selected = "Action"
                ),
                selectInput(
                  "platform_input",
                  h3("Platform Filter :"),
                  choices = platforms,
                  selected = "NES"
                )
            ),
            column(width = 9,
              #boxes
              fluidRow(
                h3('Data Totals'),
                valueBox(dim(games_sales)[1] ,subtitle = 'Number of video games', width = 3, icon = icon("comment")),
                valueBox(length(genres), subtitle = 'Number of genres', width = 3, icon = icon("comment"), color = 'green'),
                valueBox(length(publishers), subtitle = 'Number of Publishers', width = 3, icon = icon("user"), color = 'yellow'),
                valueBox(length(platforms), subtitle = 'Number of Platforms', width = 3, icon = icon("user"), color = 'orange' )
              
              ),
              #datatable
              fluidRow(column(12, 
                              h3('Filtered data'),
                              DT::DTOutput("games_table")))
              )
            )),
    
    tabItem(tabName = "widgets",
            h2("Top 10 Best Selling Games for specificied publisher"),
            column(2,
                   p('Choose the publisher and specific console to see the top10
                     best sellers'),
                   selectInput(
                     "publisher_input",
                     h3("Publisher :"),
                     choices = publishers
                    ),
                   selectInput(
                     "platform_input2",
                     h3("Platform :"),
                     choices = platforms
                   )
            ),
            column(10,
                   plotOutput('top_10_plot')
            )
    ),
    
    tabItem(tabName = "market_share",
            h2("Game releases per genre"),
            column(2,
                   p('The chart on the left shows the overall market share for
                     each game genre i.e top3 = sports/action/racing'),
                   selectInput(
                     "publisher_input2",
                     h3("Publisher :"),
                     choices = publishers
                   )
            ),
            
            column(10,
                   column(5, h3('Overall releases per genre'), 
                          plotOutput('overall_market')),
                   
                   column(5, h3('Releases by genre for specified publisher'), 
                          plotOutput('publisher_market'))
                   )
    )
  )
)

plotly::plot_ly()


# UI
ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Simple tabs"),
  sidebar,
  body
)

server <- function(input, output, session) {
  
  filtered_dataview <- reactive({
      games_sales %>% 
        filter(genre == input$genre_input,
               platform == input$platform_input2)})
  
  best_sellers_top_10 <- reactive({games_sales %>% 
      filter(publisher != 'Other') %>% 
    group_by(name) %>%
    filter(publisher == input$publisher_input,
           platform == input$platform_input2) %>%
    arrange(desc(sales)) %>%
    head(10)})
  
  genre_publisher <- reactive({games_sales %>% 
      filter(publisher == input$publisher_input2) %>% 
      group_by(genre) %>% 
      summarize(number_of_games_genre = n()) %>% 
      arrange(genre)
    })
  
  output$games_table <- DT::renderDT(
    filtered_dataview()
  )

  output$top_10_plot <- renderPlot(

    best_sellers_top_10() %>% 
      ggplot(aes(reorder(name,sales),sales)) +
      geom_col(fill='purple1',col='black') + 
      coord_flip() + 
      labs(x='Game',
           y="Number of Sales (Million)") +
      theme(plot.title = element_text(hjust=0.5,size=16),
            axis.text.x = element_text(size=16),
            axis.text.y = element_text(size=16),
            axis.title = element_text(size=16),
            plot.subtitle = element_text(hjust=0.5,size=14))
  )
  
  output$overall_market <- renderPlot(
    games_per_genre %>% 
      ggplot(aes(reorder(genre,number_of_games_genre),number_of_games_genre, fill = genre)) +
      geom_col(col='black') +
      labs(x='Genre',y='Number of Games') +
      coord_flip() +
      theme(plot.title = element_text(hjust=0.5,size=16),
            axis.text.x = element_text(size=16),
            axis.text.y = element_text(size=16),
            axis.title = element_text(size=16),
            legend.text=element_text(size=16),
            legend.title=element_text(size=16), 
            plot.subtitle = element_text(hjust=0.5,size=14))
    )
  
  output$publisher_market <- renderPlot(
    genre_publisher() %>% 
      ggplot(aes(reorder(genre,number_of_games_genre),number_of_games_genre, fill = genre)) +
      geom_col(col='black') +
      labs(x='Genre',y='Number of Games') +
      coord_flip() +
      theme(plot.title = element_text(hjust=0.5,size=16),
            axis.text.x = element_text(size=16),
            axis.text.y = element_text(size=16),
            axis.title = element_text(size=16),
            legend.text=element_text(size=16),
            legend.title=element_text(size=16), 
            plot.subtitle = element_text(hjust=0.5,size=14),
            legend.position="none")+
      ggtitle(paste(input$publisher_input2))
    )  
    
}

shinyApp(ui, server)