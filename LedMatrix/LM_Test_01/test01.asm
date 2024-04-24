SRCLK EQU P3.6
RCLK EQU P3.5
SER EQU P3.4
LED EQU P0.7
DAT1 EQU R6
DAT2 EQU R7
	
;MOV DAT1, #0DDH
;MOV DAT2, #22H

TEST_LOOP:
					; These values choose which row to light up
MOV DAT1, #00H		; 0000 0000					0000 0000
MOV DAT2, #0FFH		; 1111 1111 -> ABCD EFGH	1111 1110 -> ABCD EFG_ (H is off)

CLR LED
SETB P0.6
ACALL SEND_BYTE
ACALL DELAY

SETB LED
CLR P0.6
ACALL SEND_BYTE
ACALL DELAY

JMP TEST_LOOP

SEND_BYTE:

SETB SRCLK
SETB RCLK

MOV A, DAT1		; A = FE
MOV R0, #8		; Loop counter
LOOP1:

RLC A
MOV SER, C

CLR SRCLK
NOP
NOP
SETB SRCLK
DJNZ R0, LOOP1

MOV R0, #8		; Loop counter
MOV A, DAT2		; A = 01

LOOP2:
RLC A
MOV SER, C

CLR SRCLK
NOP
NOP
SETB SRCLK
DJNZ R0, LOOP2

CLR RCLK
NOP
NOP
SETB RCLK

RET		; SEND_BYTE RET

DELAY:
		MOV R1, #9
HERE1:	MOV R2, #255
HERE2:	MOV R3, #255
HERE3:	DJNZ R3, HERE3
		DJNZ R2, HERE2
		DJNZ R1, HERE1
		
RET		; DELAY RET

END