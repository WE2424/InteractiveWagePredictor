library(shiny)
library(wooldridge)
library(dplyr)
library(randomForest)
library(rpart)

source("build_avatar_url.R")

data(wage2)

function(input, output, session) {
  model_fit <- reactive({
    req(input$predictors)
    formula <- as.formula(paste("lwage ~", paste(input$predictors, collapse = " + ")))
    
    if (input$model_type == "lm") {
      lm(formula, data = wage2)
    } 
    else if (input$model_type == "rf") {
      randomForest(
        formula,
        data = wage2,
        ntree = 500,
        na.action = na.roughfix
      )
    } 
    else if (input$model_type == "dt") {
      rpart(
        formula,
        data = wage2,
        method = "anova"
      )
    }
  })
  
  output$predictedWage <- renderText({
    req(input$predictors)
    newdata <- as.data.frame(lapply(input$predictors, function(var) input[[paste0("val_", var)]]))
    names(newdata) <- input$predictors
    
    pred <- exp(predict(model_fit(), newdata = newdata))
    
    paste0("Predicted monthly wage: $", round(pred, 2))
  })
  
  output$inputUI <- renderUI({
    req(input$predictors)
    lapply(input$predictors, function(var) {
      prev_val <- isolate(input[[paste0("val_", var)]])
      min_val <- min(wage2[[var]], na.rm = TRUE)
      max_val <- max(wage2[[var]], na.rm = TRUE)
      
      if ("age" == var) {
        min_val <- 20
        max_val <- 70
      }
      
      if ("educ" == var || "meduc" == var || "feduc" == var) {
        min_val <- 0
        max_val <- 20
      }
      
      if ("exper" == var || "tenure" == var) {
        min_val <- 0
        max_val <- 50
      }
      
      sliderInput(
        inputId = paste0("val_", var),
        label = paste("Value for", var, ":"),
        min = min_val,
        max = max_val,
        value = ifelse(is.null(prev_val), 0, prev_val),
        step = 1
      )
    })
  })
  
  output$predictedWage <- renderText({
    req(input$predictors)
    newdata <- as.data.frame(lapply(input$predictors, function(var) input[[paste0("val_", var)]]))
    names(newdata) <- input$predictors
    pred <- exp(predict(model_fit(), newdata = newdata))
    paste0("Monthly wage: $", round(pred, 2))
  })
  
  output$avatar <- renderUI({
    req(input$predictors)
    
    avatars <- list()
    avatars[[1]] <- tags$img(src = build_avatar_url(input), width = "200px")
    
    if ("married" %in% input$predictors && input$val_married == 1) {
      avatars[[2]] <- tags$img(
        src = build_avatar_url(input, overrides = list(
          seed = 2,
          gender = "female",
          mouth = "smile",
          clothes = "shirtVNeck",
          hair = "short01",
          accessory = "blank",
          facialHairProbability = 0,
          accessoriesProbability = 0,
          top = "",
          hatColor = "257C41",
          clothesColor = "25557c",
          eyes = "surprised",
          eyebrows = "upDownNatural"
        )),
        width = "200px"
      )
    }
    
    if ("sibs" %in% input$predictors && input$val_sibs > 0) {
      for (i in 1:input$val_sibs) {
        avatars[[length(avatars) + 1]] <- tags$img(
          src = build_avatar_url(input, overrides = list(
            seed = paste0("sibling", i),
            clothes = "hoodie",
            mouth = "smile",
            accessory = "blank",
            facialHairProbability = 0,
            accessoriesProbability = 0,
            top = "",
            hatColor = "257C41",
            clothesColor = "25557c",
            eyes = "surprised",
            eyebrows = "upDownNatural"
          )),
          width = "50"
        )
      }
    }
    
    if ("meduc" %in% input$predictors && input$val_meduc > 0) {
      avatars[[length(avatars) + 1]] <- tags$img(
        src = build_avatar_url(input, overrides = list(
          seed = 3,
          gender = "female",
          hairColor = "808080",
          clothesColor = "ffdfba",
          accessoriesProbability = 0,
          facialHairProbability = 0,
          clothes = if (input$val_meduc < 5) "overall" else if (input$val_meduc < 10) "hoodie" else if (input$val_meduc < 15) "shirtCrewNeck" else "collarAndSweater"
        )),
        width = "100px"
      )
    }
    
    if ("feduc" %in% input$predictors && input$val_feduc > 0) {
      avatars[[length(avatars) + 1]] <- tags$img(
        src = build_avatar_url(input, overrides = list(
          seed = 6,
          gender = "male",
          clothesColor = "ffdfba",
          hairColor = "808080",
          top = "sides",
          accessoriesProbability = 0,
          facialHairProbability = 0,
          clothes = if (input$val_feduc < 5) "overall" else if (input$val_feduc < 10) "hoodie" else if (input$val_feduc < 15) "shirtCrewNeck" else "collarAndSweater"
        )),
        width = "100px"
      )
    }
    
    do.call(tagList, avatars)
  })
}
