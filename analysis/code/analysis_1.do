/*******************************************************************************
Author:       TabareCapitan.com

Description:  Creates all results in the body of the paper
              (Does not include results from appendices or footnotes)

Created: 20220301 | Last modified: 20230219
*******************************************************************************/

/* CONTENTS --------------------------------------------------------------------

      A. NUMBER OF OBSERVATIONS   ................... line 26
      B. INFORMATION AVOIDANCE    ................... line 46
      C. WTA DATA                 ................... line 139
      D. LEFTOVERS DATA           ................... line 229

   TREATMENTS ------------------------------------------------------------------

      C: Irrelevant control group (not used in the paper)
     TN: Relevant control group
     TF: Prenudge #1 (self-efficacy)
     TS: Prenudge #2 (long term consequences)
    --------------------------------------------------------------------------*/


*** A. NUMBER OF OBSERVATIONS PER TREATMENT ************************************

use "$RUTA\results\lab_prenudge.dta", clear

tab treatment


count if treatment == "TN"

    assert r(N) == 244        // Check data is as expected

count if treatment == "TS"

    assert r(N) == 242        // Check data is as expected

count if treatment == "TF"

    assert r(N) == 245        // Check data is as expected


*** B. INFORMATION AVOIDANCE ***************************************************

/*  The goal is to compare the share of participants who chose to receive
    information in each of the two treatment groups relative to the share
    of participants in the control group.                                     */


* THE EFFECT OF PRENUDGE #1 (SELF-EFFICACY) ------------------------------------

use "$RUTA\results\lab_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TS"

gen group = (treatment == "TS")


// LEVEL OF INFORMATION AVOIDANCE

tab infoSelected if group == 0

sum infoSelected if group == 0

    assert round(r(mean),.0001) == 0.6598 // Baseline: 34% info avoidance


sum infoSelected if group == 1

  assert round(r(mean),.0001) == 0.7397  // Prenudge: 26% info avoidance


// TREATMENT EFFECT AND INFERENCE

reg  infoSelected group

  // Treatment effect
  assert round(_b[group],0.001) == .08

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

  // Fisher's exact test
  ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                    reg infoSelected group
  // one-side test pvalue = 0.0346


* THE EFFECT OF PRENUDGE #2 (LONG-TERM CONSEQUENCES) ---------------------------

use "$RUTA\results\lab_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TF"

gen group = (treatment == "TF")


// LEVEL OF INFORMATION AVOIDANCE

tab infoSelected if group == 0

sum infoSelected if group == 0

    assert round(r(mean),.0001) == 0.6598 // Baseline: 34% info avoidance


sum infoSelected if group == 1

  assert round(r(mean),.0001) == 0.7184  // Prenudge: 28% info avoidance


// TREATMENT EFFECT AND INFERENCE

reg  infoSelected group

  // Treatment effect
  assert round(_b[group],0.0001) == .0585

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

  // Fisher's exact test
  ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                    reg infoSelected group
  // one-side test pvalue = 0.0944


*** C. WTA DATA ****************************************************************

/*  The goal is to compare the average willingness to accept (to change the
    information choice) in each treatment group vs the control group.

    The variable pooledWTA is created in lab_newVariables.do                  */


* THE EFFECT OF PRENUDGE #1 (SELF-EFFICACY) ------------------------------------

use "$RUTA\results\lab_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TS"

gen group = (treatment == "TS")


// LEVELS OF WTA

sum pooledWTA if group == 0

di round(r(mean),.0001)

  assert round(r(mean),.0001) == 0.4717 // WTA = 0.47 USD

sum pooledWTA if group == 1

di round(r(mean),.0001)

    assert round(r(mean),.0001) == 0.7798 // WTA = 0.78 USD


// TREATMENT EFFECT AND INFERENCE

reg  pooledWTA  group

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

  // Fisher's exact test
  ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                    reg pooledWTA group
  // one-side test pvalue = 0.0422


* THE EFFECT OF PRENUDGE #2 (LONG-TERM CONSEQUENCES) ---------------------------

use "$RUTA\results\lab_prenudge.dta", clear


keep if treatment == "TN" | treatment == "TF"

gen group = (treatment == "TF")


// LEVELS OF WTA

sum pooledWTA if group == 0

di round(r(mean),.0001)

  assert round(r(mean),.0001) == 0.4717 // WTA = 0.47 USD

sum pooledWTA if group == 1

di round(r(mean),.0001)

    assert round(r(mean),.0001) == 0.7854 // WTA = 0.79 USD


// TREATMENT EFFECT AND INFERENCE

reg  pooledWTA  group

  // one-sided pvalue (t-test)
  local t = _b[group]/_se[group]
  local p =ttail(e(df_r),abs(`t'))

  di `p'

  // Fisher's exact test
  ritest group _b[group], right seed($SEED) nodots reps($REPS):                 ///
                                                    reg pooledWTA group
  // one-side test pvalue = 0.0544


*** D. LEFTOVERS DATA **********************************************************

/*  The goal is to compare the actual calorie consumption across treatment
    groups. This measurement is contaminated since many participants got info
    when they chose not to, due to the multiple-price list. And viceversa.
    Furthermore, there are concerns about the quality of the data to begin with.
    Therefore, just reporting means.

    The results are all over the place and it's hard to interpret anything.

    The variable consumedCalories is created in lab_newVariables.do           */


use "$RUTA\results\lab_prenudge.dta", clear

// Unconditional average
by treatment, sort: sum consumedCalories

      // TF = 479 N = 234
      // TN = 503 N = 235
      // TS = 489 N = 235



*** END OF FILE ****************************************************************
********************************************************************************
