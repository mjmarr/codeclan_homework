library(shiny)
library(tidyverse)
library(bslib)

backpack_data <- CodeClanData::backpack %>% 
  mutate(backpain_labelled = recode(back_problems,"0" = "No","1" = "Yes"))
majors_all <- unique(backpack_data$major)

# Define UI for application that draws a histogram
ui <- fluidPage(
  #theme
  theme = bs_theme(bootswatch = 'minty'),
  # Application title
  fluidRow(column(8, offset = 1, 
                  titlePanel(strong("How many students in a specific major suffer with backpain?"))
  )),
  fluidRow(
    column(9, offset = 1,
           tabsetPanel(
             tabPanel("Plot",
                      fluidRow(
                        column(2,
                               selectInput(
                                 inputId = 'major_input',
                                 label = strong('Major'),
                                 choices = majors_all
                               )),
                        column(5,
                               plotOutput('backpain_in_major_plot')
                        ),
                        column(5,
                               plotOutput('body_backpack_weight_plot'))
                      )),
                      tabPanel("Summary",
                               verbatimTextOutput('summary')
                      ),
                      tabPanel("Data",
                               DT::dataTableOutput("table")
                      )
             )
           ),
           column(1)
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$backpain_in_major_plot <- renderPlot({
    
    backpack_data %>%
      filter(major == input$major_input) %>%
      ggplot() + 
      aes(x = backpain_labelled, fill = backpain_labelled) + 
      geom_bar() +
      ylim(0,100) + 
      labs(x = "backpain reported", y = "student count") +
      scale_fill_manual(values=c('#f0ca41', '#5022bd'))
  })
  
  output$body_backpack_weight_plot <- renderPlot({
    backpack_data %>%
      filter(major == input$major_input) %>% 
      ggplot() + 
      aes(x = body_weight, y = backpack_weight, color = sex) + 
      geom_point() + 
      facet_wrap(~sex) + 
      scale_color_manual(values=c('#E69F00', '#56B4E9'))+
      labs(x = "body weight", y = "backpack weight")
  })
  
  output$summary <- renderPrint({
    summary(backpack_data)
  })
  
  output$table <- DT::renderDataTable(DT::datatable({
    backpack_data
  }))
  
}

# Run the application 
shinyApp(ui = ui, server = server)
