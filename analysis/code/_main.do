/*******************************************************************************
Author:       TabareCapitan.com

Description:  Controls the flow of the code

Created: 20180424 | Last modified: 20230219
*******************************************************************************/
version 17.0


*** SET UP *********************************************************************

do "$RUTA/code/_settings.do"

*do "$RUTA/code/_newPrograms.do"    // do not run by default  TODO:CHECK ALL USED

do "$RUTA/code/_parameters.do"


*** DATA MANAGEMENT ************************************************************

* LAB DATA ---------------------------------------------------------------------

do "$RUTA/code/lab_importData.do"

do "$RUTA/code/lab_cleanData_experiment.do"				

do "$RUTA/code/lab_cleanData_background.do"

do "$RUTA/code/lab_cleanData_weight.do"

do "$RUTA/code/lab_mergeData.do"

do "$RUTA/code/lab_newVariables.do"

* MTURK DATA -------------------------------------------------------------------

do "$RUTA/code/mturk_importData.do"

do "$RUTA/code/mturk_cleanData.do"

do "$RUTA/code/mturk_newVariables.do"


*** ANALYSES IN THE PAPER ******************************************************

do "$RUTA/code/analysis_1.do"       // results section


*** ONLINE APPENDICES **********************************************************

do "$RUTA/code/analysis_A.do"       // descriptive statistics

do "$RUTA/code/analysis_B.do"       // main result with covariates

do "$RUTA/code/analysis_C.do"       // WTA results with covariates

do "$RUTA/code/analysis_D.do"       // leftovers data

do "$RUTA/code/analysis_E.do"       // all about mturk experiment             


*** END OF FILE ****************************************************************
********************************************************************************
