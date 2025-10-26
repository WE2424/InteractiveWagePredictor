library(shiny)
library(wooldridge)

data(wage2)

fluidPage(
  titlePanel("Build Your Avatar"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "model_type",
        "Choose model type:",
        choices = c(
          "Linear Regression" = "lm",
          "Decision Tree" = "dt",
          "Random Forest" = "rf"
        ),
        selected = "lm"
      ),
      checkboxGroupInput(
        "predictors",
        "Choose variables:",
        choices = setdiff(names(wage2), c("wage", "lwage", "brthord", "KWW"))
      ),
      hr(),
      uiOutput("inputUI")
    ),
    
    mainPanel(
      h3("Predicted Wage"),
      verbatimTextOutput("predictedWage"),
      h3("Your Avatar"),
      uiOutput("avatar")
    )
  )
)
