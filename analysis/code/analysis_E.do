/*******************************************************************************
Author:       TabareCapitan.com

Description:  All related to the online experiment

Created: 20220301 | Last modified: 20220804
*******************************************************************************/

/* CONTENTS --------------------------------------------------------------------

      A. NUMBER OF OBSERVATIONS   ................... line x
      B. DESCRIPTIVE STATISTICS   ....................line x
      x. INFORMATION AVOIDANCE    ................... line x
      x. VALUE OF INFORMATION     ................... line X

   TREATMENTS ------------------------------------------------------------------

      C: Irrelevant control group (not used in the paper)
     TN: Relevant control group
     TF: Prenudge #1 (self-efficacy)
     TS: Prenudge #2 (long term consequences)
     TU: Prenudge #3 (optimal expectations)
     TA: Prenudge #4 (diffusion of responsabilities)
    --------------------------------------------------------------------------*/


*** NUMBER OF OBSERVATIONS *****************************************************

use "$RUTA\results\mturk_prenudge.dta", clear

drop if treatment == "C"

tab treatment


*** DESCRIPTIVE STATISTICS *****************************************************

use "$RUTA\results\mturk_prenudge.dta", clear

drop if treatment == "C"


gen female = .
  replace female = 1 if gender == 1
  replace female = 0 if gender == 2

sum female age


tab education

tab income

tab riskPreferences


sum foodSelfControl

twoway  histogram foodSelfControl,  fraction                                    ///
                  ylabel(,ang(h))                                               ///
                  xtitle("Eating-self-control")

graph export "$RUTA/results/figures/oa_selfControl_mturk.png",                  ///
                                    replace width(11000) height(8000)

*** CHOICE-PROCESS DATA ********************************************************

* DATA FROM THE LABORATORY EXPERIMENT ------------------------------------------

use "$RUTA\results\lab_prenudge.dta", clear

drop if treatment == "C"

centile _uwcattiming_pagesubmit _tstiming_pagesubmit _tftiming_pagesubmit


* DATA FROM THE ONLINE EXPERIMENT ---------------------------------------------

use "$RUTA\results\mturk_prenudge.dta", clear

drop if treatment == "C"

centile _restauranttiming_pagesubmit _tstiming_pagesubmit _tftiming_pagesubmit  ///
                                     _tutiming_pagesubmit _tatiming_pagesubmit


*** MPL DATA - DISTRIBUTION ****************************************************

* DATA FROM THE LABORATORY EXPERIMENT ------------------------------------------

use "$RUTA\results\lab_prenudge.dta", clear

drop if treatment == "C"

tab pooledWTA

hist pooledWTA


* DATA FROM THE ONLINE EXPERIMENT ----------------------------------------------

use "$RUTA\results\mturk_prenudge.dta", clear

drop if treatment == "C"

tab pooledWTA

hist pooledWTA


*** INFORMATION AVOIDANCE ******************************************************

* THE EFFECT OF PRENUDGE #1 (SELF-EFFICACY) ------------------------------------

use "$RUTA\results\mturk_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TS"

gen group = (treatment == "TS")


// LEVEL OF INFORMATION AVOIDANCE

sum infoChoice if group == 0

    assert round(r(mean),.0001) == 0.7097 // Baseline: 29% info avoidance


sum infoChoice if group == 1

  assert round(r(mean),.0001) == 0.7717  // Prenudge: 23% info avoidance


// TREATMENT EFFECT AND INFERENCE

reg  infoChoice group

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

  // Fisher's exact test
  ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                    reg infoChoice group
  // one-side test pvalue = 0.2176


* THE EFFECT OF PRENUDGE #2 (LONG-TERM) --------------------------------------

use "$RUTA\results\mturk_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TF"

gen group = (treatment == "TF")


// LEVEL OF INFORMATION AVOIDANCE

sum infoChoice if group == 0

    assert round(r(mean),.0001) == 0.7097 // Baseline: 29% info avoidance


sum infoChoice if group == 1


  assert round(r(mean),.0001) == 0.8557


// TREATMENT EFFECT AND INFERENCE

reg  infoChoice group

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

// Fisher's exact test
ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                  reg infoChoice group
  // one-side test pvalue = 0.0104


* THE EFFECT OF PRENUDGE #3 (OPTIMAL-EXPECTATIONS) -----------------------------

use "$RUTA\results\mturk_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TU"

gen group = (treatment == "TU")


// LEVEL OF INFORMATION AVOIDANCE

sum infoChoice if group == 0

    assert round(r(mean),.0001) == 0.7097 // Baseline: 29% info avoidance


sum infoChoice if group == 1


  assert round(r(mean),.0001) == 0.8333


// TREATMENT EFFECT AND INFERENCE

reg  infoChoice group

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

  // Fisher's exact test
  ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                    reg infoChoice group
  // one-side test pvalue = 0.0342



* THE EFFECT OF PRENUDGE #4 (DIFFUSION OF RESPONSABILITY) ----------------------

use "$RUTA\results\mturk_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TA"

gen group = (treatment == "TA")


// LEVEL OF INFORMATION AVOIDANCE

sum infoChoice if group == 0

    assert round(r(mean),.0001) == 0.7097 // Baseline: 29% info avoidance


sum infoChoice if group == 1

  di  round(r(mean),.0001)

  // assert round(r(mean),.0001) == .7474 // This should be true! Damn Stata!


// TREATMENT EFFECT AND INFERENCE

reg  infoChoice group

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

  // Fisher's exact test
  ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                    reg infoChoice group
  // one-side test pvalue = 0.3372



*** THE VALUE OF INFORMATION ***************************************************

* THE EFFECT OF PRENUDGE #1 (SELF-EFFICACY) ------------------------------------

use "$RUTA\results\mturk_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TS"

gen group = (treatment == "TS")


// WTA

sum pooledWTA if group == 0


sum pooledWTA if group == 1


// TREATMENT EFFECT AND INFERENCE

reg  pooledWTA group

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

  // Fisher's exact test
  ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                    reg pooledWTA group


* THE EFFECT OF PRENUDGE #2 (LONG-TERM) --------------------------------------

use "$RUTA\results\mturk_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TF"

gen group = (treatment == "TF")


// LEVEL

sum pooledWTA if group == 0

sum infoChoice if group == 1


// TREATMENT EFFECT AND INFERENCE

reg  pooledWTA group

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

// Fisher's exact test
ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                  reg pooledWTA group


* THE EFFECT OF PRENUDGE #3 (OPTIMAL-EXPECTATIONS) -----------------------------

use "$RUTA\results\mturk_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TU"

gen group = (treatment == "TU")


// LEVEL

sum pooledWTA if group == 0

sum pooledWTA if group == 1


// TREATMENT EFFECT AND INFERENCE

reg  pooledWTA group

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

// Fisher's exact test
ritest group _b[group], right seed($SEED) nodots reps($REPS):                   ///
                                                  reg pooledWTA group




* THE EFFECT OF PRENUDGE #4 (DIFFUSION OF RESPONSABILITY) ----------------------

use "$RUTA\results\mturk_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TA"

gen group = (treatment == "TA")


// LEVEL

sum pooledWTA if group == 0

sum infoChoice if group == 1


// TREATMENT EFFECT AND INFERENCE

reg pooledWTA group

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

// Fisher's exact test
ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                  reg pooledWTA group

*** OTHERS *********************************************************************







*** END OF FILE ****************************************************************
********************************************************************************
