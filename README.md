# Yemen PriceGuard AI

**A machine-learning research prototype for identifying next-month wheat-flour price increases in three Yemeni markets.**

**العربية:** مشروع تعلم آلة بحثي تجريبي لتصنيف احتمال ارتفاع سعر دقيق القمح في الشهر التالي بنسبة 10% أو أكثر في أسواق عدن وذمار وصنعاء.

## Project question
Can historical wheat-flour prices, previous price changes, calendar fields, and market identity help classify whether the next observed monthly price will be at least 10% higher than the current price?

This is a **binary classification** task, not a forecast of the exact future price.

## Markets and dataset
- Aden City
- Dhamar City
- Sana'a City
- Dataset version: 2026-03-24; source records span January 2009 to March 2026.
- Source: [World Bank Microdata Library — Monthly food price estimates by product and market (Yemen)](https://microdata.worldbank.org/catalog/4508).

**Raw data are not included in this public repository.** The source is distributed through the World Bank Microdata Library, whose use and redistribution conditions vary by dataset. Please obtain the data from the official source, review and comply with the applicable terms, and save the downloaded archive under the exact name `YEM_RTFP_mkt_2009_2026-03-24.zip` in the repository root before running the notebook. Do not treat the existence of a download link as blanket permission to re-distribute the raw file.

The notebook expects the archive to contain `YEM_RTFP_mkt_2009_2026-03-24.csv` and extracts it into `priceguard_data/`.

## Workflow
1. Load and inspect the source CSV.
2. Select the three markets and `c_wheat_flour` price field.
3. Validate missing prices, invalid dates, duplicate market-date rows, and non-positive prices.
4. Define the target: `1` when next-month price change is at least 10%, otherwise `0`.
5. Engineer prior-price features, a three-period trailing mean, prior percentage change, month, year, and market indicators.
6. Compare Logistic Regression and Random Forest experiments.
7. Evaluate the final model with three chronological validation folds. The corrected procedure excludes the last training date of each fold because its target uses the following month’s price.
8. Inspect class imbalance, feature importance, confusion matrices, and decision thresholds.

## Key data counts
- Source table: 5,175 rows × 165 columns.
- Three-market subset: 621 rows (207 per market).
- After target construction: 618 labeled rows.
- After historical feature engineering: 609 modeling rows (203 per market).
- Positive cases after feature engineering: 51 (about 8.37%).

## Main corrected temporal-validation results
| Fold | Validation rows | Actual positive cases | Accuracy | Precision | Recall | F1 |
|---|---:|---:|---:|---:|---:|---:|
| 1 | 81 | 6 | 0.9259 | 0.0000 | 0.0000 | 0.0000 |
| 2 | 78 | 7 | 0.9231 | 1.0000 | 0.1429 | 0.2500 |
| 3 | 87 | 2 | 0.9770 | 0.0000 | 0.0000 | 0.0000 |

**Interpretation:** high accuracy is not evidence of strong positive-event detection when rises are rare. In these corrected temporal folds the model missed most actual rises. Fold 3 has only two positives, so its metrics are especially unstable. This should be presented as a research prototype, not a production-ready alerting tool.

Threshold analysis at 0.4 was exploratory on Fold 2 only; it must not be considered a final selected threshold because the same validation period was used to inspect it.

## Repository structure
```text
Yemen-PriceGuard-AI/
├── Yemen_PriceGuard_AI.ipynb
├── README.md
├── requirements.txt
├── .gitignore
├── UPLOAD_TO_GITHUB_WINDOWS.bat
├── data/
│   └── README.md
├── docs/
│   └── Yemen_PriceGuard_AI_Academic_Guide_AR_EN.docx
└── results/
    ├── class_balance_results.csv
    ├── feature_importance.csv
    ├── threshold_analysis.csv
    └── time_validation_results.csv
```

## Run in Google Colab
1. Download this repository or open the notebook in Colab.
2. Obtain the dataset archive from the official source and upload `YEM_RTFP_mkt_2009_2026-03-24.zip` to the notebook's working directory.
3. Install dependencies if needed using `pip install -r requirements.txt`.
4. Run the notebook from top to bottom. Use the **corrected temporal-validation** outputs as the primary evaluation results.

## Dependencies
Python 3.10+; see `requirements.txt`.

## Research limitations
- The positive class is rare and the number of rises in each validation fold is small.
- Accuracy can be misleading in imbalanced classification.
- The current predictors are limited to prices, calendar fields, and market identity; they do not directly model exchange rates, transport costs, fuel prices, conflict disruptions, or commodity availability.
- Random Forest feature importance is not causal evidence.
- Predicted probabilities are not guaranteed to be calibrated.
- Threshold tuning requires separate validation data and a later untouched test period.

## Data citation
Andrée, Bo Pieter Johannes. *Monthly food price estimates by product and market: Yemen, Rep., 2009–2026, version 2026-03-24*. World Bank Microdata Library, catalog 4508. See the source catalog for citation details and applicable terms.

## Academic use
This project supports academic exploration and explanation. Its current temporal-validation performance does **not** justify claims that it reliably detects future price shocks.
