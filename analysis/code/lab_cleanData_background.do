/*******************************************************************************
Author:       TabareCapitan.com

Description:  Clean data on participants' background

Created: 20180429 | Last modified: 20220718
*******************************************************************************/


*** LOAD DATA ******************************************************************

use "$RUTA/temp/data/raw_background.dta", clear

count


*** VALID OBSERVATIONS *********************************************************

gen valid = (progress == "100") & (finished == "True")

drop progress finished

drop if !valid

drop valid


*** TIME FORMAT ****************************************************************

gen double _startDateB = clock(startdate, "YMD hms")

format _startDateB %tc

drop startdate


gen double _endDateB = clock(enddate, "YMD hms")

format _endDateB %tc

drop enddate


gen double _recordedDateB = clock(recordeddate, "YMD hms")

format _recordedDateB %tc

drop recordeddate


*** VALIDATE UNIQUE ID *********************************************************

destring(q114), replace    // id1

destring(q115), replace    // id2

destring(q166), replace    // id3


corr q114 q115 q166   // 1 inconsistency


replace q115 = 740 if q114 == 740 & q166 == 740  // fix typo

corr q114 q115 q166

rename q114 id

drop q115 q166


*** METADATA *******************************************************************

drop status ipaddress


destring(durationinseconds), replace

  rename durationinseconds _totalDurationB

  order _totalDurationB, after(_recordedDateB)


drop   responseid recipientlastname recipientfirstname recipientemail      ///
    externalreference


rename locationlatitude _latitudeB

  order _latitudeB, after(_totalDurationB)

rename locationlongitude _longitudeB

  order _longitudeB, after(_latitudeB)


drop distributionchannel userlanguage

*** BY SECTION *****************************************************************

* DEMOGRAPHICS -----------------------------------------------------------------

gen gender = .

  replace gender = 0 if q117 == "Female"
  replace gender = 1 if q117 == "Male"
  replace gender = 2 if q117 == "Other"

  order gender, after(id)

  drop q117

gen female = .
  replace female = 0 if gender == 1
  replace female = 1 if gender == 0

  order female, after(gender)

rename q121 age    // q121 in Qualtrics is age and what's your major

  destring(age), replace


gen education = .

  replace education = 1 if q119 == "Less than high school"
  replace education = 2 if q119 == "High school"
  replace education = 3 if q119 == "Professional degree"
  replace education = 4 if q119 == "Some college"
  replace education = 5 if q119 == "College degree"

  order education, after(age)

  drop q119

drop q123 q125 // Qualtrics mistake

* RISK PREFERENCES -------------------------------------------------------------

drop v24

replace v25 = substr(v25,8,1)

destring(v25), replace

rename v25 riskPreferences

* FOOD SELF-CONTROL ------------------------------------------------------------

forvalues i = 1(1)10{

  gen foodSelfControl_`i' = .
    replace foodSelfControl_`i' = 1 if q125_`i' == "Very much disagree"
    replace foodSelfControl_`i' = 2 if q125_`i' == "Disagree"
    replace foodSelfControl_`i' = 3 if q125_`i' == "Neither agree nor disagree"
    replace foodSelfControl_`i' = 4 if q125_`i' == "Agree"
    replace foodSelfControl_`i' = 5 if q125_`i' == "Very much agree"
}

order foodSelfControl*, after(riskPreferences)

drop q125_*

* Invert ranking when needed

replace foodSelfControl_2 = (-1) * foodSelfControl_2 + 6

replace foodSelfControl_3 = (-1) * foodSelfControl_3 + 6

replace foodSelfControl_4 = (-1) * foodSelfControl_4 + 6

replace foodSelfControl_8 = (-1) * foodSelfControl_8 + 6

replace foodSelfControl_9 = (-1) * foodSelfControl_9 + 6

replace foodSelfControl_10 = (-1) * foodSelfControl_10 + 6    // Not sure about this flip

* Create summary variable

egen foodSelfControl = rowtotal(foodSelfControl_*)

  order foodSelfControl, after(foodSelfControl_10)


* PREFERENCES FOR CALORIE INFORMATION ------------------------------------------

gen infoPreferences_1 = (q127_1 == "When I go to a coffee shop")

  order infoPreferences_1, after(foodSelfControl)

gen infoPreferences_2 = (q127_2 == "When I go to a fast food restaurant")

  order infoPreferences_2, after(infoPreferences_1)

gen infoPreferences_3 = (q127_3 == "When I go to a diner")

  order infoPreferences_3, after(infoPreferences_2)

gen infoPreferences_4 = (q127_4 == "When I go to a fancy restaurant")

  order infoPreferences_4, after(infoPreferences_3)

gen infoPreferences_5 = (q127_5 == "When I buy a meal at a gas station")

  order infoPreferences_5, after(infoPreferences_4)

gen infoPreferences_6 = (q127_6 == "When I eat a meal cooked at home")

  order infoPreferences_6, after(infoPreferences_5)

gen infoPreferences_7 = (q127_7 == "I never want to know about calories")

  order infoPreferences_7, after(infoPreferences_6)

drop q127_*


replace q129 = substr(q129,1,1)

gen perceptionInfoPreferences = ( q129 == "Y" )

  order perceptionInfoPreferences, after(infoPreferences_7)

  drop q129


gen whenWantInfo = .
  replace whenWantInfo = 1 if q160 == "Never"
  replace whenWantInfo = 2 if q160 == "Only when I'm on a diet"
  replace whenWantInfo = 3 if q160 == "It depends"
  replace whenWantInfo = 4 if q160 == "Always"

  order whenWantInfo, after(perceptionInfoPreferences)

  drop q160


gen whereWantInfo_1 = q131_1 == "When I go out to eat to celebrate something special (such as an anniversary, a birthday, or a promotion)"

  order whereWantInfo_1, after(perceptionInfoPreferences)

gen whereWantInfo_2 = q131_2 == "When I go to a restaurant where I eat frequently"

  order whereWantInfo_2, after(whereWantInfo_1)

gen whereWantInfo_3 = q131_3 == "When I go to a restaurant where I otherwise never eat"

  order whereWantInfo_3, after(whereWantInfo_2)

gen whereWantInfo_4 = q131_4 == "When I go to a restaurant to treat myself with something I really like"

  order whereWantInfo_4, after(whereWantInfo_3)

gen whereWantInfo_5 = q131_5 == "When someone else takes me out to a restaurant"

  order whereWantInfo_5, after(whereWantInfo_4)


drop q131_*


drop q132_*  // no observations


gen reasonAvoidInfo_1 = q134_1 == "They don't want to think of calories when they eat out."

  order reasonAvoidInfo_1, after(whereWantInfo_4)

gen reasonAvoidInfo_2 = q134_2 == "Calorie information would not matter to their meal choices anyway."

  order reasonAvoidInfo_2, after(reasonAvoidInfo_1)

gen reasonAvoidInfo_3 = q134_11 == "They would feel guilty if they knew how many calories their meal was."

  order reasonAvoidInfo_3, after(reasonAvoidInfo_2)

gen reasonAvoidInfo_4 = q134_4 == "They know the calorie content anyway."

  order reasonAvoidInfo_4, after(reasonAvoidInfo_3)

gen reasonAvoidInfo_5 = q134_5 == "They do not know how to interpret calorie information."

  order reasonAvoidInfo_5, after(reasonAvoidInfo_4)

gen reasonAvoidInfo_6 = q134_6 == "I do not know."

  order reasonAvoidInfo_6, after(reasonAvoidInfo_5)

gen reasonAvoidInfo_7 = q134_7 == "Other (please specify)."

  order reasonAvoidInfo_7, after(reasonAvoidInfo_6)

  rename q134_7_text reasonAvoidInfo_7_detail

drop q134_*

* KNOWLEDGE ABOUT CALORIES -----------------------------------------------------

gen freqInfo = .
    replace freqInfo = 1 if q144 ==                                             ///
      "I do not recall ever seeing calories displayed on the menu or menu boards"
    replace freqInfo = 2 if q144 ==                                             ///
      "I recall rarely seeing calories displayed on the menu or menu boards"
    replace freqInfo = 3 if q144 ==                                             ///
      "I recall sometimes seeing calories displayed on the menu or menu boards"
    replace freqInfo = 4 if q144 ==                                             ///
      "I recall often seeing calories displayed on the menu or menu boards"
    replace freqInfo = 5 if q144 ==                                             ///
      "I recall always seeing calories displayed on the menu or menu boards"

    order freqInfo, after(reasonAvoidInfo_7_detail)

    drop q144

// The answer to this question is "Around X calories per day", the code below
// transforms the answers to X.

replace q142 = substr(q142,8,.)

replace q142 = subinstr(q142,"calories","",.)

replace q142 = subinstr(q142,",","",.)

replace q142 = strrtrim(q142)

destring(q142), replace

rename q142 calorieNeedsAnswer

gen knowsCalorieNeeds = calorieNeedsAnswer == 2500


* PERSONAL HEALTH STATUS -------------------------------------------------------

gen weightAssesment = .

  replace weightAssesment = 1  if q148 == "I am underweight"
  replace weightAssesment = 2  if q148 == "I am normal weight"
  replace weightAssesment = 3  if q148 == "I am overweight"
  replace weightAssesment = 4  if q148 == "I am obese"
  replace weightAssesment = .a if q148 == "I do not know"

  order weightAssesment, after(calorieNeedsAnswer)

  drop q148

gen underWeight = (weightAssesment == 1) if !missing(weightAssesment)

gen normal = (weightAssesment == 2) if !missing(weightAssesment)

gen overWeight = (weightAssesment == 3) if !missing(weightAssesment)

gen obese = (weightAssesment == 4) if !missing(weightAssesment)


* HEIGHT -----------------------------------------------------------------------

* RE-FORMAT HEIGHT VARIABLE because Answer was open-ended

gen temp = q150

gen feet = substr(temp, 1, 1)              // get first character

replace  temp = substr(temp,2,.)          // delete first character

egen inches = sieve(temp), keep(numeric)  // keep numeric characters

    // sieve is a utilty for program egenmore

* HANDLE SPECIAL CASES

replace inches = "9.75" if q150 == "5' 9.75"

replace inches = "9.5" if q150 == "5 feet 9 1/2 inches"

replace inches = "11.5" if q150 == "5' 11.5"

replace inches = "0.5" if q150 == "6'1/2"

replace feet   = "6" if q150 == "six feet three inches"

replace inches = "3" if q150 == "six feet three inches"

replace inches = "4.5" if q150 == "5 feet 4.5 inches"

replace inches = "11.75" if q150 == "5'11.75"

replace feet   = "" if q150 == "62.9921"                  // Fix? It's unclear

replace inches = "" if q150 == "62.9921"                  // Fix? It's unclear

replace inches = "10" if q150 == "50' 10"

replace inches = "11.5" if q150 == "5 feet 11.5 inches"

replace inches = "2.75" if q150 == "6 foot 2.75 inches"

replace inches = "8.5" if q150 == "5 feet 8.5 inches"

replace inches = "5.5" if q150 == "5 feet 5.5 inches"

replace feet   = "" if q150 == "78.5"

replace inches = "" if q150 == "78.5"

replace inches = "9.5" if q150 == "5,9.5"

replace inches = "6.5" if q150 == "5' 6.5"

replace feet   = "" if q150 == "73"

replace inches = "" if q150 == "73"

replace inches = "1.5" if q150 == "6 feet 1.5 inches"

replace inches = "8.5" if q150 == "5'8.5"

replace feet   = "" if q150 == "71"

replace inches = "" if q150 == "71"

replace inches = "4" if q150 == "5.4 and 65"

replace inches = "6" if q150 == "5 feet 6 or 7 inches"

replace feet   = "" if q150 == "75"

replace inches = "" if q150 == "75"


replace inches = "0" if missing(inches)


destring(feet), replace

destring(inches), replace


gen selfReportedHeight = feet * 30.48 + inches * 2.54  // in meters

    replace selfReportedHeight = 165 if q150 == "165"

    replace selfReportedHeight  = 162 if q150 == "162"


order selfReportedHeight, after(weightAssesment)

drop q150 temp feet inches


* SELF-REPORTED WEIGHT ---------------------------------------------------------

destring(v65), gen(selfReportedWeight)

  order selfReportedWeight, after(v65)

  drop v65


destring(q138_1), replace

rename q138_1 confidenceWeightEstimate


gen lastWeightMeasure = .
  replace lastWeightMeasure = 1 if q136 == "More than a year ago"
  replace lastWeightMeasure = 2 if q136 == "A year ago"
  replace lastWeightMeasure = 3 if q136 == "A few months ago"
  replace lastWeightMeasure = 4 if q136 == "A month ago"
  replace lastWeightMeasure = 5 if q136 == "A few weeks ago"
  replace lastWeightMeasure = 6 if q136 == "A week ago"
  replace lastWeightMeasure = 7 if q136 == "A few days ago"
  replace lastWeightMeasure = 8 if q136 == "Yesterday"
  replace lastWeightMeasure = 9 if q136 == "Today"

  order lastWeightMeasure, after(confidenceWeightEstimate)

  drop q136


gen freqWeigh = .
  replace freqWeigh = 1 if q146 == "Almost never"
  replace freqWeigh = 2 if q146 == "Once a month"
  replace freqWeigh = 3 if q146 == "Once a week"
  replace freqWeigh = 4 if q146 == "Several times a week"
  replace freqWeigh = 5 if q146 == "Every day"

  order freqWeigh, after(lastWeightMeasure)

  drop q146


encode(q140), gen(weightChanged)

  replace weightChanged = weightChanged - 1

  label drop weightChanged

  order weightChanged, after(freqWeigh)

  drop q140


gen weightChangedDetail = .
  replace weightChangedDetail =  5 if q151 == "I gained more than 20 pounds"
  replace weightChangedDetail =  4 if q151 == "I gained around 20 pounds"
  replace weightChangedDetail =  3 if q151 == "I gained around 10 pounds"
  replace weightChangedDetail =  2 if q151 == "I gained around 5 pounds"
  replace weightChangedDetail =  1 if q151 == "I gained a couple of pounds"

  replace weightChangedDetail =  0 if weightChanged == 0

  replace weightChangedDetail = -1 if q151 == "I lost a couple of pounds"
  replace weightChangedDetail = -2 if q151 == "I lost around 5 pounds"
  replace weightChangedDetail = -3 if q151 == "I lost around 10 pounds"
  replace weightChangedDetail = -4 if q151 == "I lost around 20 pounds"
  replace weightChangedDetail = -5 if q151 == "I lost more than 20 pounds"

  order weightChangedDetail, after(weightChanged)

  drop q151

* HEALTH SELF-ASSESMENT --------------------------------------------------------

forvalues i = 1(1)4{

  gen healthAssesment_`i' = .
    replace healthAssesment_`i' = 1 if q163_`i' == "Very much disagree"
    replace healthAssesment_`i' = 2 if q163_`i' == "Disagree"
    replace healthAssesment_`i' = 3 if q163_`i' == "Neither agree nor disagree"
    replace healthAssesment_`i' = 4 if q163_`i' == "Agree"
    replace healthAssesment_`i' = 5 if q163_`i' == "Very much agree"

    order healthAssesment_`i', before(q159_1)

  }

drop q163_*

* WEIGHT GOALS -----------------------------------------------------------------

forvalues i = 1(1)3{

  gen weightGoals_`i' = .
    replace weightGoals_`i' = 1 if q159_`i' == "Not at all important"
    replace weightGoals_`i' = 2 if q159_`i' == "Slightly important"
    replace weightGoals_`i' = 3 if q159_`i' == "Moderately important"
    replace weightGoals_`i' = 4 if q159_`i' == "Very important"
    replace weightGoals_`i' = 5 if q159_`i' == "Extremely important"

    order weightGoals_`i', before(q161)
}

drop q159_*


encode(q161), gen(wantToLoseWeight)

replace wantToLoseWeight = wantToLoseWeight - 1

label drop wantToLoseWeight

order wantToLoseWeight, after(weightGoals_3)

drop q161


encode(q157), gen(tryingLoseWeight)

replace tryingLoseWeight = tryingLoseWeight - 1

label drop tryingLoseWeight

order tryingLoseWeight, after(wantToLoseWeight)

drop q157


encode(q155), gen(tryingGainWeight)

replace tryingGainWeight = tryingGainWeight - 1

label drop tryingGainWeight

order tryingGainWeight, after(tryingLoseWeight)

drop q155


encode(q153), gen(dieting)

replace dieting = dieting - 1

label drop dieting

order dieting, after(tryingGainWeight)

drop q153

* FREQUENCY EAT CHAIN RESTAURANTS ----------------------------------------------

gen freqChainRest = .
  replace freqChainRest = 1 if q165 == "Less than once a month"
  replace freqChainRest = 2 if q165 == "Once a month"
  replace freqChainRest = 3 if q165 == "2-3 times a month"
  replace freqChainRest = 4 if q165 == "Once a week"
  replace freqChainRest = 5 if q165 == "2-3 times a week"
  replace freqChainRest = 6 if q165 == "More than 3 times a week"

  order freqChainRest, after(dieting)

  drop q165

* INCOME AND EXPENSES ----------------------------------------------------------

gen expenses = .
  replace expenses = 1  if v83 == "$400 or less"
  replace expenses = 2  if v83 == "$401 - $600"
  replace expenses = 3  if v83 == "$601 - $800"
  replace expenses = 4  if v83 == "$801 - $1,000"
  replace expenses = 5  if v83 == "$1,001 - $1,200 "
  replace expenses = 6  if v83 == "$1,201 - $1,400"
  replace expenses = 7  if v83 == "$1,401 - $1,600"
  replace expenses = 8  if v83 == "$1601 - $1,800"
  replace expenses = 9  if v83 == "$1,801 - $2,000"
  replace expenses = 10 if v83 == "$2,000 or more"
  replace expenses = .a if v83 == "I'd rather not say"

  order expenses, after(freqChainRest)

  drop v83


gen income = .

    replace income = 1  if q139 == "$10,000 or less"
    replace income = 2  if q139 == "$10,001 - $12,500"
    replace income = 3  if q139 == "$12,501 - $15,000"
    replace income = 4  if q139 == "$15,001 - $17,500"
    replace income = 5  if q139 == "$17,501 - $20,000"
    replace income = 6  if q139 == "$20,001 - $25,000"
    replace income = 7  if q139 == "$25,001 - $30,000"
    replace income = 8  if q139 == "$30,001- $50,000"
    replace income = 9  if q139 == "$50,000 or more"
    replace income = .a if q139 == "I'd rather not say"

    order income, after(expenses)

    drop q139


* EXTRAS (LINDA) T1 ------------------------------------------------------------

drop  q66_*         // NOT RELEVANT TO THIS PROJECT

* EXTRAS (LINDA) T2 ------------------------------------------------------------

drop q68_*          // NOT RELEVANT TO THIS PROJECT

* EXTRAS (LINDA) T3 ------------------------------------------------------------

drop q70_*          // NOT RELEVANT TO THIS PROJECT

* EXTRAS (LINDA) GENERAL -------------------------------------------------------

drop q58 q60 q64 q72 q74 q76 q78 q80_* q109_*

* PREVIOUS KNOWLEDGE OF THE SURVEY ---------------------------------------------

replace q54 = substr(q54,9,1)

gen _priorKnowledgeB = .
  replace _priorKnowledgeB = 0 if q54 == "n"  // heard Nothing
  replace _priorKnowledgeB = 1 if q54 == "s"  // heard Some
  replace _priorKnowledgeB = 2 if q54 == "a"  // heard A lot

  order _priorKnowledgeB, after(_longitudeB)

  drop q54


replace q111 = substr(q111,9,1)

gen _priorKnowledgeMealsB = .
  replace _priorKnowledgeMealsB = 0 if q111 == "n"  // heard Nothing
  replace _priorKnowledgeMealsB = 1 if q111 == "s"  // heard Some
  replace _priorKnowledgeMealsB = 2 if q111 == "a"  // heard A lot

  order _priorKnowledgeMealsB, after(_priorKnowledgeB)

  drop q111


rename q55 priorKnowledgeMealsDetail

*** SAVE ***********************************************************************

drop q27

order id, first

rename id key

save "$RUTA/temp/data/clean_background.dta", replace

*** END OF FILE ****************************************************************
********************************************************************************
