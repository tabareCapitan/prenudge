/*******************************************************************************
Paper:          Using prenudges to supercharge a nudge

Authors:        TabareCapitan.com
                Linda Thunstrom
                Klaas van 't Veld
                Jonas Nordstrom
                Jason Shogren

Description:    Replication code 

Input:          /rawData
                /code

Output:         /results/tables
                /results/figures

Created: 20200817 | Last modified: 20230219
*******************************************************************************/
version 17.0


*** DEFINE PROJECT PATH ********************************************************

global RUTA $PRENUDGE // Add your own project folder


*** DEFINE pdflatex PATH *******************************************************

global PDFLATEX "C:/texlive/2019/bin/win32/pdflatex"


*** INITIALIZE LOG AND RECORD SYSTEM PARAMETERS ********************************

clear

set more off

cap mkdir "$RUTA/code/logs"

cap log close

local datetime: di %tcCCYY.NN.DD!_HH.MM.SS `=clock("$S_DATE $S_TIME", "DMYhms")'

local logfile "$RUTA/code/logs/log_`datetime'.txt"

log using "`logfile'", text

di "Begin date and time:  $S_DATE $S_TIME"
di "Stata version:        `c(stata_version)'"
di "Updated as of:        `c(born_date)'"
di "Variant:              `=cond( c(MP),"MP",cond(c(SE),"SE",c(flavor)) )'"
di "Processors:           `c(processors)'"
di "OS:                   `c(os)' `c(osdtl)'"
di "Machine type:         `c(machine_type)'"


*** USER-WRITTEN PACKAGES AND PROJECT PROGRAMS *********************************

adopath ++ "$RUTA/code/libraries/stata"

adopath ++ "$RUTA/code/programs"


*** CREATE DIRECTORIES FOR TEMPORARY AND OUTPUT FILES **************************

cap mkdir "$RUTA/temp"
cap mkdir "$RUTA/temp/data"
cap mkdir "$RUTA/temp/figures"

cap mkdir "$RUTA/results"
cap mkdir "$RUTA/results/figures"
cap mkdir "$RUTA/results/tables"


*** RUN ANALYSIS ***************************************************************

do "$RUTA/code/_main.do"


*** END LOG ********************************************************************

di "End date and time: $S_DATE $S_TIME"

log close

*** END OF DOFILE **************************************************************
********************************************************************************
