# Homework 7: Linux Commands


## Problem 1
### Deliverables
 `wc -w lorem-ipsum.txt`
 <Q1><img src="assets/Screenies/HW7/q1.png">

## Problem 2 
### Deliverables
`wc -m  lorem-ipsum.txt`
 <Q2><img src="assets/Screenies/HW7/q2.png">

## Problem 3 
### Deliverables
`wc -m  lorem-ipsum.txt`
 <Q3><img src="assets/Screenies/HW7/q3.png">

## Problem 4 
### Deliverables
`sort -h file-sizes.txt`
 <Q4><img src="assets/Screenies/HW7/q4.png">

## Problem 5 
### Deliverables
`sort -rh file-sizes.txt`
 <Q5><img src="assets/Screenies/HW7/q5.png">

## Problem 6 
### Deliverables
`cut -d',' -f3 log.csv`
 <Q6><img src="assets/Screenies/HW7/q6.png">

## Problem 7
### Deliverables
`cut -d',' -f2,3 log.csv`
 <Q7><img src="assets/Screenies/HW7/q7.png">

## Problem 8
### Deliverables
`cut -d',' -f1,4 log.csv`
 <Q8><img src="assets/Screenies/HW7/q8.png">

## Problem 9
### Deliverables
`head -n 3 gibberish.txt`
 <Q9><img src="assets/Screenies/HW7/q9.png">

## Problem 10
### Deliverables
`tail -n 3 gibberish.txt`
 <Q10><img src="assets/Screenies/HW7/q10.png">

## Problem 11
### Deliverables
`tail -n 20 log.csv`
 <Q11><img src="assets/Screenies/HW7/q11.png">

## Problem 12 
### Deliverables
`dmesg | grep "and" gibberish.txt` or `grep "and" gibberish.txt`
 <Q12><img src="assets/Screenies/HW7/q12.png">

## Problem 13 
### Deliverables
`dmesg | grep -w -n "we" gibberish.txt` or `grep -w -n "we" gibberish.txt`
 <Q13><img src="assets/Screenies/HW7/q13.png">

## Problem 14 
### Deliverables
`grep -i -o -P "to\s\w+" gibberish.txt`
 <Q14><img src="assets/Screenies/HW7/q14.png">

## Problem 15 
### Deliverables
`grep -c "FPGAs" fpgas.txt`
 <Q15><img src="assets/Screenies/HW7/q15.png">

## Proble, 16
### Deliverables
`grep -i -P "(hot|not|cower|tower|smile|compile)" fpgas.txt`
 <Q16><img src="assets/Screenies/HW7/q16.png">

## Problem 17
### Deliverables
`grep -r -E "^\s*--" --include="*.vhd" ../../hdl/ | cut -d: -f1 | sort | uniq -c | awk '{print $2 ":" $1}'`
 <Q17><img src="assets/Screenies/HW7/q17.png">

## Problem 18
### Deliverables
`ls > ls-output.txt && cat ls-output.txt`
 <Q18><img src="assets/Screenies/HW7/q18.png">

## Problem 19
### Deliverables
`sudo dmesg | grep "CPU topo"`
 <Q19><img src="assets/Screenies/HW7/q19.png">

## Problem 20
### Deliverables
`find ../../hdl/ -iname '*.vhd' | wc -l`
 <Q20><img src="assets/Screenies/HW7/q20.png">

## Problem 21
### Deliverables
`grep -r --include="*.vhd" "^\s*--" ../../hdl/ | wc -l`
 <Q21><img src="assets/Screenies/HW7/q21.png">

## Problem 22
### Deliverables
`grep -n "FPGAs" fpgas.txt | cut -d: -f1`
 <Q22><img src="assets/Screenies/HW7/q22.png">

## Problem 23
### Deliverables
`du -h ../../* | sort -hr | head -n 3`
 <Q23><img src="assets/Screenies/HW7/q23.png">
