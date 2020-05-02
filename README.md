# Credit-Risks
Assessing of credit risks using R and Python

Business problem: There is a bank specialized on SME lending. Lending business is exposed to credit risk. Credit risk is the risk of 
default on a loan that may arise from a borrower failing to make required payments. 
The goal is to model credit risk with the highest Specificity (true negative rate).

The dataset is composed of three features: 

-Financial rating,'finr' (from 1 to 10) is based on financial indicators of a borrower.

-Nonfinancial rating, 'nfinr' (from 1 to 10) is based on qualitative information about a borrower.

-Final rating,'fr' (from 1 to 10) incorporates financial and nonfinancial rating weighed by 70% and 30% respectively. Final rating is used by the bank in its lending process for credit decisions and loan monitoring.

Target feature: Default flag  'df' ('0' - not default, '1' - default)

Solved tasks:
1. Calculation and estimation of discriminatory power of the model (Kolmogorov-Smirnov test) in order to decide on the expediency of the following analysis (1_first_model_script.R);
2. Building a logit model based on bank customers’ ratings to further predict borrower status (1_first_model_script.R);
3. Quality assessment of the basic logistic regression model (1_first_model_script.R);
4. Deep data analysis and anomaly exclusion in order to improve the quality of the logit model (2_data_cleaning_script.R -- frDf.csv);
5. Building an improved logit model to decrease credit risks (3_final_logit.R) and comparing the results.
6. Using of SMOTE and NearMiss algorithms to solve the problem of imbalanced data. (4_SMOTE_on_frDf.ipynb, 5_nearMiss_method_on_frDf.ipynb)
