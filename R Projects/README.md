# United Airlines Flight Delay Analysis

This repository showcases a complete exploratory data analysis (EDA) project using R and R Markdown.
The dataset contains information about 25,000+ United Airlines flights, including delays, weather, and incentives.

## 📁 Files

- `united_flights_analysis.Rmd`: Fully-documented R Markdown file that includes data import, wrangling, pivot tables, visualisations, and conclusions.
- `United flights.csv`: Raw dataset used in the analysis.

## 🛠️ Tools Used

- `tidyverse`: Data manipulation and visualisation
- `pivottabler`: Advanced pivot tables (Excel-style)
- `ggplot2`: Publication-quality plots

## 📊 Project Goals

- Perform feature engineering (e.g., `Net_Delay`, `Total_Delay`)
- Create insightful pivot tables and subsamples
- Visualise delay patterns across airports and conditions

## 🖼️ Sample Visualisations

- **Histograms** of departure and arrival delays
- **Scatter plot** between departure and arrival delays
- **Boxplot** of delay by origin airport
- **Matrix plot**: mean net delay by origin and destination

## 🔍 Insights Explored

- Is rain at origin or destination associated with delay?
- Do incentive payments reduce departure delay?
- How are delays distributed by airport?

## 📦 How to Run

1. Clone this repository
2. Open `united_flights_analysis.Rmd` in RStudio
3. Click **Knit** to generate the HTML report

Make sure you have the following packages installed:
```r
install.packages("tidyverse")
install.packages("pivottabler")
```

## 📄 License

MIT License — free to use with attribution.
