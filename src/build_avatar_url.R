build_avatar_url <- function(input, overrides = list()) {
  seed <- "Oliver"
  gender <- "male"
  clothes <- "overall"
  hair <- "short01"
  hairColor <- "000000"
  accessory <- "blank"
  bgColor <- "bae1ff"
  skin <- "ffdbac"
  facialHair <- ""
  facialHairProbability <- 0
  facialHairColor <- "000000"
  accessoriesProbability <- 0
  accessories <- "eyepatch"
  accessoriesColor <- "257C41"
  top <- ""
  hatColor <- "257C41"
  clothesColor <- "25557c"
  eyes <- "surprised"
  eyebrows <- "upDownNatural"
  mouth <- "default"
  
  if ("hours" %in% input$predictors) {
    val <- input$val_hours
    eyes <- if (val < 30) "surprised" else if (val < 40) "default" else if (val < 50) "closed" else if (val < 60) "eyeRoll" else if (val < 70) "cry" else "xDizzy"
    eyebrows <- if (val < 40) "upDownNatural" else "sadConcernedNatural"
    mouth <- if (val < 30) "default" else if (val < 40) "twinkle" else if (val < 50) "serious" else if (val < 60) "disbelief" else if (val < 70) "concerned" else "screamOpen"
  }
  
  if ("urban" %in% input$predictors) {
    val <- input$val_urban
    top <- if (val == 0) "hat" else "winterHat03"
  }
  
  if ("educ" %in% input$predictors) {
    val <- input$val_educ
    clothes <- if (val < 5) "overall" else if (val < 10) "hoodie" else if (val < 15) "shirtCrewNeck" else "collarAndSweater"
  }
  
  if ("IQ" %in% input$predictors) {
    val <- input$val_IQ
    accessories <- if (val < 64) "eyepatch" else if (val < 77) "kurt" else if (val < 91) "sunglasses" else if (val < 104) "wayfarers" else if (val < 118) "prescription01" else if (val < 131) "prescription02" else "round"
    accessoriesProbability <- 100
  }
  
  if ("age" %in% input$predictors && !is.null(input$val_age)) {
    val <- input$val_age
    
    col_young <- col2rgb("#000000")
    col_old  <- col2rgb("#FFFFFF")
    t <- max((val - 20)/ 100, 0)
    col_interp <- col_young * (1 - t) + col_old * t
    
    hairColor <- toupper(paste0(
      format(as.hexmode(round(col_interp[1,])), width=2),
      format(as.hexmode(round(col_interp[2,])), width=2),
      format(as.hexmode(round(col_interp[3,])), width=2)
    ))
    facialHairColor <- hairColor
  }
  
  if ("tenure" %in% input$predictors && !is.null(input$val_tenure)) {
    val <- input$val_tenure
    
    col_low <- col2rgb("#25557c")
    col_high  <- col2rgb("#FFFFFF")
    t <- max((val)/ 100, 0)
    col_interp <- col_low * (1 - t) + col_high * t
    
    clothesColor <- toupper(paste0(
      format(as.hexmode(round(col_interp[1,])), width=2),
      format(as.hexmode(round(col_interp[2,])), width=2),
      format(as.hexmode(round(col_interp[3,])), width=2)
    ))
    
    col_low2 <- col2rgb("#257C41")
    col_high2  <- col2rgb("#FFFFFF")
    t <- max((val)/ 100, 0)
    col_interp <- col_low2 * (1 - t) + col_high2 * t
    
    accessoriesColor <- toupper(paste0(
      format(as.hexmode(round(col_interp[1,])), width=2),
      format(as.hexmode(round(col_interp[2,])), width=2),
      format(as.hexmode(round(col_interp[3,])), width=2)
    ))
    hatColor <- accessoriesColor
  }
  
  if ("exper" %in% input$predictors) {
    val <- input$val_exper
    facialHair <- if (val < 13) "" else if (val < 25) "beardLight" else if (val < 38) "beardMedium" else "beardMajestic"
    facialHairProbability <- if (val >= 13) 100
  }
  
  if ("black" %in% input$predictors) {
    val <- input$val_black
    if (!is.null(val) && val == 1) skin <- "8B4513"
  }
  
  if ("married" %in% input$predictors) {
    val <- input$val_married
    if (!is.null(val) && val == 1) accessory <- "round"
  }
  
  if ("south" %in% input$predictors) {
    val <- input$val_south
    if (!is.null(val) && val == 1) bgColor <- "ffb3ba"
  }
  
  for (nm in names(overrides)) {
    assign(nm, overrides[[nm]])
  }
  
  paste0(
    "https://api.dicebear.com/9.x/avataaars/svg?seed=", seed,
    "&gender=", gender,
    "&hair=", hair,
    "&hairColor=", hairColor,
    "&clothing=", clothes,
    "&backgroundColor=", bgColor,
    "&skinColor=", skin,
    "&facialHair=", facialHair,
    "&facialHairProbability=", facialHairProbability,
    "&facialHairColor=", facialHairColor,
    "&accessoriesProbability=", accessoriesProbability,
    "&accessories=", accessories,
    "&accessoriesColor=", accessoriesColor,
    "&top=", top,
    "&hatColor=", hatColor,
    "&clothesColor=", clothesColor,
    "&eyes=", eyes,
    "&eyebrows=", eyebrows,
    "&mouth=", mouth
  )
}