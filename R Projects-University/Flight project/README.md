# ✈️ United Airlines Flight Delay Analysis

Welcome to the United Airlines Flight Delay Analysis project! This project combines **exploratory data analysis** and **machine learning** to investigate flight delays using R. Ideal for demonstrating your R and data science skills in a practical aviation scenario.

## 📁 Project Structure
```
UnitedFlights_FullAnalysis/
├── data/
│   └── United flights.csv
├── eda/
│   ├── united_flights_eda.Rmd
│   └── united_flights_eda.html
├── ml/
│   ├── united_flights_ml.Rmd
│   └── united_flights_ml.html
├── README.md
```

## 🧠 Project Goals
- Conduct exploratory data analysis (EDA) to uncover patterns in flight delays
- Engineer new features such as total delay, weather conditions, and day of the week
- Train classification models (Decision Tree & Random Forest) to predict delay severity
- Visualise insights and model performance using plots and confusion matrices

## 🔍 EDA Highlights
- Correlation heatmap between delay metrics and time in air
- Seasonal trends in delay duration
- Impact of rain and weather on departure times
- Pairwise variable relationships

## 🤖 ML Models
- **Decision Tree** (`rpart`): interpretable model for delay classification
- **Random Forest** (`randomForest`): robust ensemble with better accuracy

## 🔧 How to Run
1. Open `.Rmd` files in **RStudio**
2. Install missing libraries if prompted
3. Run each chunk or click `Knit` to generate the full `.html` reports

```r
rmarkdown::render("eda/united_flights_eda.Rmd")
rmarkdown::render("ml/united_flights_ml.Rmd")
```

## 📌 Requirements
- R (>= 4.0.0)
- RStudio
- Packages: `tidyverse`, `lubridate`, `corrplot`, `rpart.plot`, `randomForest`, `GGally`, `tidymodels`

## 🙋 About
Developed by **Anastasia Nica** as part of a university data portfolio to demonstrate real-world R capabilities in the context of aviation analytics.

## 📬 Feedback
Feel free to open issues or pull requests if you'd like to contribute or suggest improvements!
