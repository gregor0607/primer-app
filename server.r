library(shiny)
library(markdown)

# Define a server for the Shiny app
shinyServer(function(input, output) {
    
  output$FOR <- renderText({
    #setting up conditionals for validate data
    validate(
      need(!any(LETTERS[-c(1,3,7,20)] %in% 
                  unlist(strsplit(toupper(input$FOR), split=''))), 
                "A, C, G, T are the only valid input"),
      need(nchar(input$FOR) > 5, "Sequence must have at least 6 bases"))
    
    #calculating total salt concentration
    salt <- input$kcl + (input$mg/1000)
    seqfor <- toupper(input$FOR)
    
    #spliting sequence to count amount of each base
    seqforsplit <- split(seq(nchar(seqfor)),unlist(strsplit(seqfor,'')))
    G <- length(seqforsplit[['G']])
    C <- length(seqforsplit[['C']])
    gccont <- ((G + C)/nchar(seqfor))*100
    #countin Tm according to equation given in documentation
    paste("FOR primer Tm:",
    round(81.5 + 16.6 * log10(salt/(1+0.7*salt)) + 0.4 * gccont 
    - 500/nchar(seqfor), 1), "degrees Celsius; LENGTH:", nchar(input$FOR), "base pairs;",
    "GC CONTENT:", round(gccont, 1), "%")
  })
  
  output$REV <- renderText({
    #setting up conditionals for validate data
    validate(
    need(!any(LETTERS[-c(1,3,7,20)] %in% 
                 unlist(strsplit(toupper(input$REV), split=''))), 
                  "A, C, G, T are the only valid input"),
    need(nchar(input$REV) > 5, "Sequence must have at least 6 bases"))
    
    #calculating total salt concentration
    salt <- input$kcl + (input$mg/1000)
    seqrev <- toupper(input$REV)
    #spliting sequence to count amount of each base
    seqrevsplit <- split(seq(nchar(seqrev)),unlist(strsplit(seqrev,'')))
    G <- length(seqrevsplit[['G']])
    C <- length(seqrevsplit[['C']])
    gccont <- ((G + C)/nchar(seqrev))*100
    paste("REV primer Tm:",
          round(81.5 + 16.6 * log10(salt/(1+0.7*salt)) + 0.4 * gccont 
          - 500/nchar(seqrev), 1),"degrees Celsius; LENGTH:", nchar(input$FOR), "base pairs;",
          "GC CONTENT:", round(gccont, 1), "%")
  })
  
  
  
  output$Plot <- renderPlot({
    
    #Render a barplot
    if(nchar(input$FOR)<5 || nchar(input$REV)<5)
    {}
    else {
      seqfor <- toupper(input$FOR)
      seqrev <- toupper(input$REV)
      #creating data frames with base frequencies
      dfseqfor <- as.data.frame(table(strsplit(seqfor, split='')))
      dfseqrev <- as.data.frame(table(strsplit(seqrev, split='')))
      seqmerged <- merge(dfseqfor, dfseqrev, by="Var1", all=TRUE)
      #creating matrix with merged data from both primers to creat a barplot
      height <- rbind(seqmerged[,2], seqmerged[,3])
    barplot(height, names.arg = c("A", "C", "G", "T"), beside = TRUE,
            main="Amount of each base in both primers (dark grey shows forward primer)",
            ylab="Amount of Bases"
    )}
  })
})