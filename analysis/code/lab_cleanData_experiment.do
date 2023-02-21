/*******************************************************************************
Author:       TabareCapitan.com

Description:  Clean data related to choices in the experiment

Created: 20180429 | Last modified: 20220718
*******************************************************************************/

*** LOAD DATA ******************************************************************

use "$RUTA/temp/data/raw_choices.dta", clear

count

*** VALID OBSERVATIONS *********************************************************

gen valid = (progress == "100")                                             &    ///
            (finished == "True")                                            &    ///
            (introveg == "No, I am not a vegetarian/vegan")                 &    ///
            (introallergy == "No, I do not have any food allergies")

drop progress finished introveg introallergy

drop if !valid

drop valid

*** VALIDATE UNIQUE ID *********************************************************

destring(id1), replace

destring(id2), replace

gen tag = id1 == id2

tab tag  // 2 inconsistencies


replace id2 = 241 if id1 == 241   // Mistake indicating id2

replace id1 = 619 if id2 == 619   // Mistake indicating id2


gen id = id1

drop id1 id2 tag

order id, first

*** TIME VARIABLES  ************************************************************

gen double _startDate = clock(startdate, "YMD hms")

  format _startDate %tc

  drop startdate

gen double _endDate = clock(enddate, "YMD hms")

  format _endDate %tc

  drop enddate

gen double _recordedDate = clock(recordeddate, "YMD hms")

  format _recordedDate %tc

  drop recordeddate


*** MEAL TIME AND DATE *********************************************************

* MEAL TIME --------------------------------------------------------------------

gen double temp = _startDate - cofd(dofc(_startDate))  // keep time, remove date

format temp %tc

gen _mealTime = ( temp > clock("01jan1960 13:15:00", "DMYhms") )
  // 0: Lunch
  // 1: Dinner

  order _mealTime, after(_recordedDate)

drop temp


* SESSION NUMBER ---------------------------------------------------------------

// Feb 13th

gen     _session = 1 if (_startDate > clock("13feb2018 10:45:00", "DMYhms")) &  ///
                (_startDate < clock("13feb2018 11:45:00", "DMYhms"))

replace _session = 2 if (_startDate > clock("13feb2018 11:45:00", "DMYhms")) &  ///
                (_startDate < clock("13feb2018 12:45:00", "DMYhms"))

replace _session = 3 if (_startDate > clock("13feb2018 16:45:00", "DMYhms")) &  ///
                (_startDate < clock("13feb2018 17:45:00", "DMYhms"))

replace _session = 4 if (_startDate > clock("13feb2018 17:45:00", "DMYhms")) &  ///
                (_startDate < clock("13feb2018 18:45:00", "DMYhms"))

// Feb 14th

replace _session = 5 if (_startDate > clock("14feb2018 10:45:00", "DMYhms")) &  ///
                (_startDate < clock("14feb2018 11:45:00", "DMYhms"))

replace _session = 6 if (_startDate > clock("14feb2018 11:45:00", "DMYhms")) &  ///
                (_startDate < clock("14feb2018 12:45:00", "DMYhms"))

replace _session = 7 if (_startDate > clock("14feb2018 16:45:00", "DMYhms")) &  ///
                (_startDate < clock("14feb2018 17:45:00", "DMYhms"))

replace _session = 8 if (_startDate > clock("14feb2018 17:45:00", "DMYhms")) &  ///
                (_startDate < clock("14feb2018 18:45:00", "DMYhms"))

// Feb 15th

replace _session = 9  if (_startDate > clock("15feb2018 10:45:00", "DMYhms")) &  ///
                 (_startDate < clock("15feb2018 11:45:00", "DMYhms"))

replace _session = 10 if (_startDate > clock("15feb2018 11:45:00", "DMYhms")) &  ///
                 (_startDate < clock("15feb2018 12:45:00", "DMYhms"))

replace _session = 11 if (_startDate > clock("15feb2018 16:45:00", "DMYhms")) &  ///
                 (_startDate < clock("15feb2018 17:45:00", "DMYhms"))

replace _session = 12 if (_startDate > clock("15feb2018 17:45:00", "DMYhms")) &  ///
                 (_startDate < clock("15feb2018 18:45:00", "DMYhms"))

// Feb 20th

replace _session = 13 if (_startDate > clock("20feb2018 16:45:00", "DMYhms")) &  ///
                 (_startDate < clock("20feb2018 17:45:00", "DMYhms"))

replace _session = 14 if (_startDate > clock("20feb2018 17:45:00", "DMYhms")) &  ///
                 (_startDate < clock("20feb2018 18:45:00", "DMYhms"))

// Feb 21st

replace _session = 15 if (_startDate > clock("21feb2018 10:45:00", "DMYhms")) &  ///
                 (_startDate < clock("21feb2018 11:45:00", "DMYhms"))

replace _session = 16 if (_startDate > clock("21feb2018 11:45:00", "DMYhms")) &  ///
                 (_startDate < clock("21feb2018 12:45:00", "DMYhms"))

// Feb 22nd

replace _session = 17 if (_startDate > clock("22feb2018 10:45:00", "DMYhms")) &  ///
                 (_startDate < clock("22feb2018 11:45:00", "DMYhms"))

replace _session = 18 if (_startDate > clock("22feb2018 11:45:00", "DMYhms")) &  ///
                 (_startDate < clock("22feb2018 12:45:00", "DMYhms"))

replace _session = 19 if (_startDate > clock("22feb2018 16:45:00", "DMYhms")) &  ///
                 (_startDate < clock("22feb2018 17:45:00", "DMYhms"))

replace _session = 20 if (_startDate > clock("22feb2018 17:45:00", "DMYhms")) &  ///
                 (_startDate < clock("22feb2018 18:45:00", "DMYhms"))

// Feb 27th

replace _session = 21 if (_startDate > clock("27feb2018 10:45:00", "DMYhms")) &  ///
                 (_startDate < clock("27feb2018 11:45:00", "DMYhms"))

replace _session = 22 if (_startDate > clock("27feb2018 11:45:00", "DMYhms")) &  ///
                 (_startDate < clock("27feb2018 12:45:00", "DMYhms"))

replace _session = 23 if (_startDate > clock("27feb2018 16:45:00", "DMYhms")) &  ///
                 (_startDate < clock("27feb2018 17:45:00", "DMYhms"))

replace _session = 24 if (_startDate > clock("27feb2018 17:45:00", "DMYhms")) &  ///
                 (_startDate < clock("27feb2018 18:45:00", "DMYhms"))

// Feb 28th

replace _session = 25 if (_startDate > clock("28feb2018 10:45:00", "DMYhms")) &  ///
                 (_startDate < clock("28feb2018 11:45:00", "DMYhms"))

replace _session = 26 if (_startDate > clock("28feb2018 11:45:00", "DMYhms")) &  ///
                 (_startDate < clock("28feb2018 12:45:00", "DMYhms"))

replace _session = 27 if (_startDate > clock("28feb2018 16:45:00", "DMYhms")) &  ///
                 (_startDate < clock("28feb2018 17:45:00", "DMYhms"))

replace _session = 28 if (_startDate > clock("28feb2018 17:45:00", "DMYhms")) &  ///
                 (_startDate < clock("28feb2018 18:45:00", "DMYhms"))

// March 1st

replace _session = 29 if (_startDate > clock("01mar2018 16:45:00", "DMYhms")) &  ///
                 (_startDate < clock("01mar2018 17:45:00", "DMYhms"))

replace _session = 30 if (_startDate > clock("01mar2018 17:45:00", "DMYhms")) &  ///
                 (_startDate < clock("01mar2018 18:45:00", "DMYhms"))

// March 6th

replace _session = 31 if (_startDate > clock("06mar2018 17:45:00", "DMYhms")) &  ///
                 (_startDate < clock("06mar2018 18:45:00", "DMYhms"))

// March 7th

replace _session = 32 if (_startDate > clock("07mar2018 17:45:00", "DMYhms")) &  ///
                 (_startDate < clock("07mar2018 18:45:00", "DMYhms"))

// March 8th

replace _session = 33 if (_startDate > clock("08mar2018 10:45:00", "DMYhms")) &  ///
                 (_startDate < clock("08mar2018 11:45:00", "DMYhms"))

replace _session = 34 if (_startDate > clock("08mar2018 11:45:00", "DMYhms")) &  ///
                 (_startDate < clock("08mar2018 12:45:00", "DMYhms"))


order _session, after(_mealTime)


* EXPERIMENTAL LABORATORY ------------------------------------------------------

// 0: College of Bussiness (COB), 1: Engineering (EN)
gen _lab = ( _session <= 10 & _session != 5 & _session != 6 )              |    ///
           ( _session > 18 & _session < 23 ) | ( _session == 27 )          |    ///
           ( _session == 28 ) | ( _session == 31 ) | ( _session == 32 )

order _lab, after(_session)

*** METADATA *******************************************************************

order treatment, first

rename treatmentfinal outcomeGroup

replace outcomeGroup = "C" if missing(outcomeGroup) // i.e., control

  order outcomeGroup, after(treatment)

drop status ipaddress


destring(durationinseconds), replace

  rename durationinseconds _totalDuration

  order _totalDuration, after(_recordedDate)


drop responseid recipientlastname recipientfirstname recipientemail              ///
     externalreference


rename locationlatitude _latitude

  order _latitude, after(_lab)

rename locationlongitude _longitude

  order _longitude, after(_latitude)


drop distributionchannel userlanguage


rename menu _menuOrder  // Menu order

  order _menuOrder, before(_startDate)

*** SLIDERS: MEAL PREFERENCE ***************************************************

/* Note that meal X in slider Y varies by person due to randomization.

  I.   Get value of slider per meal for those who didn't receive information.
  II.  Get value of slider per meal for those who did    receive information.
  III. Combine both into one variable per meal.
*/

* DID NOT RECEIVE INFORMATION

gen sliderNoInfoGnocchi =          slidern_1 if item1meal == "1"
  replace sliderNoInfoGnocchi =    slidern_2 if item2meal == "1"
  replace sliderNoInfoGnocchi =    slidern_3 if item3meal == "1"
  replace sliderNoInfoGnocchi =    slidern_4 if item4meal == "1"

  destring(sliderNoInfoGnocchi), replace

gen sliderNoInfoFajitas =          slidern_1 if item1meal == "2"
  replace sliderNoInfoFajitas =    slidern_2 if item2meal == "2"
  replace sliderNoInfoFajitas =    slidern_3 if item3meal == "2"
  replace sliderNoInfoFajitas =    slidern_4 if item4meal == "2"

  destring(sliderNoInfoFajitas), replace

gen sliderNoInfoNicoise =          slidern_1 if item1meal == "3"
  replace sliderNoInfoNicoise =    slidern_2 if item2meal == "3"
  replace sliderNoInfoNicoise =    slidern_3 if item3meal == "3"
  replace sliderNoInfoNicoise =    slidern_4 if item4meal == "3"

  destring(sliderNoInfoNicoise), replace

gen sliderNoInfoMiddleE =          slidern_1 if item1meal == "4"
  replace sliderNoInfoMiddleE =    slidern_2 if item2meal == "4"
  replace sliderNoInfoMiddleE =    slidern_3 if item3meal == "4"
  replace sliderNoInfoMiddleE =    slidern_4 if item4meal == "4"

  destring(sliderNoInfoMiddleE), replace

drop slidern_*

* RECEIVED INFORMATION

gen sliderInfoGnocchi =          slideri_1 if item1meal == "1"
  replace sliderInfoGnocchi =    slideri_2 if item2meal == "1"
  replace sliderInfoGnocchi =    slideri_3 if item3meal == "1"
  replace sliderInfoGnocchi =    slideri_4 if item4meal == "1"

  destring(sliderInfoGnocchi), replace

gen sliderInfoFajitas =          slideri_1 if item1meal == "2"
  replace sliderInfoFajitas =    slideri_2 if item2meal == "2"
  replace sliderInfoFajitas =    slideri_3 if item3meal == "2"
  replace sliderInfoFajitas =    slideri_4 if item4meal == "2"

  destring(sliderInfoFajitas), replace

gen sliderInfoNicoise =           slideri_1 if item1meal == "3"
  replace sliderInfoNicoise =    slideri_2 if item2meal == "3"
  replace sliderInfoNicoise =    slideri_3 if item3meal == "3"
  replace sliderInfoNicoise =    slideri_4 if item4meal == "3"

  destring(sliderInfoNicoise), replace

gen sliderInfoMiddleE =          slideri_1 if item1meal == "4"
  replace sliderInfoMiddleE =    slideri_2 if item2meal == "4"
  replace sliderInfoMiddleE =    slideri_3 if item3meal == "4"
  replace sliderInfoMiddleE =    slideri_4 if item4meal == "4"

  destring(sliderInfoMiddleE), replace

drop slideri_*

* COMBINE BOTH INTO ONE VARIABLE PER MEAL

egen sliderGnocchi = rowtotal(slider*Gnocchi)

egen sliderFajitas = rowtotal(slider*Fajitas)

egen sliderNicoise = rowtotal(slider*Nicoise)

egen sliderMiddleE = rowtotal(slider*MiddleE)


order slider*, after(outcomeGroup)

drop sliderInfo* sliderNoInfo*


*** SELECTED MEAL **************************************************************

gen mealSelected = .

  replace mealSelected = 1 if mealori == "Chicken/Salami Gnocchi"
  replace mealSelected = 2 if mealori == "Red Rice/Fajita Chicken"
  replace mealSelected = 3 if mealori == "Chicken Nicoise"
  replace mealSelected = 4 if mealori == "Middle Eastern Pasta with Chicken"

  order mealSelected, after(sliderMiddleE)

  drop mealori

gen mealAlternative = .

  replace mealAlternative = 1 if mealalt == "Chicken/Salami Gnocchi"
  replace mealAlternative = 2 if mealalt == "Red Rice/Fajita Chicken"
  replace mealAlternative = 3 if mealalt == "Chicken Nicoise"
  replace mealAlternative = 4 if mealalt == "Middle Eastern Pasta with Chicken"

  order mealAlternative, after(mealSelected)

  drop mealalt

gen mealReceived = .

  replace mealReceived = 1 if mealget == "Chicken/Salami Gnocchi"
  replace mealReceived = 2 if mealget == "Red Rice/Fajita Chicken"
  replace mealReceived = 3 if mealget == "Chicken Nicoise"
  replace mealReceived = 4 if mealget == "Middle Eastern Pasta with Chicken"

  order mealReceived, after(mealAlternative)

  drop mealget


*** WTA TO SWITCH MEAL *********************************************************

rename cswpat shiftMealPattern

  order shiftMealPattern, after(mealReceived)

// I did not end up using this variables
forvalues i = 1(1)10{

  destring(csw`i'), replace

  rename csw`i' switchMeal_`i'

  order switchMeal_`i', before(introhungry)

  drop cswitch_cswitch_`i'

}

replace cwta = "666"  if cwta == "666"
replace cwta = "0.01"  if cwta == "$0.01"
replace cwta = "0.25"   if cwta == "$0.25"
replace cwta = "0.50"  if cwta == "$0.50"
replace cwta = "0.75"   if cwta == "$0.75"
replace cwta = "1"     if cwta == "$1"
replace cwta = "1.50"    if cwta == "$1.50"
replace cwta = "2"    if cwta == "$2"
replace cwta = "2.50"    if cwta == "$2.50"
replace cwta = "3"    if cwta == "$3"
replace cwta = "5"    if cwta == "$5"

destring(cwta), replace

rename cwta mealWTA

order mealWTA, after(switchMeal_10)

** INFO CHOICES ****************************************************************

rename wantinfo infoSelected

  destring(infoSelected), replace

  order infoSelected, after(outcomeGroup)

drop tinfochoice


rename getinfo infoReceived

  destring(infoReceived), replace

  order infoReceived, after(infoSelected)


*** WTA TO SWITCH INFO CHOICE **************************************************

* SWITCH: NO INFO -> INFO ------------------------------------------------------

rename tniswpat shiftToInfoPattern

  order shiftToInfoPattern, after(infoReceived)

forvalues i = 1(1)10{

  destring(tnisw`i'), replace

  rename tnisw`i' switchToInfo_`i'

  order switchToInfo_`i', before(sliderGnocchi)

  drop tswitch_ni_tswitch_ni_`i'
}

replace tniwta = "666"     if tniwta == "666"
replace tniwta = "0.01"    if tniwta == "$0.01"
replace tniwta = "0.25"   if tniwta == "$0.25"
replace tniwta = "0.50"    if tniwta == "$0.50"
replace tniwta = "0.75"   if tniwta == "$0.75"
replace tniwta = "1"     if tniwta == "$1"
replace tniwta = "1.50"    if tniwta == "$1.50"
replace tniwta = "2"    if tniwta == "$2"
replace tniwta = "2.50"    if tniwta == "$2.50"
replace tniwta = "3"      if tniwta == "$3"
replace tniwta = "5"      if tniwta == "$5"

destring(tniwta), replace

rename tniwta toInfoWTA

order toInfoWTA, after(switchToInfo_10)

* SWITCH: INFO -> NO INFO ------------------------------------------------------

rename tinswpat shiftToNoInfoPattern

  order shiftToNoInfoPattern, after(shiftToInfoPattern)

forvalues i = 1(1)10{

  destring(tinsw`i'), replace

  rename tinsw`i' switchToNoInfo_`i'

  order switchToNoInfo_`i', before(toInfoWTA)

  drop tswitch_in_tswitch_in_`i'
}


replace tinwta = "666"  if tinwta == "666"
replace tinwta = "0.01"  if tinwta == "$0.01"
replace tinwta = "0.25" if tinwta == "$0.25"
replace tinwta = "0.50"  if tinwta == "$0.50"
replace tinwta = "0.75" if tinwta == "$0.75"
replace tinwta= "1"   if tinwta == "$1"
replace tinwta = "1.50" if tinwta == "$1.50"
replace tinwta = "2"  if tinwta == "$2"
replace tinwta = "2.50" if tinwta == "$2.50"
replace tinwta = "3"    if tinwta == "$3"
replace tinwta = "5"    if tinwta == "$5"

destring(tinwta), replace

rename tinwta toNoInfoWTA

order toNoInfoWTA, after(toInfoWTA)

*** PRIORS: CALORIE CONTENT ****************************************************

* DID NOT RECEIVE INFORMATION --------------------------------------------------

gen guessNoInfoGnocchi =          guessn1 if item1meal == "1"
  replace guessNoInfoGnocchi =    guessn2 if item2meal == "1"
  replace guessNoInfoGnocchi =    guessn3 if item3meal == "1"
  replace guessNoInfoGnocchi =    guessn4 if item4meal == "1"

  destring(guessNoInfoGnocchi), replace

gen guessNoInfoFajitas =          guessn1 if item1meal == "2"
  replace guessNoInfoFajitas =    guessn2 if item2meal == "2"
  replace guessNoInfoFajitas =    guessn3 if item3meal == "2"
  replace guessNoInfoFajitas =    guessn4 if item4meal == "2"

  destring(guessNoInfoFajitas), replace

gen guessNoInfoNicoise =          guessn1 if item1meal == "3"
  replace guessNoInfoNicoise =    guessn2 if item2meal == "3"
  replace guessNoInfoNicoise =    guessn3 if item3meal == "3"
  replace guessNoInfoNicoise =    guessn4 if item4meal == "3"

  destring(guessNoInfoNicoise), replace

gen guessNoInfoMiddleE =          guessn1 if item1meal == "4"
  replace guessNoInfoMiddleE =    guessn2 if item2meal == "4"
  replace guessNoInfoMiddleE =    guessn3 if item3meal == "4"
  replace guessNoInfoMiddleE =    guessn4 if item4meal == "4"

  destring(guessNoInfoMiddleE), replace

drop guessn*

* RECEIVED INFORMATION ---------------------------------------------------------

gen guessInfoGnocchi =          guessi1 if item1meal == "1"
  replace guessInfoGnocchi =    guessi2 if item2meal == "1"
  replace guessInfoGnocchi =    guessi3 if item3meal == "1"
  replace guessInfoGnocchi =    guessi4 if item4meal == "1"

  destring(guessInfoGnocchi), replace

gen guessInfoFajitas =          guessi1 if item1meal == "2"
  replace guessInfoFajitas =    guessi2 if item2meal == "2"
  replace guessInfoFajitas =    guessi3 if item3meal == "2"
  replace guessInfoFajitas =    guessi4 if item4meal == "2"

  destring(guessInfoFajitas), replace

gen guessInfoNicoise =          guessi1 if item1meal == "3"
  replace guessInfoNicoise =    guessi2 if item2meal == "3"
  replace guessInfoNicoise =    guessi3 if item3meal == "3"
  replace guessInfoNicoise =    guessi4 if item4meal == "3"

  destring(guessInfoNicoise), replace

gen guessInfoMiddleE =          guessi1 if item1meal == "4"
  replace guessInfoMiddleE =    guessi2 if item2meal == "4"
  replace guessInfoMiddleE =    guessi3 if item3meal == "4"
  replace guessInfoMiddleE =    guessi4 if item4meal == "4"

  destring(guessInfoMiddleE), replace

drop guessi*

* COMBINE BOTH OF THEM INTO ONE VARIABLE PER MEAL ------------------------------

egen priorsGnocchi = rowtotal(guess*Gnocchi)

egen priorsFajitas = rowtotal(guess*Fajitas)

egen priorsNicoise = rowtotal(guess*Nicoise)

egen priorsMiddleE = rowtotal(guess*MiddleE)


order priors*, after(mealWTA)

drop guess*Gnocchi guess*Fajitas guess*Nicoise guess*MiddleE



*** MONEY RECEIVED *************************************************************

egen _moneyReceived = sieve(moneyget), char(0123456789.)

  destring(_moneyReceived), replace force

replace _moneyReceived = 0 if missing(_moneyReceived)

  order _moneyReceived, after(_menuOrder)

drop moneyget


*** BACKGROUND *****************************************************************

* HUNGRY LEVEL

gen hungryLevel  = .

  replace hungryLevel = 1 if introhungry == "Not hungry at all"
  replace hungryLevel = 2 if introhungry == "Somewhat hungry"
  replace hungryLevel = 3 if introhungry == "Hungry"
  replace hungryLevel = 4 if introhungry == "Very hungry"

  order hungryLevel, before(introhungry)

  drop introhungry

*** TIMERS *********************************************************************

* TIMING - UW CATERING FRAMING -------------------------------------------------

rename uwcattiming_firstclick _uwcattiming_firstclick

  destring(_uwcattiming_firstclick), replace

  order _uwcattiming_firstclick, before(_startDate)

rename uwcattiming_lastclick _uwcattiming_lastclick

  destring(_uwcattiming_lastclick), replace

  order _uwcattiming_lastclick, after(_uwcattiming_firstclick)

rename uwcattiming_pagesubmit _uwcattiming_pagesubmit

  destring(_uwcattiming_pagesubmit), replace

  order _uwcattiming_pagesubmit, after(_uwcattiming_lastclick)

rename uwcattiming_clickcount _uwcattiming_clickcount

  destring(_uwcattiming_clickcount), replace

  order _uwcattiming_clickcount, after(_uwcattiming_pagesubmit)

* TIMING - CONTROL SWITCH ------------------------------------------------------

rename ctiming_firstclick _ctiming_firstclick

  destring(_ctiming_firstclick), replace

  order _ctiming_firstclick, after(_uwcattiming_clickcount)

rename ctiming_lastclick _ctiming_lastclick

  destring(_ctiming_lastclick), replace

  order _ctiming_lastclick, after(_ctiming_firstclick)

rename ctiming_pagesubmit _ctiming_pagesubmit

  destring(_ctiming_pagesubmit), replace

  order _ctiming_pagesubmit, after(_ctiming_lastclick)

rename ctiming_clickcount _ctiming_clickcount

  destring(_ctiming_clickcount), replace

  order _ctiming_clickcount, after(_ctiming_pagesubmit)

* TIMING: SWITCH NO INFO -> INFO -----------------------------------------------

rename tnitiming_firstclick _tnitiming_firstclick

  destring(_tnitiming_firstclick), replace

  order _tnitiming_firstclick, after(_ctiming_clickcount)

rename tnitiming_lastclick _tnitiming_lastclick

  destring(_tnitiming_lastclick), replace

  order _tnitiming_lastclick, after(_tnitiming_firstclick)

rename tnitiming_pagesubmit _tnitiming_pagesubmit

  destring(_tnitiming_pagesubmit), replace

  order _tnitiming_pagesubmit, after(_tnitiming_lastclick)

rename tnitiming_clickcount _tnitiming_clickcount

  destring(_tnitiming_clickcount), replace

  order _tnitiming_clickcount, after(_tnitiming_pagesubmit)

* TIMING: SWITCH INFO -> NO INFO -----------------------------------------------

rename tintiming_firstclick _tintiming_firstclick

  destring(_tintiming_firstclick ), replace

  order _tintiming_firstclick, after(_tnitiming_clickcount)

rename tintiming_lastclick _tintiming_lastclick

  destring(_tintiming_lastclick), replace

  order _tintiming_lastclick, after(_tintiming_firstclick)

rename tintiming_pagesubmit _tintiming_pagesubmit

  destring(_tintiming_pagesubmit), replace

  order _tintiming_pagesubmit, after(_tintiming_lastclick)

rename tintiming_clickcount  _tintiming_clickcount

  destring(_tintiming_clickcount), replace

  order _tintiming_clickcount, after(_tintiming_pagesubmit )

* TIMING: NUDGE - LONG_TERM

rename tftiming_firstclick _tftiming_firstclick

  destring(_tftiming_firstclick), replace

  order _tftiming_firstclick, after(_tintiming_clickcount)

rename tftiming_lastclick _tftiming_lastclick

  destring(_tftiming_lastclick), replace

  order _tftiming_lastclick, after(_tftiming_firstclick)

rename tftiming_pagesubmit _tftiming_pagesubmit

  destring(_tftiming_pagesubmit), replace

  order _tftiming_pagesubmit, after(_tftiming_lastclick)

rename tftiming_clickcount _tftiming_clickcount

  destring(_tftiming_clickcount), replace

  order _tftiming_clickcount, after(_tftiming_pagesubmit)

* TIMING: NUDGE - RESIST TEMPTATION --------------------------------------------

rename tstiming_firstclick _tstiming_firstclick

  destring(_tstiming_firstclick), replace

  order _tstiming_firstclick, after(_tftiming_clickcount)

rename tstiming_lastclick _tstiming_lastclick

  destring(_tstiming_lastclick), replace

  order _tstiming_lastclick, after(_tstiming_firstclick)

rename tstiming_pagesubmit _tstiming_pagesubmit

  destring(_tstiming_pagesubmit), replace

  order _tstiming_pagesubmit, after(_tstiming_lastclick)

rename tstiming_clickcount _tstiming_clickcount

  destring(_tstiming_clickcount), replace

  order _tstiming_clickcount, after(_tstiming_pagesubmit)

*** DROP VARIABLES *************************************************************

drop uwcattext choicen tfnudge tsnudge choicei debug meal1 meal2 meal3 meal4    ///
     calories1 calories2 calories3 calories4 descr1 descr2 descr3 descr4        ///
     cshowmenu csetmealalt ccheckswpat cmungerow tnimungerow tnimungeswpat      ///
     tshowmenun tshowmenui parsemenu tinmungerow tinmungeswpat                  ///
     item*name item*descr item*calories item*meal                               ///
     cvalid itemchoice mealchoice csw*str crow cresultstr cresultnum cresultmon ///
     tnisw*str tnirow*to* tinsw*str tinrow*to*                                  ///
     tnirow tniresultstr tniresultnum tniresultmon menuget   tnivalid           ///
     tinrow tinresultstr tinresultnum tinresultmon  tinvalid

*** SAVE ***********************************************************************

order id, first

rename id key

save "$RUTA/temp/data/clean_choices.dta", replace

*** END OF FILE ****************************************************************
********************************************************************************
