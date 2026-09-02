# US Traffic Accidents Analysis (2016–2023)

End-to-end data analysis project exploring the US Accidents dataset using **Python, SQL, Tableau, and Power BI** — from raw data to cleaned datasets, exploratory analysis, and severity/state prediction models.

## 👥 Team

This project was built collaboratively by a 5-person team, each owning a distinct stage of the pipeline:

| Member | Role |
|---|---|
| **Ziad Ehab** | Data cleaning, preprocessing, and visualization (Python) |
| **Megan Moheb** | Machine learning modeling |
| **Rojeh Tamer** | Power BI dashboard (built on `sample2.csv`) |
| **Ahmed Hussein** | SQL data warehouse & analytical queries |
| **Mariam Mohamed** | Tableau dashboard |

## 📁 Repository Structure
```
├── notebooks/
│ └── Final_Project.ipynb # Data cleaning, EDA, visualization, and ML modeling (Severity & State prediction)
├── sql/
│ ├── Tables.sql # Star-schema DDL (Dim_Location, Dim_Weather, Dim_Time, Dim_Road_Features, Fact_Accidents)
│ └── Final_Query.sql # 15 analytical queries (time / location / weather / severity analysis)
├── dashboard/
│ ├── US_Accidents_tableau_Dashboardd.twb # Tableau workbook (built on sample2.csv)
│ └── assets/
│ ├── sidebar_icon_road.png # Custom icon used in the Power BI dashboard
│ └── sidebar_icon_wheel.png # Custom icon used in the Power BI dashboard
├── data/
│ └── README.md # Kaggle source link + sample generation details
└── README.md
```

## 📊 Data

The full raw dataset (~2.8M rows) is **not stored in this repo** due to GitHub's file-size limits.

| File | Description | Link |
|---|---|---|
| `US_Accidents_March23.csv` | Full raw dataset | [Kaggle – US Accidents (2016–2023)](https://www.kaggle.com/datasets/sobhanmoosavi/us-accidents) |
| `sample2.csv` | 1,000,000-row random sample used for both dashboards | [Download from Releases](https://github.com/Rojeh-Tamer/us-accidents-data-analysis/releases/download/v1.0/sample2.csv) |

See [`data/README.md`](data/README.md) for details on how the sample was generated.

## 📓 Notebook

`notebooks/Final_Project.ipynb` walks through the full pipeline:

1. Load data & initial exploration
2. Datetime parsing & missing-value overview
3. Time / location / weather analysis
4. Data cleaning (two passes: exploratory + modeling-ready)
5. Visualizations backing the dashboards
6. Feature engineering, sampling (`sample1/2/3.csv`)
7. Severity prediction model (LightGBM)
8. State prediction model (LightGBM)

**To run it:** download `US_Accidents_March23.csv` from Kaggle (link above), place it under `data/`, then open the notebook in Jupyter and run cells top to bottom.

## 🗄️ SQL

`sql/Tables.sql` defines a star schema (`TrafficDB_Work`) — one fact table (`Fact_Accidents`) and four dimension tables (`Dim_Location`, `Dim_Weather`, `Dim_Time`, `Dim_Road_Features`).
`sql/Final_Query.sql` contains 15 business questions answered against that schema, covering time trends, geographic hotspots, weather impact, and severity analysis.

**To run it:** create the schema in SQL Server using `Tables.sql`, load the cleaned data into the tables, then run `Final_Query.sql`.

## 📈 Dashboards

- **Tableau** — `dashboard/US_Accidents_tableau_Dashboardd.twb`. Open directly in Tableau Desktop, pointing it at `sample2.csv`.
- **Power BI** — too large for the repo; download from [Releases](https://github.com/Rojeh-Tamer/us-accidents-data-analysis/releases/download/v1.0/Final_Project_Dashboard.pbix). Custom sidebar icons used in this dashboard are in `dashboard/assets/`.

Both dashboards are built on `sample2.csv` (not the full dataset) for performance reasons.

## 🛠️ Tools

Python (pandas, matplotlib, scikit-learn, LightGBM) · SQL Server · Tableau · Power BI

## 👤 Repository Maintainer

**Rojeh Tamer** — [GitHub](https://github.com/Rojeh-Tamer)
