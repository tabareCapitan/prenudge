/*******************************************************************************
Author:       TabareCapitan.com

Description:  Merge data related to choices, background, and weights

Created: 20180429 | Last modified: 20220718
*******************************************************************************/


*** LOAD CHOICES ***************************************************************

use "$RUTA/temp/data/clean_choices.dta", clear


*** MERGE WEIGHT DATA **********************************************************

merge 1:1 key using "$RUTA/temp/data/clean_weights.dta" // 21 with no weight data

  count if _merge == 1

  assert r(N) == 21              // Check the right # of obs merge

  drop _merge


*** MERGE BACKGROUND DATA ******************************************************

merge 1:1 key using "$RUTA/temp/data/clean_background.dta"

	// 3 obs completed experiment but not background

  count if _merge == 1

  assert r(N) == 3              // Check the right # of obs merge

  drop _merge


*** SAVE ***********************************************************************

drop key

save "$RUTA/temp/data/labData.dta", replace

*** END OF FILE ****************************************************************
********************************************************************************
