server <- function(input, output) {
 
  dataInp<-reactive({ 
    
     2* as.numeric(input$entry)
    })
  
  output$top2 <- dataInp
 }

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
    
      textInput("entry",
                h5("Predict the double value for which number? Input here:"),
                "Thoda Sustalo"),
      submitButton("SUBMIT"),
      br()
     ),
    mainPanel(
      #plotOutput("distPlot"),
              span(h5(textOutput('top2')),style = "color:green")
              )
  )
)

shinyApp(ui = ui, server = server)



