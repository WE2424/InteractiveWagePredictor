# Interactive Wage Predictor: A Shiny Application

This Shiny application combines machine learning with data visualization. Demographic and labor attributes from a Wooldridge dataset are chosen and the app predicts monthly wages using [Linear Regression](https://en.wikipedia.org/wiki/Linear_regression), [Decision Tree](https://en.wikipedia.org/wiki/Decision_tree_learning), or [Random Forest](https://en.wikipedia.org/wiki/Random_forest). Next to the wage, an avatar with the selected attributes is created using the DiceBear Avataaars API.

- [Features](#features)
  - [Prediction](#prediction)
  - [Avatar](#avatar)
  - [Data](#data)
- [Requirements](#requirements)
  - [R](#r)
- [Getting Started](#getting-started)
- [Acknowledgments](#acknowledgments)
- [License](#license)

## Features

### Prediction
[Prediction](src/server.R) of the monthly wage is done using one of the following algorithms:
- Linear Regression
- Decision Tree
- Random Forest

Any combination of predictor variables from the dataset can be [chosen](src/ui.R) and their values adjusted to predict monthly wage.

### Avatar
The avatar [updates](src/build_avatar_url.R) as the predictor variables change:
- Hours worked changes the facial expression
- Higher IQ unlocks different eyewear
- Education changes clothing style
- Experience increases beard growth
- Increased tenure grays the clothing
- Age grays hair color gradually
- Work experience influences facial hair
- Marriage generates a partner avatar
- Siblings add extra tiny avatars
- Parents education adds extra avatars with changing clothing style
- Regional, race, and urban status influence colors and backgrounds

### Data
The data consists of 935 observations of young men in the USA in 1980. As this dataset may not be representative for modern wages, caution must be taken when drawing conclusions from the predicted wage. [Source](https://search.r-project.org/CRAN/refmans/wooldridge/html/wage2.html)

## Requirements

### R
R version 4.3.1+

Packages:
- shiny
- wooldridge
- dplyr
- randomForest
- rpart

## Getting Started

1. Clone the repository

```bash
git clone https://github.com/WE2424/InteractiveWagePredictor.git
cd InteractiveWagePredictor
```

2. Install packages
   
```bash
R -e "options(repos='https://cloud.r-project.org'); install.packages(readLines('dep/packages.txt'))"

```

3. Run the Shiny app

```bash
R -e "shiny::runApp('src', port = 8080, launch.browser = TRUE)"
```

4. The app is now listening on http://localhost:8080.

## Acknowledgments
Data:
- Jeffrey Wooldridge’s Introductory Econometrics dataset collection
- R package: wooldridge

Avatars:
- DiceBear Avataaars API
- https://www.dicebear.com/

## License
[MIT License](LICENSE.md)