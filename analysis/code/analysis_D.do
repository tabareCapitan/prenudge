/*******************************************************************************
Author:       TabareCapitan.com

Description:  Meal leftovers data

Created: 20220301 | Last modified: 20220730
*******************************************************************************/

*** LOAD DATA ******************************************************************

use "$RUTA\results\lab_prenudge.dta", clear

drop if treatment == "C" // drop irrelevant experimental group

// Percentage of participants receiving the menu they preferred

gen temp = infoSelected + infoReceived

tab temp

by treatment, sort: tab temp

drop temp

// Average for those who wanted and received info
gen temp = infoSelected == 1 & infoReceived == 1

by treatment, sort: sum consumedCalories if temp == 1

drop temp

      // TF = 449 N = 73
      // TN = 489 N = 67
      // TS = 489 N = 79

// Average for those who wanted and did not received info
gen temp = infoSelected == 1 & infoReceived == 0

by treatment, sort: sum consumedCalories if temp == 1

drop temp

      // TF = 487 N=94
      // TN = 473 N=88
      // TS = 475 N=96

// Average for those who didn't want and did not received info
gen temp = infoSelected == 0 & infoReceived == 0

by treatment, sort: sum consumedCalories if temp == 1

drop temp

      // TF = 510 N = 31
      // TN = 504 N = 24
      // TS = 570 N = 26


// Average for those who didn't want and received info
gen temp = infoSelected == 0 & infoReceived == 1

by treatment, sort: sum consumedCalories if temp == 1

drop temp

    // TF = 492 N = 36
    // TN = 566 N = 56
    // TS = 464 N = 34


// However, people who wanted info consumed less

reg consumedCalories infoSelected

// Which is driven by the control group

reg consumedCalories infoSelected if treatment == "TN"

// Prenudges reduce the effect of preferring info on consumption, perhaps
// because they have a direct effect on calorie consumption beyond the potential
// indirect effect of reducing info avoidance. This is consistent with lower
// constant in both cases (vs 547 in control).

reg consumedCalories infoSelected if treatment == "TS"

reg consumedCalories infoSelected if treatment == "TF"


// Also, receiving calories don't seem to matter, in general,

reg consumedCalories infoReceived

// a little bit for the control group,

reg consumedCalories infoReceived if treatment == "TN"


// but certainly not for prenudge groups, which seem to increase the constant,
// which is a bit of a puzzle, but this data is not good enough to push it

reg consumedCalories infoReceived if treatment == "TS"

reg consumedCalories infoReceived if treatment == "TF"


*** END OF FILE ****************************************************************
********************************************************************************
