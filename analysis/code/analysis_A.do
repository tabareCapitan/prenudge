/*******************************************************************************
Author:       TabareCapitan.com

Description:  Results and tables for the descriptive statistics for the lab
              experiment, presented in the Online Appendix.

Created: 20220301 | Last modified: 20220718
*******************************************************************************/


*** LOAD DATA ******************************************************************

use "$RUTA/results/lab_prenudge.dta", clear


*** DEMOGRAPHIC CHARACTERISTICS *************************************************

tab female

sum age

tab education

tab expenses, mi

tab income, mi


*** PSYCHOLOGICAL FACTORS ******************************************************

tab hungryLevel

tab riskPreferences

sum foodSelfControl

twoway  histogram foodSelfControl,  fraction                                    ///
                  ylabel(,ang(h))                                               ///
                  xtitle("Eating-self-control")

graph export "$RUTA/results/figures/oa_selfControl.png",                        ///
                                    replace width(11000) height(8000)


*** BODY WEIGHT AND BODY MASS INDEX ********************************************

sum bodyweigth selfReportedWeight BMI BMI_self if female == 0, de

sum bodyweigth selfReportedWeight BMI BMI_self if female == 1, de


twoway  (kdensity bodyweigth if female == 1         , lpattern(solid))          ///
        (kdensity selfReportedWeight if female == 1 , lpattern(dash))           ///
                  ,                                                             ///
                  ylabel(,ang(h))                                               ///
                  ytitle("Density")                                             ///
                  xtitle("Pounds")                                              ///
                  legend(on order(1 "Measured" 2 "Self-reported")               ///
                        textfirst cols(1) ring(0) pos(2) region(lstyle(none)))  ///
                  title("Women")                                                ///
                  note("Epanechnikov kernel function")                          ///
                  saving("$RUTA/temp/figures/weight_f.gph", replace)

twoway  (kdensity bodyweigth if female == 0         , lpattern(solid))          ///
        (kdensity selfReportedWeight if female == 0 , lpattern(dash)),          ///
                  ylabel(,ang(h))                                               ///
                  ytitle("Density")                                             ///
                  xtitle("Pounds")                                              ///
                  legend(on order(1 "Measured" 2 "Self-reported")               ///
                        textfirst cols(1) ring(0) pos(2) region(lstyle(none)))  ///
                  title("Men")                                                  ///
                  note("Epanechnikov kernel function")                          ///
                  saving("$RUTA/temp/figures/weight_m.gph", replace)


graph combine     "$RUTA/temp/figures/weight_f.gph"                             ///
                  "$RUTA/temp/figures/weight_m.gph"                             ///
                  ,                                                             ///
                  cols(2) ycommon xcommon

graph export "$RUTA/results/figures/oa_weight.png",                             ///
                                    replace width(10000) height(4000)

sum confidenceWeightEstimate

tab freqWeigh

tab lastWeightMeasure


tab weightAssesment


*** HEALTH ASSESSMENT AND ASPIRATIONS ******************************************

sum healthAssesment_*


*** HEALTH- AND FOOD-RELATED GOALS *********************************************

sum weightGoals_1 weightGoals_2 weightGoals_3

sum wantToLoseWeight dieting

sum wantToLoseWeight dieting if female == 0


sum wantToLoseWeight dieting if female == 1


*** EXPOSURE TO CALORIE INFORMATION ********************************************

tab freqInfo


sum knowsCalorieNeeds

*** END OF FILE ****************************************************************
********************************************************************************
