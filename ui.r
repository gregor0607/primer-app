# Define the overall UI
library(markdown)

shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel(p("PCR primer Tm calculator", style = "color:blue",
                                             align = "center"),
                 br()),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar
      sidebarPanel(
        img(src="dna.png", height = 100, width = 250),
        hr(),
        # Integer for magnesium concentration
        sliderInput("mg", "Magnesium concentration [mmole/l]:", 
                    min=0, max=10, value=5),
        
        # Decimal for KCl concentraion
        sliderInput("kcl", "KCl concentration [mole/l]:", 
                    min = 0, max = 1.0, value = 0.5, step= 0.1),
        helpText("Adjust salt concentration"),
        hr(),
        # Input for primers sequence
        textInput("FOR", label = h5("FORWARD primer sequence"), 
                  value = ""),
        textInput("REV", label = h5("REVERSE primer sequence"),
                  value = ""),
        helpText("Enter both primer sequences (it should contain only A, C, G, T
                  letters)")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        textOutput("FOR"),
        textOutput("REV"),
        plotOutput("Plot"),
        
        includeMarkdown("documentation.md")
      )
      
    )
  )
)
