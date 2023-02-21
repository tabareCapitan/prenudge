/*******************************************************************************
Author:       TabareCapitan.com

Description:  Import data from online experiment

Created: 20180424 | Last modified:  20230219
*******************************************************************************/

import delimited                                 																///
	      "$RUTA/rawData/mturk/USDAmTurk2018 Klaas_July 17, 2018_10.22.csv",  		///
	      clear delimiter(comma) bindquote(strict) varnames(1)                    ///
        stripquote(yes) rowrange(4) maxquotedrows(unlimited)

save "$RUTA/temp/data/raw_mturk.dta", replace

*** END OF FILE ****************************************************************
********************************************************************************
