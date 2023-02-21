/*******************************************************************************
Author:       TabareCapitan.com

Description:  OLS conditional estimates using WTA data

Created: 20220301 | Last modified: 20220804
*******************************************************************************/


*** TN VS TS *******************************************************************

use "$RUTA\results\lab_prenudge.dta", clear

keep if treatment == "TN" | treatment == "TS"

gen group = (treatment == "TS")


// GET ALL ESTIMATES

// covariates that "make sense"
global COVS "hungryLevel female foodSelfControl BMI weightGoals_3 dieting knowsCalorieNeeds"

// Run all possible regressions

// for some reason is not running on atom
gsreg pooledWTA $COVS, fixvar(group) cmdoptions(robust) nocount             ///
                           replace resultsdta("$RUTA/temp/data/allRegs_TS_wta")


// Load data of all estimates

use "$RUTA/temp/data/allRegs_TS_wta.dta", clear

// Rename bars

gen stringUncond = "Unconditional"

rename v_1_b group_c

rename v_1_t group_t


// Calculate p-values

gen df = obs - nvar

gen group_p1T = ttail(df,abs(group_t))

gen group_p2T = 2*ttail(df,abs(group_t))

  order group_p*, after(group_t)


// Get frequencies

count

count if group_c > 0

count if group_c > 0.05

count if group_c > 0.1

count if group_c > 0.15

count if group_c > 0.2

count if group_p1T < 0.01

count if group_p1T < 0.05

count if group_p1T < 0.1


// PREPARE GRAPH

sum group_c if nvar == 2  // unconditional estimate

local yline = `r(mean)'

sum group_p1T if nvar == 2

local xline = `r(mean)'

#delimit ;

// CENTER GRAPH: SCATTER PLOT

twoway  (scatter group_c group_p1T,  msymbol(o) msize(small)  mcolor(gs10) )
        (scatter group_c group_p1T if nvar == 2,
        msymbol(s) msize(small)  mcolor(red) mlabel(stringUncond) mlabpos(6)  )
        ,
        xline(`xline', lcolor(red) lwidth(vthin) )
        yline(`yline', lcolor(red) lwidth(vthin) )
        legend(off)
        yscale(alt,)
        ylabel(0.20(0.01)0.34, ang(horizontal) )
        xscale(alt)
        xlabel(0.01 "0.01" 0.05 "0.05" 0.1 "0.1", grid gextend)
        xtitle("pvalue")
        ytitle("Treatment effect", orientation(rvertical))
        saving("$RUTA/temp/figures/middle.gph", replace);

// LEFT: HISTOGRAM OF COEFFICIENTS;

twoway  hist group_c ,
        ytitle("Treatment effect")
        yline(`yline', lcolor(red) lwidth(vthin) )
        fraction
        xsca(alt reverse)
        horiz
        fxsize(25)
        xlabel( #3, ang(h))
        ylabel(0.20(0.01)0.34, ang(h))
        saving("$RUTA/temp/figures/left.gph", replace);


// BOTTOM: HISTOGRAM OF PVALUES;

twoway  histogram group_p1T,
        xtitle("pvalue")
        xline(`xline', lcolor(red) lwidth(vthin) )
        fysize(25)
        fraction
        yscale(alt reverse)
        ylabel(0(0.07)0.21,nogrid ang(h))
        ytitle(,orientation(rvertical))
        xlabel(0.01 "0.01" 0.05 "0.05" 0.1 "0.1", grid gextend)
        saving("$RUTA/temp/figures/bottom.gph", replace);

// COMBINE ALL THREE GRAPHS

graph combine   "$RUTA/temp/figures/left.gph"
                "$RUTA/temp/figures/middle.gph"
                "$RUTA/temp/figures/bottom.gph"
                ,
                hole(3)
                imargin(0 0 0 0)
                graphregion(margin(l=22 r=22));

graph export "$RUTA/results/figures/oa_treatmentEffect_TS_wta.png",
                                    replace width(11000) height(8000);

#delimit cr


*** TN VS TF *******************************************************************

use "$RUTA\results\lab_prenudge.dta", clear

keep if treatment == "TN" | treatment == "TF"

gen group = (treatment == "TF")


// GET ALL ESTIMATES

// covariates that "make sense"
global COVS "hungryLevel female foodSelfControl BMI weightGoals_3 dieting knowsCalorieNeeds"

// Run all possible regressions

// for some reason is not running on atom
gsreg pooledWTA $COVS, fixvar(group) cmdoptions(robust) nocount             ///
                           replace resultsdta("$RUTA/temp/data/allRegs_TF_wta")


// Load data of all estimates

use "$RUTA/temp/data/allRegs_TF_wta.dta", clear


// Rename bars

gen stringUncond = "Unconditional"

rename v_1_b group_c

rename v_1_t group_t


// Calculate p-values

gen df = obs - nvar

gen group_p1T = ttail(df,abs(group_t))

gen group_p2T = 2*ttail(df,abs(group_t))

  order group_p*, after(group_t)


// Get frequencies

count

count if group_c > 0

count if group_c > 0.05

count if group_c > 0.1

count if group_c > 0.15

count if group_c > 0.2

count if group_p1T < 0.01

count if group_p1T < 0.05

count if group_p1T < 0.1


// PREPARE GRAPH

sum group_c if nvar == 2  // unconditional estimate

local yline = `r(mean)'

sum group_p1T if nvar == 2

local xline = `r(mean)'

#delimit ;

// CENTER GRAPH: SCATTER PLOT

twoway  (scatter group_c group_p1T,  msymbol(o) msize(small)  mcolor(gs10) )
        (scatter group_c group_p1T if nvar == 2,
        msymbol(s) msize(small)  mcolor(red) mlabel(stringUncond) mlabpos(6)  )
        ,
        xline(`xline', lcolor(red) lwidth(vthin) )
        yline(`yline', lcolor(red) lwidth(vthin) )
        legend(off)
        yscale(alt,)
        ylabel(0.24(0.01)0.34, ang(horizontal) )
        xscale(alt)
        xlabel(0.01 "0.01" 0.05 "0.05" 0.1 "0.1", grid gextend)
        xtitle("pvalue")
        ytitle("Treatment effect", orientation(rvertical))
        saving("$RUTA/temp/figures/middle.gph", replace);

// LEFT: HISTOGRAM OF COEFFICIENTS;

twoway  hist group_c ,
        ytitle("Treatment effect")
        yline(`yline', lcolor(red) lwidth(vthin) )
        fraction
        xsca(alt reverse)
        horiz
        fxsize(25)
        xlabel( #3, ang(h))
        ylabel(0.24(0.01)0.34, ang(h))
        saving("$RUTA/temp/figures/left.gph", replace);


// BOTTOM: HISTOGRAM OF PVALUES;

twoway  histogram group_p1T,
        xtitle("pvalue")
        xline(`xline', lcolor(red) lwidth(vthin) )
        fysize(25)
        fraction
        yscale(alt reverse)
        ylabel(0(0.07)0.21,nogrid ang(h))
        ytitle(,orientation(rvertical))
        xlabel(0.01 "0.01" 0.05 "0.05" 0.1 "0.1", grid gextend)
        saving("$RUTA/temp/figures/bottom.gph", replace);

// COMBINE ALL THREE GRAPHS

graph combine   "$RUTA/temp/figures/left.gph"
                "$RUTA/temp/figures/middle.gph"
                "$RUTA/temp/figures/bottom.gph"
                ,
                hole(3)
                imargin(0 0 0 0)
                graphregion(margin(l=22 r=22));

graph export "$RUTA/results/figures/oa_treatmentEffect_TF_wta.png",
                                    replace width(11000) height(8000);

#delimit cr



*** END OF FILE ****************************************************************
********************************************************************************
