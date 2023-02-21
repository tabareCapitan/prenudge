/*******************************************************************************
Author:       TabareCapitan.com

Description:  PENDING

Created: 20190411 | Last modified: 20220804
*******************************************************************************/

*** LOAD DATA ******************************************************************

use "$RUTA/temp/data/clean_mturk.dta", clear

tab toInfoWTA

*** CALCULATE WTA **************************************************************

* WTA TO GET INFO --------------------------------------------------------------

gen wtaGetInfo = .

  replace wtaGetInfo = 0.01             if toInfoWTA == 0.01
  replace wtaGetInfo = (0.25 + 0.01)/2  if toInfoWTA == 0.25
  replace wtaGetInfo = (0.5  + 0.25)/2  if toInfoWTA == 0.5
  replace wtaGetInfo = (0.75 + 0.5 )/2  if toInfoWTA == 0.75
  replace wtaGetInfo = (1    + 0.75)/2  if toInfoWTA == 1
  replace wtaGetInfo = (1.5  + 1   )/2  if toInfoWTA == 1.5
  replace wtaGetInfo = (2    + 1.5 )/2  if toInfoWTA == 2
  replace wtaGetInfo = (2.5  + 2   )/2  if toInfoWTA == 2.5
  replace wtaGetInfo = (3    + 2.5 )/2  if toInfoWTA == 3
  replace wtaGetInfo = (5    + 2.5 )/2  if toInfoWTA == 5
  replace wtaGetInfo = 5                if toInfoWTA == 666


* WTA TO LOSE INFO -------------------------------------------------------------

gen wtaLoseInfo = .

  replace wtaLoseInfo = 0.01              if toNoInfoWTA == 0.01
  replace wtaLoseInfo = (0.25 + 0.01)/2   if toNoInfoWTA == 0.25
  replace wtaLoseInfo = (0.5  + 0.25)/2   if toNoInfoWTA == 0.5
  replace wtaLoseInfo = (0.75 + 0.5 )/2   if toNoInfoWTA == 0.75
  replace wtaLoseInfo = (1    + 0.75)/2   if toNoInfoWTA == 1
  replace wtaLoseInfo = (1.5  + 1   )/2   if toNoInfoWTA == 1.5
  replace wtaLoseInfo = (2    + 1.5 )/2   if toNoInfoWTA == 2
  replace wtaLoseInfo = (2.5  + 2   )/2   if toNoInfoWTA == 2.5
  replace wtaLoseInfo = (3    + 2.5 )/2   if toNoInfoWTA == 3
  replace wtaLoseInfo = (5    + 2.5 )/2   if toNoInfoWTA == 5
  replace wtaLoseInfo = 5                 if toNoInfoWTA == 666


* POOLED WTA -------------------------------------------------------------------

gen pooledWTA = wtaLoseInfo if !missing(wtaLoseInfo)

  replace pooledWTA = -wtaGetInfo if !missing(wtaGetInfo)


*** SAVE ***********************************************************************

save "$RUTA/results/mturk_prenudge.dta", replace

*** END OF FILE ****************************************************************
********************************************************************************
