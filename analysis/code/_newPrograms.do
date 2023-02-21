/*******************************************************************************
Author:       TabareCapitan.com

Description:  Install required user-written programs (.ado)

Created: 20200408| Last modified: 202020718
*******************************************************************************/

*** CREATE AND DEFINE A LOCAL INSTALLATION DIRECTORY ***************************

cap mkdir "$RUTA/code/libraries"

cap mkdir "$RUTA/code/libraries/stata"

net set ado "$RUTA/code/libraries/stata"


*** INSTALL USER-WRITTEN PROGRAMS **********************************************

cap ssc install grc1leg

cap ssc install ritest

cap ssc install gsreg

cap net install texsave,                                                        ///
    from("https://raw.githubusercontent.com/reifjulian/texsave/master") replace

cap ssc install texdoc, replace

    net from http://www.stata-journal.com/production

    net install sjlatex


 // ssc install svmatf, replace
  // dependency: net install dm79.pkg

*** END OF FILE ****************************************************************
********************************************************************************
