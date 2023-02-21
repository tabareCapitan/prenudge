/*******************************************************************************
Author:       TabareCapitan.com

Description:  New variables for analysis

Created: 20190411 | Last modified: 20220718
*******************************************************************************/

*** LOAD DATA ******************************************************************

use "$RUTA/temp/data/labData.dta", clear


*** CALCULATE WTA **************************************************************

* WTA TO GET INFO --------------------------------------------------------------

gen wtaGetInfo = .

	replace wtaGetInfo = 0.01 				    if toInfoWTA == 0.01
	replace wtaGetInfo = (0.25 + 0.01)/2 	if toInfoWTA == 0.25
	replace wtaGetInfo = (0.5  + 0.25)/2	if toInfoWTA == 0.5
	replace wtaGetInfo = (0.75 + 0.5 )/2 	if toInfoWTA == 0.75
	replace wtaGetInfo = (1    + 0.75)/2 	if toInfoWTA == 1
	replace wtaGetInfo = (1.5  + 1   )/2 	if toInfoWTA == 1.5
	replace wtaGetInfo = (2    + 1.5 )/2	if toInfoWTA == 2
	replace wtaGetInfo = (2.5  + 2   )/2 	if toInfoWTA == 2.5
	replace wtaGetInfo = (3    + 2.5 )/2	if toInfoWTA == 3
	replace wtaGetInfo = (5    + 2.5 )/2 	if toInfoWTA == 5
	replace wtaGetInfo = 5 						  	if toInfoWTA == 666


* WTA TO LOSE INFO -------------------------------------------------------------

gen wtaLoseInfo = .

	replace wtaLoseInfo = 0.01 					  	if toNoInfoWTA == 0.01
	replace wtaLoseInfo = (0.25 + 0.01)/2 	if toNoInfoWTA == 0.25
	replace wtaLoseInfo = (0.5  + 0.25)/2	  if toNoInfoWTA == 0.5
	replace wtaLoseInfo = (0.75 + 0.5 )/2 	if toNoInfoWTA == 0.75
	replace wtaLoseInfo = (1    + 0.75)/2 	if toNoInfoWTA == 1
	replace wtaLoseInfo = (1.5  + 1   )/2 	if toNoInfoWTA == 1.5
	replace wtaLoseInfo = (2    + 1.5 )/2  	if toNoInfoWTA == 2
	replace wtaLoseInfo = (2.5  + 2   )/2 	if toNoInfoWTA == 2.5
	replace wtaLoseInfo = (3    + 2.5 )/2	  if toNoInfoWTA == 3
	replace wtaLoseInfo = (5    + 2.5 )/2 	if toNoInfoWTA == 5
	replace wtaLoseInfo = 5 								if toNoInfoWTA == 666


* POOLED WTA -------------------------------------------------------------------

gen pooledWTA = wtaLoseInfo if !missing(wtaLoseInfo)

	replace pooledWTA = -wtaGetInfo if !missing(wtaGetInfo)


*** BMI ************************************************************************

gen BMI = [(bodyweigth * 0.453592) / (selfReportedHeight/100)]  / 							///
					 (selfReportedHeight/100)

gen BMI_self = [(selfReportedWeight * 0.453592) / (selfReportedHeight/100)] / 	///
					    	(selfReportedHeight/100)

twoway (kdensity BMI) (kdensity BMI_self)


*** ACTUAL CALORIE CONSUMPTION *************************************************


* PRELIMINARIES

gen calGnocchi = 980
gen calFajitas = 782
gen calNicoise = 638
gen calMiddleE = 429

gen weightGnocchi = 9.7
gen weightFajitas = 9.1
gen weightNicoise = 10.7
gen weightMiddleE = 9


gen fullCalories = .

	replace fullCalories = calGnocchi if mealReceived == 1
	replace fullCalories = calFajitas if mealReceived == 2
	replace fullCalories = calNicoise if mealReceived == 3
	replace fullCalories = calMiddleE if mealReceived == 4


gen fullCaloriesControl = .	// this is for a treatment that is not used

	replace fullCaloriesControl = calGnocchi if mealSelected == 1
	replace fullCaloriesControl = calFajitas if mealSelected == 2
	replace fullCaloriesControl = calNicoise if mealSelected == 3
	replace fullCaloriesControl = calMiddleE if mealSelected == 4


gen mealConsumed = .

  replace mealConsumed = 1 - leftovers / weightGnocchi if mealReceived == 1
  replace mealConsumed = 1 - leftovers / weightFajitas if mealReceived == 2
  replace mealConsumed = 1 - leftovers / weightNicoise if mealReceived == 3
  replace mealConsumed = 1 - leftovers / weightMiddleE if mealReceived == 4

  replace mealConsumed = 0 if mealConsumed < 0


gen consumedCalories = fullCalories * mealConsumed

gen consumedCaloriesControl = fullCaloriesControl * mealConsumed


*** SAVE ***********************************************************************

save "$RUTA/results/lab_prenudge.dta", replace

*** END OF FILE ****************************************************************
********************************************************************************
