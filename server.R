#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/

shinyServer(function(input, output) {
  
  state <- eventReactive(input$selectedstate, {
   prescribers_op_final %>%
   filter(State == input$selectedstate) %>%
   arrange(desc(totalopioids)) %>%
   top_n(totalopioids, n = 5)})

  opioids <- eventReactive(input$selectedstate, {
    prescribers_op_final %>%
    gather(rx, countrx, ACETAMINOPHEN.CODEINE:TRAMADOL.HCL) %>%
    group_by(State) %>%
    filter(State == input$selectedstate) %>%
    group_by(rx) %>%
    summarise(staterxtotal = sum(countrx)) %>%
    arrange(desc(staterxtotal)) %>%
    top_n(n = 5)})
  
  # draw bar plot of count of prescriptions for top 5 NPIs
  output$providerPlot <- renderPlot({
    df <- state()
    ggplot(df) +
      aes(x = reorder(df$NPI, -df$totalopioids), y = df$totalopioids) +
      scale_y_log10() +
      geom_col(aes(fill = Specialty)) +
      xlab("NPIs of Top Prescribers") +
      ylab("Count of 2014 Opioid Prescriptions")
    }, height = 400, width = 600)

    # draw bar plot of count of top opioids
    output$opioidsPlot <- renderPlot({
      df2 <- opioids()
      ggplot(df2) +
        aes(x = reorder(df2$rx, -df2$staterxtotal), y = df2$staterxtotal) +
        scale_y_log10() +
        geom_col(aes(fill = rx)) +
        xlab("Opioid Drug") +
        ylab("Count of 2014 Prescriptions") +
        theme(axis.text.x = element_blank()) +
        guides(fill=guide_legend(title="Opioid Name"))
    }, height = 400, width = 600)
  #   
    output$providerTable <- renderDataTable({
      df <- state()
      print(df)
    })
  #   
  #   
#   function(input, output) {
#       
#       # You can access the value of the widget with input$select, e.g.
#      # output$value <- renderPrint({ input$select })
#       
#     }    
#   })
#   
 })
