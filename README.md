# Walmart Sales — Exploratory Data Analysis (EDA)

An end-to-end exploratory data analysis of Walmart transactional sales data, covering data quality
auditing, cleaning, feature engineering, univariate/bivariate analysis, and answering 9 real
business questions using Python.

## Project Overview

This project analyzes ~10,000 Walmart transactions across 100 branches and 98 cities to uncover
sales trends, customer payment preferences, category performance, and branch-level revenue
patterns. The focus is on doing EDA *properly* — not just checking `.isnull().sum()` and moving on,
but validating every column against the format it's supposed to have, documenting every
inconsistency found, and cleaning the data deliberately.

##  Repository Structure

```
├── Walmart.csv                # Raw dataset
├── walmart_full_eda.ipynb     # Full EDA notebook (cleaning, analysis, business questions)
├── walmart_clean_data.csv     # Cleaned dataset (generated after running the notebook)
└── README.md
```

##  Dataset

| Column           | Description                                      |
|------------------|---------------------------------------------------|
| `invoice_id`     | Unique transaction ID                              |
| `Branch`         | Store branch code (e.g. `WALM003`)                 |
| `City`           | City the branch is located in                       |
| `category`       | Product category                                    |
| `unit_price`     | Price per unit (raw data stored as text, e.g. `$74.69`) |
| `quantity`       | Number of units sold                                |
| `date`           | Transaction date (`dd/mm/yy`)                       |
| `time`           | Transaction time (`HH:MM:SS`)                       |
| `payment_method` | Cash / Credit card / Ewallet                        |
| `rating`         | Customer satisfaction rating (3–10)                 |
| `profit_margin`  | Profit margin applied to the category               |

##  What the Notebook Covers

1. **Initial exploration** — shape, dtypes, `describe()`, unique-value counts
2. **Missing value analysis** — counts, percentages, and a missingness heatmap
3. **Duplicate analysis** — exact row duplicates and `invoice_id` uniqueness
4. **Column-by-column inconsistency checks**, including issues actually found in this dataset:
   - `unit_price` stored as text with a `$` prefix
   - `time` values inconsistently zero-padded (e.g. `8:53:00` vs `08:53:00`)
   - `profit_margin` behaving as a fixed value per category rather than a continuous number
   - ~31 rows with missing `unit_price`/`quantity` (same rows affected)
   - 51 exact duplicate transactions
5. **Data cleaning & feature engineering** — type conversion, parsing dates/times, and
   engineering `total`, `profit`, `year`, `month_name`, `day_name`, `hour`, and `shift`
   (Morning/Afternoon/Evening)
6. **Outlier detection** using the IQR method
7. **Univariate analysis** — distribution plots for numeric and categorical columns
8. **Bivariate/multivariate analysis** — correlation heatmap, category vs. rating/profit,
   top branches by revenue, monthly revenue trend
9. **Business question analysis** — see below
10. **Export** of the cleaned dataset to `walmart_clean_data.csv`

##  Business Questions Answered

1. What are the different payment methods, and how many transactions/items were sold with each?
2. Which category received the highest average rating in each branch?
3. What is the busiest day of the week for each branch?
4. How many items were sold through each payment method?
5. What are the average, minimum, and maximum ratings for each category in each city?
6. What is the total profit for each category, ranked highest to lowest?
7. What is the most frequently used payment method in each branch?
8. How many transactions occur in each shift (Morning/Afternoon/Evening) across branches?
9. Which branches experienced the largest year-over-year revenue decline?

##  Tools & Libraries

- Python 3
- pandas, numpy
- matplotlib, seaborn
- (optional) SQLAlchemy / pymysql / psycopg2 — for pushing cleaned data into MySQL or Postgres

##  How to Run

```bash
# Clone the repo
git clone https://github.com/<your-username>/walmart-eda.git
cd walmart-eda

# Install dependencies
pip install pandas numpy matplotlib seaborn

# Launch the notebook
jupyter notebook walmart_full_eda.ipynb
```

Run all cells top to bottom — the notebook loads `Walmart.csv`, performs the full analysis, and
writes out `walmart_clean_data.csv` at the end.

##  Key Takeaways

- Credit card is the most-used payment method by transaction volume, followed by Ewallet and Cash.
- Category profit and rating vary meaningfully by branch and city, suggesting room for
  branch-specific promotions rather than a one-size-fits-all strategy.
- Sales activity varies noticeably by shift and day of week, which has direct implications for
  staffing and restocking schedules.
- A handful of branches show a clear year-over-year revenue decline, worth investigating further
  at the local level.

##  License

This project is for educational/portfolio purposes. Feel free to fork and adapt it.
