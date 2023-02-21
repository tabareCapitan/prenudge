/*******************************************************************************
Author:       TabareCapitan.com

Description:  Clean data from the online experiment

Created: 20180717 | Last modified: 20220718
*******************************************************************************/

*** LOAD DATA ******************************************************************

use "$RUTA/temp/data/raw_mturk.dta", clear


*** VALID OBSERVATIONS *********************************************************

gen valid = (progress == "100")                                             &    ///
            (finished == "True")                                            &    ///
            (introveg == "No, I am not a vegetarian/vegan")                 &    ///
            (introallergy == "No, I do not have any food allergies")

drop progress finished introveg introallergy

drop if !valid

drop valid


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


*** METADATA *******************************************************************

order treatment, first

*

drop status ipaddress

*

destring(durationinseconds), replace

  rename durationinseconds _totalDuration

  order _totalDuration, after(_recordedDate)

*

drop   responseid recipientlastname recipientfirstname recipientemail      ///
    externalreference


rename locationlatitude _latitude

  order _latitude, after(_totalDuration)

rename locationlongitude _longitude

  order _longitude, after(_latitude)

*

drop distributionchannel userlanguage

* MENU ORDER

rename menu _menuOrder

  order _menuOrder, before(_startDate)


*** SLIDERS: MEAL PREFERENCE ***************************************************

/* Note that meal X in slider Y varies by person due to randomization.

  I.   Get value of slider per meal for those who didnt receive information.
  II.  Get value of slider per meal for those who did   receive information.
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

gen sliderInfoNicoise =          slideri_1 if item1meal == "3"
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


order slider*, after(treatment)


drop sliderInfo* sliderNoInfo*


*** SELECTED MEAL **************************************************************

* This code is a bit different than the lab counterpart because there is no
* receivedMeal (mealget) in the online experiment. Also, the meals are:

  /* 1: Chicken/Salami Gnocchi
     2: Red Rice/Fajita Chicken
     3: Chicken Nicoise
     4: Middle Eastern Pasta with Chicken */


// *** DID NOT RECEIVE INFO ***

gen temp = substr(choicen,17,1)    // extract meal number

gen choiceNoInfo =         item1meal if temp == "1"
  replace choiceNoInfo =   item2meal if temp == "2"
  replace choiceNoInfo =   item3meal if temp == "3"
  replace choiceNoInfo =   item4meal if temp == "4"

  destring(choiceNoInfo), replace

  drop temp choicen


*** RECEIVED INFO ***

gen temp = substr(choicei,17,1)

gen choiceInfo =         item1meal if temp == "1"
  replace choiceInfo =   item2meal if temp == "2"
  replace choiceInfo =   item3meal if temp == "3"
  replace choiceInfo =   item4meal if temp == "4"

  destring(choiceInfo), replace

  drop temp choicei


*** COMBINE BOTH OF THEM ***

egen chosenMeal = rowtotal(choiceNoInfo choiceInfo)

order chosenMeal, after(sliderMiddleE)

drop choiceNoInfo choiceInfo


*** WTA TO SWITCH MEAL *********************************************************

rename cswpat shiftMealPattern

  order shiftMealPattern, after(chosenMeal)


forvalues i = 1(1)10{        // I don't use these variables

  destring(csw`i'), replace

  rename csw`i' switchMeal_`i'

  order switchMeal_`i', before(introhungry)

  drop cswitch_cswitch_`i'

}


replace cwta = "666"    if cwta == "666"
replace cwta = "0.01"   if cwta == "$0.01"
replace cwta = "0.25"   if cwta == "$0.25"
replace cwta = "0.50"   if cwta == "$0.50"
replace cwta = "0.75"   if cwta == "$0.75"
replace cwta = "1"      if cwta == "$1"
replace cwta = "1.50"   if cwta == "$1.50"
replace cwta = "2"      if cwta == "$2"
replace cwta = "2.50"   if cwta == "$2.50"
replace cwta = "3"      if cwta == "$3"
replace cwta = "5"      if cwta == "$5"

destring(cwta), replace

rename cwta mealWTA

order mealWTA, after(switchMeal_10)


*** INFO CHOICE ****************************************************************

rename wantinfo infoChoice

drop tinfochoice

destring(infoChoice), replace

order infoChoice, after(treatment)


*** WTA TO SWITCH INFO CHOICE **************************************************

*** SWITCH: NO INFO -> INFO ***

rename tniswpat shiftToInfoPattern

  order shiftToInfoPattern, after(infoChoice)

forvalues i = 1(1)10{

  destring(tnisw`i'), replace

  rename tnisw`i' switchToInfo_`i'

  order switchToInfo_`i', before(sliderGnocchi)

  drop tswitch_ni_tswitch_ni_`i'
}


replace tniwta = "666"       if tniwta == "666"
replace tniwta = "0.01"      if tniwta == "$0.01"
replace tniwta = "0.25"      if tniwta == "$0.25"
replace tniwta = "0.50"      if tniwta == "$0.50"
replace tniwta = "0.75"      if tniwta == "$0.75"
replace tniwta = "1"         if tniwta == "$1"
replace tniwta = "1.50"      if tniwta == "$1.50"
replace tniwta = "2"         if tniwta == "$2"
replace tniwta = "2.50"      if tniwta == "$2.50"
replace tniwta = "3"         if tniwta == "$3"
replace tniwta = "5"         if tniwta == "$5"

destring(tniwta), replace

rename tniwta toInfoWTA

order toInfoWTA, after(switchToInfo_10)


*** SWITCH: INFO -> NO INFO ***

rename tinswpat shiftToNoInfoPattern

  order shiftToNoInfoPattern, after(shiftToInfoPattern)

forvalues i = 1(1)10{

  destring(tinsw`i'), replace

  rename tinsw`i' switchToNoInfo_`i'

  order switchToNoInfo_`i', before(toInfoWTA)

  drop tswitch_in_tswitch_in_`i'
}


replace tinwta = "666"   if tinwta == "666"
replace tinwta = "0.01"  if tinwta == "$0.01"
replace tinwta = "0.25"  if tinwta == "$0.25"
replace tinwta = "0.50"  if tinwta == "$0.50"
replace tinwta = "0.75"  if tinwta == "$0.75"
replace tinwta= "1"      if tinwta == "$1"
replace tinwta = "1.50"  if tinwta == "$1.50"
replace tinwta = "2"     if tinwta == "$2"
replace tinwta = "2.50"  if tinwta == "$2.50"
replace tinwta = "3"     if tinwta == "$3"
replace tinwta = "5"     if tinwta == "$5"

destring(tinwta), replace

rename tinwta toNoInfoWTA

order toNoInfoWTA, after(toInfoWTA)


*** PRIORS: CALORIE CONTENT ****************************************************

*** DID NOT RECEIVE INFORMATION ***

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


*** RECEIVED INFORMATION ***

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


*** COMBINE BOTH OF THEM INTO ONE VARIABLE PER MEAL ***

egen priorsGnocchi = rowtotal(guess*Gnocchi)

egen priorsFajitas = rowtotal(guess*Fajitas)

egen priorsNicoise = rowtotal(guess*Nicoise)

egen priorsMiddleE = rowtotal(guess*MiddleE)


order priors*, after(mealWTA)

drop guess*Gnocchi guess*Fajitas guess*Nicoise guess*MiddleE


*** BACKGROUND *****************************************************************

* HUNGRY LEVEL -----------------------------------------------------------------

gen hungryLevel  = .

  replace hungryLevel = 1 if introhungry == "Not hungry at all"
  replace hungryLevel = 2 if introhungry == "Somewhat hungry"
  replace hungryLevel = 3 if introhungry == "Hungry"
  replace hungryLevel = 4 if introhungry == "Very hungry"

  order hungryLevel, before(introhungry)

  drop introhungry


* RISK PREFERENCES -------------------------------------------------------------

gen riskPreferences = substr(riskpref,8,1)

order riskPreferences, after(hungryLevel)

destring(riskPreferences), replace

drop riskpref


* FOOD SELF-CONTROL ------------------------------------------------------------

forvalues i = 1(1)10{

  gen foodSC_`i' = .

}

forvalues i = 10(-1)1{

  replace foodSC_`i' = 1 if foodsc_`i' == "Very much disagree"
  replace foodSC_`i' = 2 if foodsc_`i' == "Disagree"
  replace foodSC_`i' = 3 if foodsc_`i' == "Neither agree nor disagree"
  replace foodSC_`i' = 4 if foodsc_`i' == "Agree"
  replace foodSC_`i' = 5 if foodsc_`i' == "Very much agree"

  order foodSC_`i', after(riskPreferences)

  drop foodsc_`i'
}

* Invert ranking when needed

replace foodSC_2 = (-1) * foodSC_2 + 6

replace foodSC_3 = (-1) * foodSC_3 + 6

replace foodSC_4 = (-1) * foodSC_4 + 6

replace foodSC_8 = (-1) * foodSC_8 + 6

replace foodSC_9 = (-1) * foodSC_9 + 6

replace foodSC_10 = (-1) * foodSC_10 + 6    // Not sure about this flip

* Create summary variable

egen foodSelfControl = rowtotal(foodSC_*)

  order foodSelfControl, after(foodSC_10)


* GENDER -----------------------------------------------------------------------

encode(gender), gen(temp)

drop gender

rename temp gender

order gender, after(foodSelfControl)


* AGE --------------------------------------------------------------------------

destring(age), replace

order age, after(gender)


* EDUCATION --------------------------------------------------------------------

gen education = .

  replace education = 1 if educ == "Less than high school"
  replace education = 2 if educ == "High school"
  replace education = 3 if educ == "Professional degree"
  replace education = 4 if educ == "Some college"
  replace education = 5 if educ == "College degree"

  order education, after(age)

  drop educ


* INCOME -----------------------------------------------------------------------

rename income tempIncome

gen income = .

    replace income = 1  if tempIncome == "$10,000 or less"
    replace income = 2  if tempIncome == "$10,001 - $12,500"
    replace income = 3  if tempIncome == "$12,501 - $15,000"
    replace income = 4  if tempIncome == "$15,001 - $17,500"
    replace income = 5  if tempIncome == "$17,501 - $20,000"
    replace income = 6  if tempIncome == "$20,001 - $25,000"
    replace income = 7  if tempIncome == "$25,001 - $30,000"
    replace income = 8  if tempIncome == "$30,001- $50,000"
    replace income = 9  if tempIncome == "$50,001-$70,000"
    replace income = 10 if tempIncome == "$70,001-$90,000"
    replace income = 11 if tempIncome == "$90,001 or more"
    replace income = .a if tempIncome == "I'd rather not say"

    order income, after(education)

    drop tempIncome


*** TIMERS *********************************************************************

* TIMING - RESTAURANT-STYLE FRAMING

rename restauranttiming_firstclick _restauranttiming_firstclick

  destring(_restauranttiming_firstclick), replace

  order _restauranttiming_firstclick, before(_startDate)

rename restauranttiming_lastclick _restauranttiming_lastclick

  destring(_restauranttiming_lastclick), replace

  order _restauranttiming_lastclick, after(_restauranttiming_firstclick)

rename restauranttiming_pagesubmit _restauranttiming_pagesubmit

  destring(_restauranttiming_pagesubmit), replace

  order _restauranttiming_pagesubmit, after(_restauranttiming_lastclick)

rename restauranttiming_clickcount _restauranttiming_clickcount

  destring(_restauranttiming_clickcount), replace

  order _restauranttiming_clickcount, after(_restauranttiming_pagesubmit)

drop restauranttext

* TIMING - CONTROL SWITCH

rename ctiming_firstclick _ctiming_firstclick

  destring(_ctiming_firstclick), replace

  order _ctiming_firstclick, after(_restauranttiming_clickcount)

rename ctiming_lastclick _ctiming_lastclick

  destring(_ctiming_lastclick), replace

  order _ctiming_lastclick, after(_ctiming_firstclick)

rename ctiming_pagesubmit _ctiming_pagesubmit

  destring(_ctiming_pagesubmit), replace

  order _ctiming_pagesubmit, after(_ctiming_lastclick)

rename ctiming_clickcount _ctiming_clickcount

  destring(_ctiming_clickcount), replace

  order _ctiming_clickcount, after(_ctiming_pagesubmit)


* TIMING: SWITCH NO INFO -> INFO

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


* TIMING: SWITCH INFO -> NO INFO

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


* TIMING: NUDGE - RESIST TEMPTATION

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


* TIMING: NUDGE - UNDERESTIMATE CALORIES

rename tutiming_firstclick _tutiming_firstclick

  destring(_tutiming_firstclick), replace

  order _tutiming_firstclick, after(_tstiming_clickcount)

rename tutiming_lastclick _tutiming_lastclick

  destring(_tutiming_lastclick), replace

  order _tutiming_lastclick, after(_tutiming_firstclick )

rename tutiming_pagesubmit _tutiming_pagesubmit

  destring(_tutiming_pagesubmit), replace

  order _tutiming_pagesubmit, after(_tutiming_lastclick)

rename tutiming_clickcount _tutiming_clickcount

  destring(_tutiming_clickcount), replace

  order _tutiming_clickcount, after(_tutiming_pagesubmit)


* TIMING: NUDGE - STRATEGIC IGNORANCE

rename tatiming_firstclick _tatiming_firstclick

  destring(_tatiming_firstclick), replace

  order _tatiming_firstclick, after(_tutiming_clickcount)

rename tatiming_lastclick _tatiming_lastclick

  destring(_tatiming_lastclick), replace

  order _tatiming_lastclick, after(_tatiming_firstclick )

rename tatiming_pagesubmit _tatiming_pagesubmit

  destring(_tatiming_pagesubmit), replace

  order _tatiming_pagesubmit, after(_tatiming_lastclick )

rename tatiming_clickcount _tatiming_clickcount

  destring(_tatiming_clickcount), replace

  order _tatiming_clickcount, after(_tatiming_pagesubmit)


*** DROP VARIABLES *************************************************************

drop t*nudge mturkcode debug mealchoice* calories* descr* intro meal*           ///
     randtreatment cshowmenu csetmealalt ccheckswpat tnimungeswpat tshowmenun   ///
     tshowmenui parsemenu tinmungeswpat  item*name item*descr item*calories     ///
     item*meal csw*str getinfo itemchoice cvalid tnisw*str tinsw*str            ///
     tnivalid tinvalid

cap drop mealori mealalt // In control, chosen vs alternative meal


*** SAVE ***********************************************************************

save "$RUTA/temp/data/clean_mturk.dta", replace

*** END OF FILE ****************************************************************
********************************************************************************
