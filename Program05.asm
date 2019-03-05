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
outro               BYTE      "Thanks for playing!",0

outputSpacing       BYTE      "   ",0
numbersPrinted      DWORD     0

request             DWORD     ?


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

     ;call      showComposites

     push      OFFSET outro
     call      farewell
     
     ; Exit to the operating system
	invoke    ExitProcess,0

main ENDP


introduction PROC
     
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

     ; Ask the user for a number in the valid range, then read input from the keyboard
     ; Call the validate procedure to verify that the number was in the requested range
     readInput:
          mov       edx, [ebp+8]
          call      WriteString
          call      ReadInt

     ; Compare the entered number with the bounds of the range, jumping to the invalidInput label for values outside the range
     ; Otherwise, continue the program by popping the return address into the instruction pointer from the stack
     cmp       eax, MIN
     jl        invalidInput
     cmp       eax, MAX
     jg        invalidInput
     jmp       goodInput   

     invalidInput:
          mov       edx, [ebp+12]
          call      WriteString
          call      Crlf
          jmp       readInput
     
     goodInput:
          mov       [ebp+16], eax

     pop       ebp
     ret       12

getData ENDP


farewell PROC

     push      ebp
     mov       ebp, esp
     
     ; Display the goodbye message to the user
     call      Crlf
     mov       edx, [ebp+8]
     call      WriteString

     pop       ebp
     ret       4

farewell ENDP


END main
