# Data

The raw dataset is **not stored in this repo** — it's ~2.8M rows / several GB and exceeds GitHub's file-size limits.

- **Source (raw data):** [US Accidents (2016–2023) — Kaggle](https://www.kaggle.com/datasets/sobhanmoosavi/us-accidents)
  Download `US_Accidents_March23.csv` and place it in this folder to reproduce the notebook end-to-end
  (see the "Load Data" cell in `notebooks/Final_Project.ipynb`).
- **`sample2.csv`** — a 1,000,000-row random sample (`random_state=2`) generated inside the notebook
  (see the *"Feature Selection, Outlier Check & Sampling"* section). This is the file the **Tableau
  dashboard** (`dashboard/US_Accidents_tableau_Dashboard.twb`) was built on, since the full dataset is
  too large to work with comfortably in Tableau.
- `sample1.csv` / `sample3.csv` are the other two random samples generated the same way, kept for
  reference — not used in the final dashboard.

None of these CSVs are committed (see `.gitignore`); regenerate them locally by running the notebook.
