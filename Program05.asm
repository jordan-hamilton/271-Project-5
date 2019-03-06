TITLE Programming Assignment #5     (Program05.asm)

; Author: Jordan Hamilton
; Last Modified: 3/4/2019
; OSU email address: hamiltj2@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 5                Due Date: 3/3/2019
; Description: This program prompts the user to enter a number of integers in the range [10, 200], then generates that many
; random integers between 100 and 999 to store in an array. The numbers are displayed to the user, then the list is sorted in
; descending order and the median value. is calculated and displayed to the user. Finally, the user is shown the same list again
; after sorting.

INCLUDE Irvine32.inc

MIN                 EQU       10
MAX                 EQU       200
LO                  EQU       100
HI                  EQU       999
NUMBERSPERLINE      EQU       10

.data

intro               BYTE      "Programming assignment #5 by Jordan Hamilton",0
instruction1        BYTE      "This program will display up to 200 random numbers after storing them in an array.",0
instruction2        BYTE      "We'll then calculate and display the median, then show you the numbers again in descending order.",0
promptForNumber     BYTE      "Please enter a positive integer between 10 and 200, inclusive: ",0
retryMsg            BYTE      "Error: This number is out of range.",0
titleUnsorted       BYTE      "Here's the list before sorting:",0
titleSorted         BYTE      "Here's the list after sorting:",0
medianMsg           BYTE      "Median value: ",0

outputSpacing       BYTE      "   ",0
numbersPrinted      DWORD     0

request             DWORD     ?
array               DWORD      MAX DUP (?)


.code

main PROC

     push      OFFSET instruction2
     push      OFFSET instruction1
     push      OFFSET intro 
     call      introduction

     push      OFFSET request
     push      OFFSET retryMsg
     push      OFFSET promptForNumber
     call      getData

     push      OFFSET array
     push      request
     call      fillArray

     push      OFFSET array
     push      request
     push      OFFSET outputSpacing
     push      OFFSET titleUnsorted
     call      displayList

     push      OFFSET array
     push      request
     call      sortList

     push      OFFSET array
     push      request
     call      displayMedian

     push      OFFSET array
     push      request
     push      OFFSET outputSpacing
     push      OFFSET titleSorted
     call      displayList
     
     ; Exit to the operating system
	invoke    ExitProcess,0

main ENDP


introduction PROC

     call      Randomize
     
     push      ebp
     mov       ebp, esp

     ; Introduce the program (and programmer)
     mov       edx, [ebp+8] 
     call      WriteString
     call      Crlf

     ; Give the user instructions on how to begin displaying array contents
     mov       edx, [ebp+12]
     call      WriteString
     call      Crlf
     mov       edx, [ebp+16]
     call      WriteString
     call      Crlf

     pop       ebp
     ret       12

introduction ENDP


getData PROC

     push      ebp
     mov       ebp, esp

     ; Store the address of result in the ebx register
     mov       ebx, [ebp+16]

     ; Ask the user for a number in the valid range, then read input from the keyboard
     ; Call the validate procedure to verify that the number was in the requested range
     readInput:
          mov       edx, [ebp+8]
          call      WriteString
          call      ReadInt

     ; Compare the entered number with the bounds of the range, jumping to the invalidInput label for values outside the range
     ; Otherwise, jump to the goodInput to continue the program
     cmp       eax, MIN
     jl        invalidInput
     cmp       eax, MAX
     jg        invalidInput
     jmp       goodInput   

     ; Display an error message, then go back to prompting for input if the entered value was too large or too small
     invalidInput:
          mov       edx, [ebp+12]
          call      WriteString
          call      Crlf
          jmp       readInput
     
     ; Store the entered integer in result once we've confirmed it's in range
     goodInput:
          mov       [ebx], eax

     pop       ebp
     ret       12

getData ENDP


fillArray PROC

     push      ebp
     mov       ebp, esp

     mov       esi, [ebp+12]
     mov       ecx, [ebp+8]
     
     fill:    
          ; Set up the range of random numbers to generate by moving the difference between the high and low numbers into eax and then incrementing
          ; eax by 1, since RandomRange uses one less than the number in eax as the upper limit.
          mov       eax, HI-LO
          inc       eax
          call      RandomRange

          ; Add our lower limit back to eax to ensure the number that was generated is back in the acceptable range, instead of starting at 0
          add       eax, LO
          
          ; Save the random number in the address at esi, then move to the address of the next element in the array and loop so we're only
          ; filling the array with the requested number of integers
          mov       [esi], eax
          add       esi, 4
          loop      fill

     pop       ebp
     ret       8

fillArray ENDP

sortList PROC
;     push      OFFSET array
;     push      request

     push      ebp
     mov       ebp, esp

     push      eax
     push      ebx
     push      edx
     push      esi

     ; Configure the loop counter for the outer loop of a Selection Sort
     mov       ecx, [ebp+8]
     dec       ecx
     mov       esi, [ebp+12]
     
     loop1:
          ; Store the address of esi before we begin our second loop
          mov       eax, esi

          ; Store the loop counter for the first loop before starting our second loop
          push      esi
          push      ecx

     loop2:
          mov       ebx, [esi]
          mov       edx, [esi+4]
          cmp       ebx, edx
          jae       endExchange

          beginExchange:
               mov       ebx, esi
               push      ebx
               add       ebx, 4
               push      ebx
               call      exchange

          ; Once we've determined whether or not we need to swap values in the array, set esi to the next value in the array
          endExchange:
               add       esi, 4

          loop      loop2

          ; Now that our second loop has ended, we need to set esi back to the address we stored in eax, increment it by 4, then pop ecx
          ; This allows us to pick up the first loop where we left off
     pop       eax
     mov       esi, eax
     add       esi, 4
     
     pop       ecx

     loop      loop1


     pop       eax
     pop       ebx
     pop       ecx   
     pop       esi  

     pop       ebp
     ret       8

sortList ENDP


exchange PROC
     push      ebp
     mov       ebp, esp

     push      eax
     push      ebx
     push      ecx
     push      edx
     push      edi

     mov       edi, [ebp+12]
     
     ; Store addresses to the first and second elements
     mov       eax, [ebp+12]
     mov       ebx, [ebp+8]
     
     mov       ecx, [eax]
     mov       edx, [ebx]

     mov       [edi], edx
     add       edi, 4
     mov       [edi], ecx

     pop       eax
     pop       ebx
     pop       ecx
     pop       edx
     pop       edi

     pop       ebp
     ret       8

exchange ENDP


displayMedian PROC

     push      ebp
     mov       ebp, esp

     pop       ebp
     ret       8

displayMedian ENDP


displayList PROC

     push      ebp
     mov       ebp, esp

     ; Store the offset of the array
     mov       esi, [ebp+20]

     ; Set ebx to 0 initially so we can track how many numbers we've printed on a line
     mov       ebx, 0

     ; Store the requested number of integers in ecx so we can loop through the array the appropriate number of times
     mov       ecx, [ebp+16]

     ; Display the title
     mov       edx, [ebp+8]
     call      WriteString
     call      Crlf

     ; If we've printed 10 numbers on a line, print a newline. If we've printed at least 1 but less than 10, print some spacing 
     ;before printing a number. Otherwise, we'll just print the number without additional formatting first
     printArray:
          cmp       ebx, NUMBERSPERLINE
          je        newLine
          cmp       ebx, 0
          jne       spacing
          jmp       printNumber

          ; Print the new line without additional spacing, then reset the line counter in ebx.
          ; We do this by skipping over the spacing label so we don't print the additional spacing
          ; after moving to a new line
          newLine:
               call      Crlf
               mov       ebx, 0
               jmp       printNumber

          ; Display some spacing if we've printed more than one number, but fewer than 10 on this line
          spacing:
               mov       edx, [ebp+12]
               call      WriteString

          ; Increment the number of integers we've printed on one line, then display the decimal value of the
          ; integer at the array index being referenced in esi. Increment esi by 4 so we can loop to display the next element
          printNumber:
               inc       ebx
               mov       eax, [esi]
               call      WriteDec
               add       esi, 4
          
          loop printArray

     ; Ensure we've moved to a new line after completely printing the array
     call      Crlf

     pop       ebp
     ret       16

displayList ENDP


END main
