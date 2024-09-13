
clear all
cap log close
set more off, perm

//storing the number 1 to a scalar named i
scalar i = 1
display "1 = " i


set seed 15

set obs 200

gen randnum = runiform()


**randuniform has been used to generate uniformly distributed random variables

**The command `gen randnum = runiform()` in Stata generates a new variable called `randnum` in your dataset, where each observation is assigned a random number drawn from a uniform distribution on the interval (0,1)

list randnum in 1/5

//generate uniformly distributed random integer variates on the interval [a,b]

gen age = runiformint(18,65)

//generate binomial (n,p) random variables where n is the number of trials and p is the successs probability

gen female = rbinomial(1, 0.5)

list female in 1/5

//generate random values from a normal density with eman equal to m and standard deviation equal to s

gen weight = rnormal(72,15)
gen hieght = rnormal(170,10)

**In this example, we generated weight and hieght independently, but variables like weight and hieght are likely to be correlated, and you can generate correlated variables using command //drawnorm

matrix m = (72, 170)
matrix s = (15,10)

matrix C = (1.0, 0.5 \ 0.5, 1.0)

drawnorm weight hieght, n(200) means(m) sds(s) corr(C) clear

summarize

correlate

//test the null hypothesis that the mean weight is equal to 70

ttest weight = 70

return list

//can store any of these scalars to another scalar. For exmaple we can store the two-sided p-value stored in r(p) to a scalar named pvalue by typing

scalar pvalue = r(p)

display "The two-sided p-value is", pvalue

list weight hieght in 1/5

//%%%%%%%%%%%%%%%
//simttest

program simttest, rclass
version 15.1
end

//Define the input parameters and their default values
//generate the random data and test the null hypothesis
//return results

capture program drop simttest
program simttest, rclass
version 15.1

syntax, n(integer)  ///sample size
[alpha(real 0.05)   ///Alpha level
m0(real 0)          ///Mean under the null
ma(real 1)          ///Mean under the alternative
sd(real 1)          //Standard deviation

]

//Generate the random data and test the null hypothesis
drawnorm y, n(`n') means(`ma') sds(`sd') clear
ttest y = `m0'

return scalar reject = (r(p)<`alpha')

end 


//n() is the required paramter and fourth optional parameters enclosed in square brackets

//The argument reject=r(reject) tells simulate to save the results returned in r(reject) to a variable named reject. The option reps(100) instructs simulate to run your program 100 times. The option seed(12345) sets the random number seed so that our results will be reproducible

simttest, n(100) m0(70) ma(75) sd(15) alpha(0.05)

simulate ttest, n(100) m0(70) ma(75) sd(15) alpha(0.05)
 























