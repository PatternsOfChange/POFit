/* HOSPITAL STATE SCRIPT */ 
/* DATABASE OF SECOND UPDATE PROVIDED BY HOSPITAL*/ 

/* Clear data and screen*/

clear
cls

/* Log File*/


cd "/Users/jcvalverde/Library/CloudStorage/OneDrive-UniversityCollegeLondon/JCValverde PhD Project/8-Multimedica/10-Moderation Analysis for LI"


log using "Moderation Analysis.txt", text replace name(OCT02Session)

import excel using "FINAL Experiment Data v2.xlsx", firstrow sheet("Sheet1")

list avg_mark if regexm(avg_mark, "[^0-9.]")

/* Eliminate NA values from avg_mark*/

* Replace "NA" with Stata's numeric missing value (.)
replace avg_mark = "." if avg_mark == "NA"

destring avg_mark, replace

* Drop observations where identif_dummyb is numerically missing
drop if missing(identif_dummy   )


/*DROP EMP NAME AND ANONIMIZE EMPNUM

* Drop emp_name*/
drop emp_name
drop role
drop avg_mark

/* anonymize emp_num */

describe emp_num
egen emp_num_anon = group(emp_num)
drop emp_num

/* anonymize department */

describe department
encode department, gen(department_anon)
drop department




/*GENERATION OF DUMMY VARIABLES AND LABELLING*/


gen identity_activation = 0
replace identity_activation = 1 if inlist(assignment_dummy, 2, 5, 6)

gen nf_treatment_dummy = 0
replace nf_treatment_dummy = 1 if inlist(assignment_dummy, 3,4,5,6)

label variable assignment_dummy "Condition Dummy"
label variable identity_activation "Identity Activation Dummy"
label variable intention_dummy "Intention to Perform Course"
label variable identif_dummy    "Identification"
label variable nf_treatment_dummy "NF Treatment"

/* EXPORT DATASET  */

export delimited using "simple_moderation_models.csv", replace

/* MODERATION MODEL:  DOES TRAINING CULTURE MODERATES INTENTION TO PERFORM COURSES AND NORMATIVE FEEDBACK? */

regress intention_dummy nf_treatment_dumm identif_dummy culture_avg c.nf_treatment_dumm#c.culture_avg, cluster(emp_num_anon)

display "Results: No evidence of moderation"

/* MODERATION MODEL:  DOES TRAINING CULTURE MODERATES COURSES COUNT AND NORMATIVE FEEDBACK? */

regress courses_count nf_treatment_dumm identif_dummy   culture_avg c.nf_treatment_dumm#c.culture_avg, cluster(emp_num_anon)

display "Results:No evidence of moderations"

/* MODERATION MODEL:  DOES POFIT MODERATES INTENTION TO PERFORM COURSES AND NORMATIVE FEEDBACK? */

regress intention_dummy nf_treatment_dumm identif_dummy   pofit_avg c.nf_treatment_dumm#c.pofit_avg, cluster(emp_num_anon)

regress courses_count nf_treatment_dumm identif_dummy   pofit_avg c.nf_treatment_dumm#c.pofit_avg, cluster(emp_num_anon)


display "Results:No evidence of moderation"

log close OCT02Session

/* END OF DO FILE */
