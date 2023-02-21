/*******************************************************************************
Project:      Expecting to get it: An Endowment Effect for Information

Author:       TabareCapitan.com

Description:  (LaTeX) Table with descriptive statistics

Created: 20200719 | Last modified: 20200719
*******************************************************************************/
version 14.2

*** LOAD DATA ******************************************************************

use "$RUTA/results/lab_prenudge.dta", clear

*** LIST OF COVARIATES *********************************************************

#delimit ;

global COVS "female age expenses income
             hungryLevel riskPreferences  foodSelfControl
             BMI  BMI_self  underWeight normal overWeight obese
             healthAssesment_1 healthAssesment_2 healthAssesment_3
                                                 healthAssesment_4
             weightGoals_1  weightGoals_2 weightGoals_3
             wantToLoseWeight dieting
             freqInfo knowsCalorieNeeds"
             ;

#delimit cr

*** GET SUMMARY STATISTICS *****************************************************

tabstat $COVS, columns(statistics) stats(n mean sd min max) format(%9.2g) save

*** SAVE STATS TO DTA **********************************************************

matrix m = r(StatTotal)'

// svmatf appends, so must ensure there is nothing there
cap erase "$RUTA/temp/data/matrix_descriptiveStats.dta"

svmatf , mat(m) fil("$RUTA/temp/data/matrix_descriptiveStats.dta")

*** CREATE LATEX TABLE *********************************************************

use "$RUTA/temp/data/matrix_descriptiveStats.dta", clear

* ROUND TO TWO DECIMAL POINTS --------------------------------------------------

foreach cov of varlist mean sd min max{

    replace `cov' = round(`cov', 0.01)
}

* HEADER -----------------------------------------------------------------------

label var N     "N"
label var mean  "Mean"
label var sd    "Std. Dev."
label var min   "Min."
label var max   "Max."

* SIDE BAR ---------------------------------------------------------------------

order row

rename row var

replace var = "Female"           if var == "female"
replace var = "Age"              if var == "age"
replace var = "Expenses level"   if var == "expenses"
replace var = "Income level"     if var == "income"

replace var = "Hunger level"                  if var == "hungryLevel"
replace var = "Risk preferences"              if var == "riskPreferences"
replace var = "Food self-control"             if var == "foodSelfControl"

replace var = "Body-Mass Index (measured)"         if var == "BMI"
replace var = "Body-Mass Index (self-report)"      if var == "BMI_self"
replace var = "Underweight"      if var == "underWeight"
replace var = "Proper weight"    if var == "normal"
replace var = "Overweight"       if var == "overWeight"
replace var = "Obese"            if var == "obese"

replace var = "Health assessment"                                               ///
    if var == "healthAssesment_1"
replace var = "Would benefit from eating healthier"                             ///
    if var == "healthAssesment_2"
replace var = "Wish could eat healthier at home"                                ///
    if var == "healthAssesment_3"
replace var = "Wish could eat healthier out"                                    ///
    if var == "healthAssesment_4"

replace var = "Importance of eating healthy food"                               ///
    if var == "weightGoals_1"
replace var = "Importance of exercising regularly"                              ///
    if var == "weightGoals_2"
replace var = "Importance of healthy body weight"                               ///
    if var == "weightGoals_3"

replace var = "Want to lose weight" if var == "wantToLoseWeight"
replace var = "Currently on a diet" if var == "dieting"

replace var = "Experience with calorie information"                             ///
    if var == "freqInfo"
replace var = "Knows calorie needs"                                             ///
    if var == "calorieNeedsAnswer"

* EXPORT TO TEX ----------------------------------------------------------------

texsave using "$RUTA/results/tables/tab_descriptiveStatistics_lab.tex",         ///
                                                                                ///
        replace                                                                 ///
        title("Descriptive statistics: Lab")                                    ///
        marker(tab:descriptiveStatisticsLab)                                    ///
        varlabels                                                               ///
        hlines(4 7 13 17  22)                                                   ///
        location(h)                                                             ///
        frag

*** END OF FILE ****************************************************************
********************************************************************************
