/*******************************************************************************
Project:      Prenudge

Author:       TabareCapitan.com

Description:  Clean data related to the body and leftovers weighted in the lab

Created: 20180429 | Last modified: 20220718
*******************************************************************************/

*** LOAD DATA ******************************************************************

use "$RUTA/temp/data/raw_weights.dta", clear


*** RENAME *********************************************************************

rename order _weightOrder

rename date _weightDate

rename time _weightTime

rename weightNotes _weightNotes

rename weightLeftovers leftovers

rename weightBody bodyweigth    // in pounds


*** FIX INCONSISTENCIES ********************************************************

replace key = 123 if key == 125 & leftovers == 8.1		// 125 was repeated

replace key = 261 if key == 201 & leftovers == 0.9

replace key = 268 if key == 286 & leftovers == 0.9

replace key = 336 if key == 366 & leftovers == 2.9

replace key = 489 if key == 480 & leftovers == 1.2   	// Not conclusive. Body weight: 148.4 vs 154.4. Self reported: 140 vs 150. It's consistent when checking out end time and weight order as reported

replace key = 453 if key == 493 & leftovers == 1.1

replace key = 444 if key == 494

replace key = 550 if key == 540 & leftovers == 2.6

replace key = 589 if key == 580 & leftovers == 4.3

replace key = 624 if key == 629 & leftovers == 3.1

replace key = 824 if key == 829 & leftovers == 1.7

replace key = 842 if key == 892 & leftovers == 1

replace key = 935 if key == 983 & leftovers == 5.9

replace key = 649 if key == 249

replace key = 644 if key == 344


*** SAVE ***********************************************************************

order key, first

save "$RUTA/temp/data/clean_weights.dta", replace

*** END OF FILE ****************************************************************
********************************************************************************
