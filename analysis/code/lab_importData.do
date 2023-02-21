/*******************************************************************************
Author:       TabareCapitan.com

Description:  Import data from the lab experiment

Created: 20180424 | Last modified:  20200917
*******************************************************************************/

*** BINDING CHOICES ************************************************************

import delimited                                                                ///
        "$RUTA/rawData/lab/USDA2018-LIVE-KLAAS_March 8, 2018_13.28.csv",        ///
        clear delimiter(comma) bindquote(strict) varnames(1)                    ///
        stripquote(yes) rowrange(4) maxquotedrows(unlimited)

save "$RUTA/temp/data/raw_choices.dta", replace

*** BACKGROUND QUESTIONS *******************************************************

import delimited                                                                ///
        "$RUTA/rawData/lab/USDA2018-LIVE-Background_July 29, 2018_21.41.csv",   ///
        clear delimiter(comma) bindquote(strict) varnames(1)                    ///
        stripquote(yes) rowrange(4) maxquotedrows(unlimited)

save "$RUTA/temp/data/raw_background.dta", replace

*** WEIGHT MEASURES ************************************************************

import excel using "$RUTA/rawData/lab/WEIGHTS.xlsx", clear firstrow

drop H I

save "$RUTA/temp/data/raw_weights.dta", replace

*** END OF FILE ****************************************************************
********************************************************************************
