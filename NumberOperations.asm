TITLE Number Operations
; Description: This program will introduce the programmer, and prompt them to run
;				one of the following five programs:
;				1: Elementary Arithmetic - takes two integer inputs from user and
;					 returns the result of basic operations i.e. +, -, *, and /
;				2: Fibonacci Sequence Generator - takes an integer input n from user 
;					and prints the first n numbers in the fibonacci sequence
;					(1, 1, 2, 3, 5, etc.)
;				3: Composite Number Generator - takes an integer input n from user 
;					and prints the first n composite numbers (4, 6, 8, 9, etc.)
;				4: Random Number Generator - takes an integer input n from user and 
;					prints out n random integers. Then, sorts integers recursively
;					using QuickSort and prints out integers in descending order.
;				5: Mean, Median, and Sum of Ten Numbers - prompts the user for ten
;					integer inputs and returns the mean, median, and sum of inputs
;				At the end of each program, user is given the option to go back to
;				the main menu and try a different program.

INCLUDE Irvine32.inc

; displays the string stored at the memory location strAddress
displayString	MACRO strAddress
	push	edx			; Save edx register
	mov		edx, strAddress
	call	WriteString
	pop		edx			; restore edx
ENDM

; writes up to inputLength characters into memory location strAddress
getString		MACRO	strAddress, inputLength
	push	ecx			; Save ecx and edx registers
	push	edx

	mov		ecx, inputLength
	mov		edx, strAddress
	call	readString

	pop		edx			; restore ecx and edx
	pop		ecx
ENDM

; Constants
MAX_INPUT = 46			; largest allowed value for integer entered by user
MIN_INPUT = 1   		; smallest allowed value for integer entered by user
TERMS_PER_LINE = 5		; number of terms to be displayed in one line

MAX_INPUT_3 = 2000		; largest allowed value for integer entered by user
MIN_INPUT_3 = 1   		; smallest allowed value for integer entered by user
NUM_PRIMES_3 = 400		; constant, used to store prime numbers found so far
						; 303 prime numbers between 1 and 2000
TERMS_PER_LINE_3 = 10	; number of terms to be displayed in one line
TERMS_PER_PAGE_3 = 200	; number of terms to be displayed in one page

MAX_INPUT_4 = 200			; largest allowed value for integer entered by user
MIN_INPUT_4 = 10   		; smallest allowed value for integer entered by user
RAND_MIN = 109			; smallest allowed random generated value
RAND_MAX = 999			; largest allowed random generated value

MAX_LEN = 12			; maximum number of terms (4,294,967,295 has 10 digits)
						; so 10 + 1 = 11 (in case first digit < 4) plus 1 for zero bit
NUM_TERMS = 10			; number of terms to get user to enter
LO = 48					; '0' in ASCII 
HI = 57					; '9' in ASCII

.data
numberOne		DWORD	?		; first number entered by user
numberTwo		DWORD	?		; second number entered by user
intro1_1  		BYTE	"PROGRAM 1:	ELEMENTARY ARITHMETIC	by Jonathan Matsumoto",0
intro1_2		BYTE	"Enter 2 numbers, and I'll show you the sum, difference,",0
intro1_3  		BYTE	"product, quotient, and remainder.",0
prompt_1 		BYTE	"First number: ",0
prompt_2 		BYTE	"Second number: ",0
sum      		DWORD	?		; sum of first and second number entered by user
diff     		DWORD	?		; difference of first and second number entered by user
prod     		DWORD	?		; product of first and second number entered by user
quot     		DWORD	?		; quotient of dividing first number by second number
remn     		DWORD	?		; remainder of dividing first number by second number
result_1 		BYTE	" + ",0
result_2 		BYTE	" - ",0
result_3 		BYTE	" x ",0
result_4		BYTE	" + ",0
result_5 		BYTE	" = ",0
result_6 		BYTE	" remainder ",0
goodBye  		BYTE	"Impressed? Bye!",0
ec1_1      		BYTE	"**EC: Repeat until the user chooses to quit.",0
ec1_2      		BYTE	"**EC: Program verifies second number less than first.",0
ec1_3      		BYTE	"**EC: Calculate and display the quotient as a floating-point number, rounded to the nearest .001.",0
ec1_1_msg  		BYTE	"Do you want to try another two numbers?",0
ec1_1_msg2 		BYTE	"Enter 1 to Repeat or 0 to Quit: ",0
ec1_2_msg  		BYTE	"The second number must be less than the first!",0
repeatVal 		DWORD	?		; value of whether user wants to repeat (1 for Repeat, 0 for Quit)
fpQuotient		DWORD	?		; represents the floating point number
wholePart 		DWORD	?		; whole numnber part of floating point number (before decimal point)
fracPart  		DWORD	?		; fractional part of floating point number (after decimal point)
oneK      		DWORD	1000	; we multiply by 1000, convert to an Int, and then divide by 1000 to round to .001
point     		BYTE	".",0
zero      		DWORD	0		; for printing leading zeros in the decimal part

userName 	BYTE	33 DUP(0)	; string to be entered by the user
userNum	 	DWORD	?	     	; integer to be entered by user
intro2_1	 	BYTE	"PROGRAM 2: FIBONACCI NUMBER GENERATOR",0
intro2_2	 	BYTE	"Programmed by Jonathan Matsumoto",0
prompt2_1 	BYTE	"What's your name? ",0
prompt2_2 	BYTE	"Hello, ",0
prompt2_3 	BYTE	"Enter the number of Fibonacci terms to be displayed",0
prompt2_4 	BYTE	"Give the number as an integer in the range [1 .. 46].",0
prompt2_5 	BYTE	"How many Fibonacci terms do you want? ",0
error2_1	 	BYTE	"Out of range. Enter a number in [1 .. 46]",0
goodBye2_1	BYTE	"Results certified by Jonathan Matsumoto.",0
goodBye2_2	BYTE	"Goodbye, ",0
goodBye2_3	BYTE	".",0    
fibPrev		DWORD	0	    	; previous number in fibonacci sequence (initially 0)
fibCurr		DWORD	1	    	; current number in fibonacci sequence (initially 1
                     	    	; as 1 is the first number in the fibonacci sequence)
tabSpace 	BYTE	"	",0		; used to seperate numbers when printing sequence
ec2_1		BYTE	"**EC: Display the numbers in aligned columns."
numsSoFar	DWORD	0	    	; number of numsSoFar


n       	DWORD	?	     	; integer to be entered by user
intro3_1		BYTE	"PROGRAM 3: COMPOSITE NUMBER GENERATOR	Programmed by Jonathan Matsumoto",0
intro3_2		BYTE	"Enter the number of composite numbers you would like to see.",0
intro3_3		BYTE	"I'll accept orders for up to 2000 composites.",0
prompt3		BYTE	"Enter the number of composites to display [1 .. 2000]: ",0
error3		BYTE	"Out of range. Try again.",0
goodBye3		BYTE	"Results certified by Jonathan Matsumoto. Goodbye.",0
lastComp	DWORD	4	    	; last composite number (initially 4 - the first value)
ec3_1		BYTE	"**EC: Display the numbers in aligned columns.",0
ec3_2		BYTE	"**EC: Display up to 2,000 composites, one page at a time (200 per page).",0
ec3_3		BYTE	"**EC: Check against only prime divisors.",0
nextMsg		BYTE	" numbers left to display. ",0
primes		DWORD	NUM_PRIMES_3	DUP(?)	; prime numbers so far (initially empty)
count		DWORD	?

intro4_1		BYTE	"PROGRAM 4: RANDOM NUMBER GENERATOR",0
intro4_2		BYTE	"This program generates random numbers in the range [100 .. 999],",0
intro4_3		BYTE	"displays the original list, sorts the list, and calculates the",0
intro4_4		BYTE	"median value. Finally, it displays the list sorted in descending order.",0
prompt4		BYTE	"How many numbers should be generated? [10 .. 200]: ",0
error4		BYTE	"Invalid input",0
display4_1	BYTE	"The unsorted random numbers:",0
display4_2	BYTE	"The sorted random numbers:",0
medianMsg	BYTE	"The median is ",0
period		BYTE	".",0
request 	DWORD	?	     			; integer to be entered by user
validReq	DWORD	?					; 0 if number inputted is valid, otherwise 1
intArray	DWORD	MAX_INPUT_4	DUP(?)	; randomly generated array (initially empty)
ec4_1		BYTE	"**EC: Displays the numbers ordered by column instead of by row.",0
ec4_2		BYTE	"**EC: Uses a recursive sorting algorithm (Quick Sort).",0
ec4_3		BYTE	"**EC: FPU is used to calculate the median.",0
ec4_4		BYTE	"**EC: Numbers are generated into and read from a file.",0
fileName	BYTE	"randNum.txt",0

intro5_1		BYTE	"PROGRAM 5: MEAN, MEDIAN, AND SUM OF TEN NUMBERS",0
intro5_2		BYTE	"Written by: Jonathan Matsumoto,",0
intro5_3		BYTE	"Please provide 10 unsigned deicmal integers.",0
intro5_4		BYTE	"After you have finished inputting the raw numbers I will display a list",0
intro5_5		BYTE	"of the integers, their sum, and their average value.",0
prompt5			BYTE	". Please enter an unsigned number: ",0
error5_1		BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0
error5_2		BYTE	"Please try again: ",0
display5_1		BYTE	"You entered the following numbers:",0
display5_2		BYTE	"The sum of these numbers is: ",0
display5_3		BYTE	"The average is: ",0
ec5_1			BYTE	"**EC: Numbers each line of user input and displays a running subtotal.",0
subtotalMsg5	BYTE	"The running subtotal of numbers so far is: ",0
comma5			BYTE	", ",0
goodBye5		BYTE	"Thanks for playing!",0
inputStr5		BYTE	MAX_LEN		DUP(?)	; holds user input (used for processing numList)
outputStr5		BYTE	MAX_LEN		DUP(?)	; holds user output (used as placeholder in writeVal)
numList5		DWORD	NUM_TERMS	DUP(0)	; holds the terms user entered (converted to int)


prompt6_1	BYTE	"Which of the following do you want to open?",0
prompt6_2	BYTE	"1: Elementary Arithmetic",0
prompt6_3	BYTE	"2: Fibonacci Sequence Generator",0
prompt6_4	BYTE	"3: Composite Number Generator",0
prompt6_5	BYTE	"4: Random Number Generator",0
prompt6_6	BYTE	"5: Mean, Median and Sum of Ten Numbers",0
prompt6_7	BYTE	"Please enter your choice : ",0
error6_1	BYTE	"ERROR! Invalid input. Try again: ",0
endMsg6_1	BYTE	"Try another program? Enter '1' : ",0
endMsg6_2	BYTE	"'1' not selected. Ending program.",0


.code
main PROC
displayOptions:
	displayString	OFFSET prompt6_1
	call	CrLf
	displayString	OFFSET prompt6_2
	call	CrLf
	displayString	OFFSET prompt6_3
	call	CrLf
	displayString	OFFSET prompt6_4
	call	CrLf
	displayString	OFFSET prompt6_5
	call	CrLf
	displayString	OFFSET prompt6_6
	call	CrLf
	displayString	OFFSET prompt6_7
getNum:
	; get the number (must be between 1 - 46)
	call	ReadInt
	mov		userNum, eax

	mov		eax, userNum
	cmp		eax, 1
	je		runProg1
	cmp		eax, 2
	je		runProg2
	cmp		eax, 3
	je		runProg3
	cmp		eax, 4
	je		runProg4
	cmp		eax, 5
	je		runProg5
	mov		edx, OFFSET error6_1
	call	WriteString
	call	crLf
	jmp		getNum

runProg1:
	call	Clrscr
	call	prog1
	jmp		endProg

runProg2:
	call	Clrscr
	call	prog2
	jmp		endProg

runProg3:
	call	Clrscr
	call	prog3
	jmp		endProg

runProg4:
	call	Clrscr
	call	prog4
	jmp		endProg

runProg5:
	call	Clrscr
	call	prog5

endProg:
	call	CrLf
	displayString	OFFSET endMsg6_1
	call	ReadInt
	mov		userNum, eax

	mov		eax, userNum
	cmp		eax, 1
	jne		exitProg
	call	Clrscr
	jmp		displayOptions
	
exitProg:
	displayString	OFFSET endMsg6_2
	call	CrLf
	exit	; exit to operating system
main ENDP

prog1 PROC

; Introduce programmer
	mov  	edx, OFFSET intro1_1
	call 	WriteString
	call 	CrLf
	mov  	edx, OFFSET ec1_1
	call 	WriteString
	call 	CrLf
	mov  	edx, OFFSET ec1_2
	call 	WriteString
	call 	CrLf
	mov  	edx, OFFSET ec1_3
	call 	WriteString
	call 	CrLf
intro:
	call 	CrLf
	mov  	edx, OFFSET intro1_2
	call 	WriteString
	call 	CrLf
	mov  	edx, OFFSET intro1_3
	call 	WriteString
	call 	CrLf
	call 	CrLf

; Get the first number
	mov  	edx, OFFSET prompt_1
	call 	WriteString
	call 	readInt
	mov  	numberOne, eax

; Get the second number
	mov  	edx, OFFSET prompt_2
	call 	WriteString
	call 	readInt
	mov  	numberTwo, eax
	call 	CrLf

; **EC: Program verifies second number less than first.
	mov  	eax, numberTwo
	cmp  	eax, numberOne
	jl   	doArithmetic		; first < second, continue with operation
	mov  	edx, OFFSET ec1_2_msg	
	call 	WriteString			; otherwise, notify the user
	call 	CrLf				; and move to the quit/repeat sequence
	jmp  	quit

doArithmetic:
; Calculate sum of first and second number
	mov  	eax, numberOne
	mov  	ebx, numberTwo
	add  	eax, ebx
	mov  	sum, eax

; Calculate difference of first and second number
	mov  	eax, numberOne
	mov  	ebx, numberTwo
	sub  	eax, ebx
	mov  	diff, eax

; Calculate product of first and second number
	mov  	eax, numberOne
	mov  	ebx, numberTwo
	mul  	ebx
	mov  	prod, eax

; Calculate quotieint of first and second number
	mov  	eax, numberOne
	cdq 
	mov  	ebx, numberTwo
	div  	ebx
	mov  	quot, eax
	mov  	remn, edx

; **EC: Calculate the quotient as a floating-point number, 
; rounded to the nearest .001.
	fld  	numberOne		; converts numberOne to floating-point double
							; loads it to FPU register stack, i.e. ST(0)
	fdiv 	numberTwo		; does the division 
	fimul	oneK			; .001 is 1/1000, so to round we multiply by 1000,
							; round to nearest Int (then divide by 1000 later)
							; note: if result > (2 ^ 31 - 1) + 10^3, then overflow
	frndint					; round ST(0) to an integer
	fistp	fpQuotient		; store ST(0) into fpQuotient
	mov  	eax, fpQuotient	; now, we move back to ALU to finish
	cdq	
	mov  	ebx, oneK		; divide by 1000, whole number part now in EAX,
	div  	ebx				; fractional part now in EDX (whole.frac e.g. 2.5)
	mov  	wholePart, eax	; move whole number part to wholePart
	mov  	fracPart, edx	; move fractional part to fracPart

; Report the sum of the first and second number
	mov  	eax, numberOne
	call 	WriteDec
	mov  	edx, OFFSET result_1
	call 	WriteString
	mov  	eax, numberTwo
	call 	WriteDec
	mov  	edx, OFFSET result_5
	call 	WriteString
	mov  	eax, sum
	call 	WriteDec
	call 	CrLf

; Report the difference of the first and second number
	mov  	eax, numberOne
	call 	WriteDec
	mov  	edx, OFFSET result_2
	call 	WriteString
	mov  	eax, numberTwo
	call 	WriteDec
	mov  	edx, OFFSET result_5
	call 	WriteString
	mov  	eax, diff
	call 	WriteDec
	call 	CrLf

; Report the product of the first and second number
	mov  	eax, numberOne
	call 	WriteDec
	mov  	edx, OFFSET result_3
	call 	WriteString
	mov  	eax, numberTwo
	call 	WriteDec
	mov  	edx, OFFSET result_5
	call 	WriteString
	mov  	eax, prod
	call 	WriteDec
	call 	CrLf
	
; Report the quotient of the first and second number
	mov  	eax, numberOne
	call 	WriteDec
	mov  	edx, OFFSET result_4
	call 	WriteString
	mov  	eax, numberTwo
	call 	WriteDec
	mov  	edx, OFFSET result_5
	call 	WriteString
	mov  	eax, quot
	call 	WriteDec
	mov  	edx, OFFSET result_6
	call 	WriteString
	mov  	eax, remn
	call 	WriteDec

; **EC: Display the quotient as a floating-point number,
; rounded to the nearest .001.
	mov  	edx, OFFSET result_5
	call 	WriteString
	mov  	eax, wholePart
	call 	WriteDec		; writes out whole number part
	mov  	edx, OFFSET point
	call 	WriteString
	mov  	eax, fracPart
	cmp  	eax, 10			; if < 10, then we need to add two zeros
	jl   	lessThan10		; before trailing digit e.g. 2 -> .002
	cmp  	eax, 100		; if < 100, then we need to add a zero
	jl   	lessThan100		; before trailing digit e.g. 25 -> .025
	jmp  	printDec
lessThan10:			
	mov  	eax, zero
	call 	WriteDec		; print out leading 0
lessThan100:
	mov  	eax, zero
	call 	WriteDec		; print out leading 0
printDec:
	mov  	eax, fracPart	; write out the fractional part
	call 	WriteDec
	call 	CrLf

quit:
; **EC: Repeat until the user chooses to quit.
	;	Prompt user to enter 0 (Quit) or 1 (Repeat)
	call 	CrLf
	mov  	edx, OFFSET	ec1_1_msg
	call 	WriteString
	call 	CrLf
	mov  	edx, OFFSET ec1_1_msg2
	call 	WriteString
	call 	readInt
	mov  	repeatVal, eax

	;	Quit or Repeat based on user input
	mov  	eax, repeatVal
	cmp  	eax, 0
	jg   	intro			; if > 0 (i.e. 1), go back to prompt
							; otherwise, continue with quit process

; Say "Good-bye"
	call 	CrLf
	mov  	edx, OFFSET goodBye
	call 	WriteString
	call 	CrLf

	ret
prog1 ENDP

prog2 PROC
	; introduction

	mov		edx, OFFSET intro2_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro2_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec2_1
	call	WriteString
	call	CrLf
	call	CrLf

	; get the user's name
	mov		edx, OFFSET prompt2_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

; userInstructions
	mov		edx, OFFSET prompt2_2
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt2_3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt2_4
	call	WriteString
	call	CrLf
	call	CrLf

; getUserData

getNum:
	; get the number (must be between 1 - 46)
	mov		edx, OFFSET prompt2_5
	call	WriteString
	call	ReadInt
	mov		userNum, eax

	; make sure number is between 1 and 46
	; first, check that number is >= 1
	mov		eax, userNum
	cmp		eax, MIN_INPUT
	jl		errorMsg			; number is < 1, go to errorMsg

	; second, check that number is <= 46
	mov		eax, userNum
	cmp		eax, MAX_INPUT
	jg		errorMsg			; number is > 46, go to errormsg
	call	CrLf
	jmp		displayFibs			; number is fine otherwise
								; skip errorMsg, go to displayFibs

errorMsg:
	mov		edx, OFFSET error2_1
	call	WriteString
	call	crLf
	jmp		getNum

; displayFibs

displayFibs:
	; display the current value (stored in fibCurr), then 
	; calculate its new value as follows:
	; set fibPrev to current value of fibCurr
	; add fibPrev to fibCurr to get new value of fibCurr
	; repeat userNum times
	mov		ecx, userNum
fibLoop:
	mov		eax, fibCurr
	call	WriteDec

	mov		eax, fibCurr
	mov		edx, fibPrev
	mov		fibPrev, eax
	add		eax, edx
	mov		fibCurr, eax

	; EC: update nubmers we've printed so far to calculate if we need an extra space
	mov		eax, numsSoFar
	inc		eax					; indicate that we have printed one new term
	mov		numsSoFar, eax		; save new value of numsSoFar
	cmp		eax, 35            	
	jge		singleTab			; if this is >= the 35th term, only need one tab
	mov		edx, OFFSET tabSpace
	call	WriteString

singleTab:
	mov		edx, OFFSET tabSpace
	call	WriteString

	; when we reach TERMS_PER_LINE, we need to start a new line
	; check by dividing numsSoFar by TERMS_PER_LINE
	cdq
	mov		ebx, TERMS_PER_LINE
	div		ebx
	cmp		edx, 0				; if remainder of numsSoFar / TERMS_PER_LINE
	je		resetLine			; is zero, start a new line
	jmp		continueLoop

resetLine:
	cmp		ecx, 1				; edge case: if final iteration of loop,
	je		continueLoop		; no need to print an extra line
	call	CrLf

continueLoop:
	loop	fibLoop
	call	CrLf

; farewell
	call	CrLf
	mov		edx, OFFSET goodBye2_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodBye2_2
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET goodBye2_3
	call	WriteString
	call	CrLf

	ret
prog2 ENDP

prog3 PROC
	call	introduction3
	call	getUserData3
	call	showComposites3
	call	farewell3

	ret
prog3 ENDP

; Procedure to introduce the program
; receives: none
; returns: none
; preconditions: none
; registers changed: edx
introduction3 PROC
	mov		edx, OFFSET intro3_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec3_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec3_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec3_3
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET intro3_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro3_3
	call	WriteString
	call	CrLf
	call	CrLf

	ret
introduction3 ENDP

; Procedure to get value for n from the user
; receives: none
; returns: user input for global variable n
; preconditions: none
; registers changed: eax, edx
getUserData3 PROC
	; CITE: same as Program 02
	; get the number
	mov		edx, OFFSET prompt3
	call	WriteString
	call	ReadInt
	mov		n, eax

	; call subprocedure to validate
	call	validate3

	ret
getUserData3 ENDP


; Procedure to verify that user input n meets criterion of 
; MIN_VALUE <= n <= MAX_VALUE (where MIN_VALUE and MAX_VALUE are constants)
; receives: n, a global variable
; returns: none
; preconditions: none
; registers changed: eax, edx
validate3 PROC
	; first, check that number is >= 1
	mov		eax, n
	cmp		eax, MIN_INPUT_3
	jl		errorMsg			; number is < 1, go to errorMsg

	; second, check that number is <= 46
	mov		eax, n
	cmp		eax, MAX_INPUT_3
	jg		errorMsg
	jmp		cont		; number is fine, skip errorMsg

errorMsg:
	mov		edx, OFFSET error3
	call	WriteString
	call	crLf
	call	getUserData3

cont:
	ret
validate3 ENDP


; Procedure to display the composite numbers between 1 and n
; receives: lastComp and n, global variables, and primes, an array of prime divisors
; returns: none
; preconditions: 1 <= n <= 400 (checked in validate procedure)
; registers changed: eax, ecx, edx, esi
showComposites3 PROC
	call	CrLf
	mov		ecx, n ; amount of times to run loop

printComposite:
	; print the next composite number

	push	OFFSET primes		; pass array of prime integers (prime divisors) by reference
	push	OFFSET count		; pass # of elements in array by reference
	call	isComposite3		; calculates next composite number
	mov		eax, lastComp		; value of lastComposite number (calculated in isComposite)
	call	WriteDec
	inc		eax
	mov		lastComp, eax

	; **EC: Display the numbers in aligned columns. CITE: code from Project 02.
	mov		edx, OFFSET tabSpace
	call	WriteString
	mov		eax, n				; iterations = n - # of iterations remaining + 1 
	sub		eax, ecx			; (already printed for this iteration)
	inc		eax
	mov		esi, eax			; temporarily hold this value in ESI (might have to check twice)
	cdq							; if it is at the end of line (divisible by TERMS_PER_LINE), then
	mov		ebx, TERMS_PER_LINE_3	; might also be at end of the page (divisible by TERMS_PER_PAGE)
	div		ebx					; if remainder of numsSoFar / TERMS_PER_LINE = 0,
	cmp		edx, 0				; then we have reached last term in the line, print new line
	jne		continueLoop		; if not, continue with loop (don't need to check for page)
	call	CrLf
	; **EC: Display more composites, one page at a time.
	cmp		ecx, 1				; if this is the final element (ecx = 1), no need to refresh page
	je		continueLoop		
	mov		eax, esi			; re-use the value we saved in ESI in line 154
	cdq
	mov		ebx, TERMS_PER_PAGE_3 ; if remainder of numsSoFar / TERMS_PER_LINE = 0,
	div		ebx					; then we have reached last term in the page, pause the program
	cmp		edx, 0				; and then clear the screen before continuing.
	jne		continueLoop
	call	CrLf
	mov		eax, ecx
	dec		eax
	call	WriteDec
	mov		edx, OFFSET nextMsg
	call	WriteString
	call	WaitMsg				; CITE: Irvine, page 159
	call	Clrscr				; CITE: Irvine, page 159

continueLoop:
	loop	printComposite
	call	CrLf
	mov		eax, n				; if n % 10 != 0, need another linespace
	mov		ebx, 10
	cdq
	div		ebx
	cmp		edx, 0
	je		endProgram
	call	CrLf

endProgram:
	ret
showComposites3 ENDP

; Verifies that a user is compoiste. If not, finds the next composite number.
; receives: lastComp, a global variable and primes, an array of prime divisors
; returns: updated value of next composite number >= lastComp
; preconditions: none
; registers changed: eax, ebx, edx, esi, edi
isComposite3 PROC
	push	ecx					; save ecx - value of loop counter if called from showComposites
	push	ebp					; set up stack frame
	mov		ebp, esp
setup:							; CITE: using Array traversal algorithm from Lecture 19
	mov		esi, [ebp+16]		; @ primes (array containing all the prime divisors)
	mov		edi, [ebp+12]		; @ count (# of elements in prime)
	mov		ecx, [edi]			; ecx is loop control, count is value located at edi
	cmp		ecx, 0				; primes unitialized initially. check if it has been initialized.
	jg		checkComposite		; if ecx is greater than 0, initialized. skip to checkComposite
	mov		eax, 2
	mov		[esi], eax			; move in first prime (2)
	inc		ecx					; update ecx to reflect new element
	add		esi, 4				; move to next index in array
	mov		eax, 3
	mov		[esi], eax			; move in second prime (3)
	inc		ecx					; update ecx to reflect new element
	mov		[edi], ecx			; update count to reflect changes
	sub		esi, 4				; reset ESI to location of beginning of the array
checkComposite:
	mov		eax, lastComp		; load candidate value for composite
	cdq							; extend eax
	mov		ebx, [esi]			; move in next element from primes array for comparison
	div		ebx					; divide candidate value / next element
	cmp		edx, 0				; check remainder
	je		passTest			; if remainder = 0, # divides evenly (therefore, composite)
	add		esi, 4				; otherwise, increment esi to next location in array
	loop	checkComposite		; repeat for every element in the array
	mov		eax, lastComp		; if we complete loop without finding match,
	mov		[esi], eax			; candidate value failed. add to the list of Primes
	mov		eax, [edi]			; and increment the array's count to reflect this addition
	inc		eax
	mov		[edi], eax
	inc		lastComp			; increment the candidate value (next possible composite #)
	jmp		setup				; set up loop to check this new candidate value
passTest:
	pop		ebp					; restore stack frame
	pop		ecx					; restore loop counter value for outer procedure

	ret		8
isComposite3 ENDP

; Procedure to display farewell message to the user
; receives: goodBye
; returns: none
; preconditions:
; registers changed: edx
farewell3 PROC
	mov		edx, OFFSET goodBye3
	call	WriteString
	call	CrLf

	ret
farewell3 ENDP

prog4 PROC
	call	Randomize
	call	introduction4

	push	OFFSET request
	call	getData4

	push	OFFSET fileName
	push	OFFSET intArray
	push	request
	call	fillArray4

	push	OFFSET display4_1
	push	OFFSET tabSpace
	push	OFFSET intArray
	push	request
	call	displayList4

	push	OFFSET intArray
	push	request
	call	sortList4

	push	OFFSET intArray
	push	request
	call	displayMedian4

	push	OFFSET display4_2
	push	OFFSET tabSpace
	push	OFFSET intArray
	push	request
	call	displayList4
	ret
prog4 ENDP

; Procedure to introduce the program
; receives: none
; returns: none
; preconditions: none
; registers changed: edx
introduction4 PROC
	mov		edx, OFFSET intro4_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro4_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro4_3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro4_4
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	ec4_1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET	ec4_2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET	ec4_3
	call	WriteString
	call	Crlf
	mov		edx, OFFSET	ec4_4
	call	WriteString
	call	Crlf
	call	CrLf

	ret
introduction4 ENDP

; Procedure to get value for request from the user
; receives: address of request parameter on the system stack  (passed on system stack)
; returns: user input value for request
; preconditions: none
; registers changed: none (saved to system stack and restored)
getData4 PROC
	; set up system stack
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	edx
	mov		ebx, [ebp+8]

input:
	; CITE: based off solution Program 02/03
	; get the number
	mov		edx, OFFSET prompt4
	call	WriteString
	mov		eax, [ebp+8]
	call	ReadInt
	mov		[ebx], eax

	; make sure number is between MIN_INPUT and NAX_INPUT
	; first, check that number is >= MIN_INPUT
	cmp		eax, MIN_INPUT_4
	jl		errorMsg			; number is < MIN_INPUT, go to errorMsg
	; second, check that number is < MAX_INPUT
	cmp		eax, MAX_INPUT_4
	jg		errorMsg
	jmp		finishInput

errorMsg:
	mov		edx, OFFSET error4
	call	WriteString
	call	Crlf
	jmp		input

finishInput:
	pop		edx
	pop		ebx
	pop		eax
	pop 	ebp
	ret		4
getData4 ENDP

; Generates random numbers into a file and then reads them back into intArray
; receives: address of request parameter, first element of intArray, name of file to save to (passed on system stack)
; returns: none
; preconditions: none
; registers changed: none (saved on system stack)
fillArray4 PROC
	; set up the system stack
	push	ebp
	mov		ebp, esp

	; generate random numbers and copy them to file
	call	writeNumbersToFile

	; read numbers from file into intArray
	call	readNumbersFromFile

	pop		ebp
	ret		12
fillArray4 ENDP

; Generates random numbers and copies them into an output file
; receives: address of request paramete, first element of intArray, name of file to save to (passed on system stack 
;			from calling function fillArray)
; returns: none
; preconditions: none
; registers changed: none (saved on system stack)
writeNumbersToFile PROC
	push	ebp
	mov		ebp, esp
	pushad

	; create the output file
	mov		edx, [ebp+24]
	call	CreateOutputFile

	mov		edi, [ebp+20]
	mov		ecx, [ebp+16]

fillRandInt:
	; generate a random value between RAND_MIN and RAND_MAX
	mov		eax, RAND_MAX
	sub		eax, RAND_MIN
	inc		eax
	call	RandomRange
	add		eax, RAND_MIN

	; store generated value in array
	mov		[edi], eax

	push ecx

	; copy value from array to output file
	mov		eax, [ebp+24]
	mov		edx, edi
	mov		ecx, 4
	call	WriteToFile

	add		edi, 4

	pop		ecx
	loop	fillRandInt

	call	CloseFile

	popad
	pop		ebp
	ret
writeNumbersToFile ENDP

; Reads numbers from an input file back into intArray
; receives: address of request paramete, first element of intArray, name of file to save to (passed on system stack 
;			from calling function fillArray)
; returns: none
; preconditions: none
; registers changed: none (saved on system stack)
readNumbersFromFile PROC
	push	ebp
	mov		ebp, esp
	pushad

	; create the output file
	mov		edx, [ebp+24]
	call	OpenInputFile

	mov		edi, [ebp+20]
	mov		ecx, [ebp+16]

fillRandInt:
	push	ecx

	mov		eax, [ebp+24]
	mov		edx, edi
	mov		ecx, 4
	call	ReadFromFile

	add		edi, 4

	pop		ecx
	loop	fillRandInt

	call	CloseFile

	popad
	pop		ebp

	ret
readNumbersFromFile ENDP

; Displays the elements of the array in column-major order, along with any introductory message
; receives: address of request parameter, first element of intArray, and strings to print  (passed on system stack)
; returns: none
; preconditions: none
; registers changed: none (saved on system stack and restored)
displayList4 PROC
	; set up the system stack
	push	ebp
	mov		ebp, esp

	pushad


	; print out whether list was sorted or not
	call	Crlf
	mov		edx, [ebp+20]
	call	WriteString
	call	Crlf

	; move over array information
	mov		esi, [ebp+12]
	mov		eax, [ebp+8]
	
	; calculate one past the end of the array
	mov		ebx, 4
	mul		ebx
	mov		edx, esi
	add		edx, eax

	push	edx
	mov		eax, [ebp+8]
	mov		ebx, 10
	cdq
	div		ebx	
	inc		edx
	push	edx			; save on stack for adjusting stride
	inc		eax			
continueSetup:
	mov		ecx, eax	; setup rowLoop counter
	cmp		edx, 1
	jne		setupRows
	dec		ecx			; if we have amount of elements (remainder + 1 = 1),
						; no extra elements to print out in final row - skip

setupRows:
	; row stride (to maintain 10 items per column) = (request / 10 + 1) * 4
	mov		ebx, 4
	mul		ebx
	mov		ebx, eax
	pop		eax
	pop		edx

	; clone esi so we can come back to this point at end of each row
	mov		edi, esi


rowLoop:
	; idea is to move to print out every 10th item in matrix 10 times,
	; then on to next e.g. 1->11->21->...->91 then 2->12->22->...->92, etc.
	push	ecx
	mov		ecx, 0
	push	ecx
	colLoop:
			push	eax
			mov		eax, [esi]		; print out next element
			call	WriteDec
			push	edx				; print tab space (save end of array offset)
			mov		edx, [ebp+16]
			call	WriteString
			pop		edx

			pop		eax				; check if we need to adjust stride or start new row
			pop		ecx

			inc		ecx	
			cmp		ecx, eax		; need to decrase stride (1 less element in this column)
			jne		checkRowNum
			sub		ebx, 4
			jmp		contColLoop2

		checkRowNum:
			push	edx
			mov		edx, [ebp-36]
			cmp		edx, 1			; final row, may need to terminate early
			jne		contColLoop1
			inc		ecx
			cmp		ecx, eax
			je		contRowLoop		; final element of final row, done printing
			dec		ecx
		contColLoop1:
			pop		edx
		contColLoop2:
			push	ecx
			add		esi, ebx		; moves esi 10 items over

			cmp		esi, edx
			jl		colLoop			; while esi < one past end of array
	contRowLoop:
	call	Crlf
	add		ebx, 4
	add		edi, 4					; move on to next row (column in row-column order)
	mov		esi, edi
	pop		ecx
	pop		ecx
	loop	rowLoop

	popad

	pop		ebp	
	ret 16
displayList4 ENDP

; Sorts the list in-place by calling quickSort
; receives: address of request parameter and first element of intArray (passed on system stack)
; returns: none
; preconditions: none
; registers changed: eax, ebx, ecx, edx, esi
sortList4 PROC
	; set up system stack and pass values to system stack
	push	ebp
	mov		ebp, esp
	pushad

	mov 	ecx, [ebp+8] 
	mov 	esi, [ebp+12]

	; calculate address of hi (last index to partition)
	mov		eax, ecx
	mov		ebx, 4
	mul		ebx
	mov		ebx, eax
	sub		ebx, 4

	; initial quickSort from 0 to request - 1
	push	[ebp+12]
	push	0
	push	ebx
	push	[ebp+8]
	call 	quickSort

	popad
	pop ebp
	ret 8
sortList4 ENDP

; Sorts the array in-place recursively using Quick Sort in O(nlogn) time
; Receives: address of the array, starting and end index of quicksort,
;			and total number of elements in array
; Returns: array sorted in place
; Preconditions: none
; Registers Changed: none (saved to system stack and restored)
QuickSort 	PROC
	push	ebp
	mov		ebp, esp
	pushad


	mov		eax, [ebp+16]
	mov		ebx, [ebp+12]


	; base case: lo >= hi, nothing to sort
	cmp 	eax, ebx 			
	jge  	finishedSorting

	; save original values for lo and hi
	push 	eax
	push 	ebx

	; set ebx to address after hi so that when loop converges
	; all elements before it (including array[hi]) are sorted
	add 	ebx, 4

	; save pivot
	mov 	edi, [esi+eax]

	; set up loop
	mov		esi, [ebp+20]
	mov		ecx, [ebp+8]

; compare array[lo] to pivot. 
; if array[lo] < pivot, move hi towards pivot until not True (contLoop)
; if array[lo] >= pivot, move lo over until not True (repeat partition)
partition:
	; move on to next element in array (starts with 2nd element - 1st is pivot)
	add 	eax, 4

	; if lo >= hi or array[lo] < pivot, continue loop
	cmp 	eax, ebx
	jge 	contLoop 
	cmp 	[esi+eax], edi
	jl 	 	contLoop

	; otherwise, move to the next element in array until either condition met
	jmp 	partition

contLoop:
	; move the end of the partition over one until an element greater than pivot is found
	sub 	ebx, 4
	cmp 	[esi+ebx], edi
	jge 	firstSwap			; if found, swap that element with pivot
	jmp 	contLoop 			

firstSwap:
	; if lo >= hi, done partitioning, check to see if final swap necessary
	cmp 	eax, ebx
	jge 	finalSwap

	; otherwise, generate addresses for array[lo] and array[hi] and perform swap
	add		eax, esi
	add		ebx, esi
	push	eax
	push	ebx
	call	exchange

	; restore lo and hi and continue sorting
	sub		eax, esi
	sub		ebx, esi
	jmp  	partition

finalSwap:
	; restore original values for hi and lo
	pop 	edi
	pop 	ecx

	; compare value of lo and pivot
	; if they are the same, no swap needs to be made
	cmp 	ecx, ebx 
	je 		recursiveCall

	; otherwise, perform one final swap of array[hi] and pivot
	add		ebx, esi
	add		ecx, esi
	push	ebx
	push	ecx
	call	exchange

	; restore value of lo and pivot
	sub		ebx, esi
	sub		ecx, esi

recursiveCall:
	mov 	eax, ecx 			; low index
	push 	edi 				; save high index (for 2nd call)
	push  	ebx 				; save pivot index (for 2nd call)
	
	; first recursive call: quickSort on elements 0 to pivot - 1
	sub 	ebx, 4 				
	push	esi
	push	eax
	push	ebx
	push	ecx
	call 	quickSort

	pop 	eax 				; restore pivot
	add 	eax, 4  			; pivot + 1
	pop 	ebx 				; restore high index

	; second recursive call: quickSort on elements pivot + 1 to request
	push	esi
	push	eax
	push	ebx
	push	ecx
	call  	quickSort

finishedSorting:
	popad
	pop ebp
	ret 16
QuickSort 	ENDP


; exchanges two elements
; receives: address of both elements (passed on system stack)
; returns: none
; preconditions: none
; registers changed: none (saved on system stack and restored)
exchange PROC
	push	ebp
	mov		ebp, esp

	; save registers
	push	eax
	push	ebx
	push	edx
	push	esi

	mov		eax, [ebp+12]
	mov		ebx, [ebp+8]
	mov		edx, eax
	sub		edx, ebx
	
	mov		esi, ebx
	mov		ebx, [ebx]
	mov		eax, [eax]
	mov		[esi], eax
	add		esi, edx
	mov		[esi], ebx

	; restore registers
	pop		esi
	pop		edx
	pop		ebx
	pop		eax
	pop		ebp

	ret		8
exchange ENDP


; calculates and displays the median of a sorted list (uses FPU for even numbers)
; receives: address of request parameter and first element of intArray (passed on system stack)
; returns: none
; preconditions: list is sorted
; registers changed: none (saved on system stack and restored)
displayMedian4 PROC
	; set up the system stack and local variables
	LOCAL	median:DWORD
	LOCAL	two:REAL4
	pushad
	mov		esi, [ebp+12]
	
	; find index of median
	mov		eax, [ebp+8]
	cdq
	mov		ebx, 2
	div		ebx
	cmp		edx, 1
	jne		evenNumber

	; odd number: eax holds value of median
	mov		ebx, 4
	mul		ebx
	add		esi, eax
	mov		eax, [esi]
	mov		median, eax
	jmp		printMedian

evenNumber:
	; even number, need to average middle two elements
	mov		ebx, 4
	mul		ebx
	add		esi, eax
	mov		two, 2
	FINIT
	FILD	DWORD PTR [esi]
	sub		esi, 4
	FILD	DWORD PTR [esi]
	FADD
	FILD	two
	FDIV
	FIST	median

printMedian:
	call	Crlf
	mov		edx, OFFSET medianMsg
	call	WriteString
	mov		eax, median
	call	WriteDec
	mov		edx, OFFSET period
	call	WriteString
	call	Crlf

	popad
	ret 8
displayMedian4 ENDP


prog5 PROC
	push	OFFSET intro5_1
	push	OFFSET intro5_2
	push	OFFSET ec5_1
	push	OFFSET intro5_3
	push	OFFSET intro5_4
	push	OFFSET intro5_5
	call	introduction5

	push	OFFSET prompt5
	push	OFFSET subtotalMsg5
	push	OFFSET error5_1
	push	OFFSET error5_2
	push	OFFSET outputStr5
	push	OFFSET inputStr5
	push	OFFSET numList5
	call	getData5

	push	OFFSET outputStr5
	push	OFFSET display5_1
	push	OFFSET display5_2
	push	OFFSET display5_3
	push	OFFSET comma5
	push	OFFSET numList5
	call	displayStats5

	push	OFFSET goodBye5
	call	farewell5

	ret
prog5 ENDP

; Procedure to introduce the program
; receives: addresses to strings containing introduction messages (passed on system stack)
; returns: none
; preconditions: none
; registers changed: none
introduction5 PROC
	push	ebp
	mov		ebp, esp
	pushad

	; print first half of introduction (header)
	mov		ecx, 3
	mov		esi, ebp
	add		esi, 28
printIntro1:
	displayString	[esi]
	call	CrLf
	sub		esi, 4
	loop	printIntro1

	call	CrLf

	; print second half of introduction (description)
	mov		ecx, 3
printIntro2:
	displayString	[esi]
	call	CrLf
	sub		esi, 4
	loop	printIntro2
	call	Crlf

	popad
	pop		ebp
	ret		24
introduction5 ENDP

; Prompts user to enter an integer before getting the integer (using readVal) and then
; displaying the running subtotal. Also notifies the user how many numbers have been inputted so far.
; receives: address of array to store results, addresses of strings containing prompts and placeholder values
;			(passed on the system stack)
; returns: none
; preconditions: none
; registers changed: none
getData5 PROC
	; set up the system stack
	push	ebp
	mov		ebp, esp
	pushad

	mov		edi, [ebp+8]
	mov		ecx, NUM_TERMS		; set up loop counter
getNextInt:					
	; calculate line number
	mov		eax, NUM_TERMS	
	sub		eax, ecx
	inc		eax

	; print the line number
	push	[ebp+16]
	push	eax
	call	writeVal			; Line Number, e.g. "8"

	displayString  [ebp+32]		; ". Please enter an unsigned number: "

	push	[ebp+24]			; error messages
	push	[ebp+20]
	push	[ebp+12]			; placeholder string used to hold the input (before it is converted to an int)
	push	edi					; pushes address of array which holds inputs
	call	readVal

	cmp		ecx, 1				; if final iteration of loop, no need to print running subtotal
	je		finishLoop

	displayString	[ebp+28]	; "The running subtotal of numbers so far is: "

	; calculate subtotal
	push	0
	push	[ebp+8]
	call	calculateSum
	pop		eax

	; display subtotal
	push	[ebp+12]
	push	eax
	call	writeVal
	call	Crlf

	; move on to next element
	add		edi, 4

finishLoop:
	loop	getNextInt

	popad
	pop		ebp
	ret 28
getData5 ENDP

; Gets an input from the user, validates that it is a valid integer, then saves integer at given address
; receives: address of array to store results, addresses of string used to hold value before converting, 
;			strings for error message (passed on the system stack)
; returns: user values in numList
; preconditions: none
; registers changed: none (saved to system stack and restored)
readVal PROC
	; set up system stack
	push	ebp
	mov		ebp, esp
	pushad

getInt:
	mov		edi, [ebp+8]	; address of array
	mov		edx, [ebp+12]	; input placeholder
	getString	edx, MAX_LEN

	; prepare for inner loop

	mov		esi, edx
	mov		ecx, 0
	mov		ebx, 10

strToInt:
	lodsb
	cmp		ax, 0		; if equal, reached end of the string
	je		nextString	; move on to next input (or quit if done)

	; byte is valid if it falls in ASCII int range (48 <= byte <= 57)
	cmp		ax, LO
	jb		notValid	; < 48, not valid
	cmp		ax, HI
	ja		notValid	; > 57, not valid

	; integer is valid. convert from ASCII code to integer and then add to running total
	sub		ax, LO		
	xchg	eax, ecx	
	mul		ebx			; multiply number by 10 before adding new place value
	jc		notValid	; check carry flag first (if set, number too large)
	xchg	ecx, eax	
	add		ecx, eax	; move running total back to ecx and add latest place value

	; repeat until this string is processed
	jmp		strToInt	

notValid:
	; print error messages
	displayString	[ebp+20]
	call	Crlf
	displayString	[ebp+16]

	; then get a new integer
	jmp		getInt				

nextString:
	; move integer value into array and move on to next element
	mov		[edi], ecx	

	popad
	pop		ebp
	ret		16
readVal ENDP

; Converts the given number to a string and then prints that string
; receives: value of the number (passed on system stack)
; returns: none
; preconditions: none
; registers changed: none (saved on system stack and restored)
writeVal PROC
	push	ebp
	mov		ebp, esp
	pushad			; Save regsiters

	mov		eax, [ebp+8]	; move number into eax
	push	0

; first, separate digits by place value, push on to stack
separateDigits:
	cdq
	mov		ebx, 10
	div		ebx				; remainder (in edx) is next digit to process
	add		edx, LO			; add 48 to convert from # -> corresponding ASCII code
	push	edx
	cmp		eax, 0
	jne		separateDigits

; next, take digits off stack one by one and add to placeholder string (CITE: Irvine 9.2.4)
	mov		edi, [ebp+12]	; outputStr (to be written over)
	mov		ecx, 1			; write 1 bite at a time
	cld
addToString:
	pop		eax
	stosb
	cmp		al, 0
	jne		addToString

; finally, print the string
	displayString [ebp+12]

	popad
	pop		ebp
	ret		8
writeVal ENDP

; Displays the numbers the user has entered in order, along with their sum and average.
; receives: address of first element in input array, strings to print (passed on system stack)
; returns: none
; preconditions: none
; registers changed: none (saved on system stack and restored)
displayStats5 PROC
	; set up the system stack
	push	ebp
	mov		ebp, esp

	pushad

	call	Crlf
	displayString	[ebp+24]	; "You entered the following numbers:"
	call	Crlf

	; setup for printing array
	mov		esi, [ebp+8]
	mov		ecx, NUM_TERMS
	dec		ecx

	; print out first 9 numbers, separated by a comma
printElem:
	push	[ebp+28]
	push	[esi]
	call	writeVal
	displayString	[ebp+12]	; ", "
	add		esi, 4
	loop	printElem

	; print out final number, without a comma
	push	[ebp+28]
	push	[esi]
	call	writeVal

	call	Crlf
	displayString	[ebp+20]	; "The sum of these numbers is: "

	; calculate the sum of all the numbers entered by user
	push	0
	push	[ebp+8]
	call	calculateSum
	pop		eax

	; display the calculated sum
	push	[ebp+28]
	push	eax
	call	writeVal

	call	Crlf
	displayString	[ebp+16]	; "The average is: "

	; calculate average
	push	eax
	push	NUM_TERMS
	call	calculateAverage
	pop		eax

	; display average
	push	[ebp+28]
	push	eax
	call	writeVal
	call	Crlf

	popad

	pop		ebp	
	ret 24
displayStats5 ENDP

; Calculates the total sum of numbers in a given array
; receives: placeholder value for sum, address of the first element in the array, (passed on system stack)
; returns: sum of all elements in the array (passed on the system stack)
; preconditions: none
; registers changed: none (saved on system stack and restored)
calculateSum PROC
	push	ebp
	mov		ebp, esp
	pushad

	; set up for loop
	mov		esi, [ebp+8]
	mov		ecx, NUM_TERMS		; set up loop counter
	mov		eax, 0				; initialize accumulator to 0

sumNext:
	mov		ebx, [esi]
	add		eax, ebx			; add value at current element to accumulator
	add		esi, 4				; move on to next element
	loop	sumNext

	mov		[ebp+12], eax		; move sum back to stored location on system stack

	popad
	pop		ebp
	ret		4
calculateSum ENDP

; Calculates the average of the numbers in a given array
; receives: placeholder value for average, sum of integers in array (passed on system stack)
; returns: average of all elements in the array (passed on the system stack)
; preconditions: none
; registers changed: none (saved on system stack and restored)
calculateAverage PROC
	push	ebp
	mov		ebp, esp
	pushad

	mov		eax, [ebp+12]
	cdq
	mov		ebx, [ebp+8]
	div		ebx
	mov		[ebp+12], eax

	popad
	pop		ebp
	ret		4
calculateAverage ENDP

; Procedure to introduce the program
; receives: addresses to strings containing farewell message (passed on system stack)
; returns: none
; preconditions: none
; registers changed: none
farewell5 PROC
	push	ebp
	mov		ebp, esp

	call	Crlf
	displayString [ebp+8]
	call	Crlf

	pop		ebp
	ret		4
farewell5 ENDP

END main
